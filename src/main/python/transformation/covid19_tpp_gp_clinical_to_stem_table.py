from __future__ import annotations

from typing import List, TYPE_CHECKING
import csv
from src.main.python.util import create_gp_tpp_visit_occurrence_id, is_null, extend_read_code


if TYPE_CHECKING:
    from src.main.python.wrapper import Wrapper


def covid19_tpp_gp_clinical_to_stem_table(wrapper: Wrapper) -> List[Wrapper.cdm.StemTable]:
    source = wrapper.source_data.get_source_file('covid19_tpp_gp_clinical.csv')
    rows = source.get_csv_as_generator_of_dicts()

    # Load the vocabulary mapping tables
    # load dictionary of special Read v2 dot code mappings (i.e. alternative to adding 00)
    with open('resources/mapping_tables/gp_clinical_read2_alternative_dot_code_mappings.csv') as f:
        next(f)  # Skip provenance info
        next(f)  # Skip the header
        reader = csv.reader(f)
        read_v2_mapping_dict = dict(row[1:] for row in reader if row)  # skip 1st column

    # Note: if we add restricting to codes, we might miss some added from the phenotype_logic
    # TODO: observed multiple mappings for vaccines to SNOMED and CVX, which is better?
    read2_mapper = wrapper.code_mapper.generate_code_mapping_dictionary('Read')
    ctv3_lookup = wrapper.mapping_tables_lookup('resources/mapping_tables/ctv3.csv',
                                                approved_only=False, first_only=False)
    local_tpp_lookup = wrapper.mapping_tables_lookup("resources/mapping_tables/gp_clinical_covid.csv",
                                                     approved_only=False, first_only=False)
    value_mapping_lookup = wrapper.mapping_tables_lookup("resources/mapping_tables/covid_value_mapping.csv",
                                                         approved_only=True)

    for row in rows:
        if is_null(row['code']) or row['code'] == '-1':
            continue

        # Date
        event_date = wrapper.get_gp_datetime(row['event_dt'],
                                             person_source_value=row['eid'],
                                             format="%d/%m/%Y",
                                             default_date=None)
        if not event_date:
            continue

        # If 'code_type' = '0'   use CTV3 lookup. 
        # If 'code_type’ = '1'   use Local TPP lookup. 
        source_concept_id = 0
        target_concept_ids = None
        if row["code_type"] == '0':
            target_concept_ids = ctv3_lookup.get(row['code'], None)
        elif row["code_type"] == '1':
            target_concept_ids = local_tpp_lookup.get(row['code'], None)

        # If no mapping found, try read2
        if target_concept_ids is None:
            read_code_extended = extend_read_code(row['code'], read_v2_mapping_dict)
            target_read_mappings = read2_mapper.lookup(read_code_extended)
            target_concept_ids = [x.target_concept_id for x in target_read_mappings]
            source_concept_id = target_read_mappings[0].source_concept_id if target_read_mappings else 0

        # Add value, only if numeric
        try:
            value_as_number = float(row['value'])
        except ValueError:
            value_as_number = None

        visit_id = create_gp_tpp_visit_occurrence_id(row['eid'], event_date)

        value_as_concept_id = value_mapping_lookup.get(row['code'], None)

        # override the target domain (concept.domain_id) to be 'Measurement' if necessary
        domain_id = None
        if (value_as_number is not None and value_as_number != 0.0) or (value_as_concept_id is not None):
            domain_id = 'Measurement'

        # Insert terms in stem_table
        for target_concept_id in target_concept_ids:
            yield wrapper.cdm.StemTable(
                person_id=row['eid'],
                concept_id=target_concept_id,
                source_value=row['code'],
                source_concept_id=source_concept_id,
                start_date=event_date,
                start_datetime=event_date,
                value_as_number=value_as_number,
                visit_occurrence_id=visit_id,
                value_as_concept_id=value_as_concept_id,
                domain_id=domain_id,
                type_concept_id=32817,     # 32817: EHR
                data_source='covid19 gp_tpp'
            )
