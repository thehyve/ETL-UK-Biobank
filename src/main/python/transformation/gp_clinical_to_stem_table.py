from __future__ import annotations

from typing import List, TYPE_CHECKING
import csv

from ..util import is_null, extend_read_code, create_gp_visit_occurrence_id
from ..gp_mapper import GpClinicalValueMapper

if TYPE_CHECKING:
    from src.main.python.wrapper import Wrapper


def gp_clinical_to_stem_table(wrapper: Wrapper) -> List[Wrapper.cdm.StemTable]:
    source = wrapper.source_data.get_source_file('gp_clinical.csv')
    rows = source.get_csv_as_generator_of_dicts()

    # load dictionary of special Read v2 dot code mappings (i.e. alternative to adding 00)
    with open('resources/mapping_tables/gp_clinical_read2_alternative_dot_code_mappings.csv') as f:
        next(f)  # Skip provenance info
        next(f)  # Skip the header
        reader = csv.reader(f)
        read_v2_mapping_dict = dict(row[1:] for row in reader if row)  # skip 1st column

    # Note: if we add restricting to codes, we might miss some added from the phenotype_logic
    read2_mapper = wrapper.code_mapper.generate_code_mapping_dictionary('Read')
    read3_lookup = wrapper.mapping_tables_lookup('resources/mapping_tables/ctv3.csv', approved_only=False, first_only=False)
    unit_lookup = wrapper.mapping_tables_lookup('resources/mapping_tables/gp_clinical_units.csv')
    value_mapper = GpClinicalValueMapper(mapping_dict=read_v2_mapping_dict)

    for row in rows:
        # read_2 and read_3 should be mutually exclusive
        if not is_null(row['read_2']):
            read_col = 'read_2'
        elif not is_null(row['read_3']):
            read_col = 'read_3'
        # at least one code should be present for the mapping to be meaningful
        else:
            continue

        event_date = wrapper.get_gp_datetime(row['event_dt'],
                                             person_source_value=row['eid'],
                                             format="%d/%m/%Y",
                                             default_date=None)

        if not event_date:
            continue

        data_source = 'GP-' + row['data_provider'] if not is_null(row['data_provider']) else None

        visit_id = create_gp_visit_occurrence_id(row['eid'], event_date)

        unit_source_value, unit_concept_id, operator = None, None, None
        if not is_null(row['value3']):
            if row['value3'].startswith('OPR'):
                operator = row['value3'][3:]
            else:
                unit_source_value = row['value3']
                unit_concept_id = unit_lookup.get(row['value3'], 0)

        source_read_code = row[read_col]
        # temporarily extract mapping as Read v2 code, might be used even if CTV3
        source_read_code_extended = extend_read_code(source_read_code, read_v2_mapping_dict)
        source_read_mapping = read2_mapper.lookup(source_read_code_extended, first_only=True)

        map_as_read_code_and_value = value_mapper.lookup(row, read_col)
        for map_as_read_code, value_as_number in map_as_read_code_and_value:
            # temporarily extract mapping as Read v2 code, might be used even if CTV3
            map_as_read_code_extended = extend_read_code(map_as_read_code, read_v2_mapping_dict)
            target_read2_mappings = read2_mapper.lookup(map_as_read_code_extended, first_only=False)
            if read_col == 'read_2':
                target_concept_ids = [x.target_concept_id for x in target_read2_mappings]
                source_concept_id = source_read_mapping.source_concept_id
            else:  # read_col == 'read_3'
                target_concept_ids = read3_lookup.get(map_as_read_code, None)
                source_concept_id = 0
                # If read_3 code not mapped to standard concept_id using v3 mapper, try v2 mapper
                if target_concept_ids is None:
                    if source_read_mapping.source_concept_id != 0:
                        target_concept_ids = [x.target_concept_id for x in target_read2_mappings]
                        source_concept_id = source_read_mapping.source_concept_id
                    else:
                        target_concept_ids = [0]

            for target_concept_id in target_concept_ids:
                yield wrapper.cdm.StemTable(
                    person_id=row['eid'],
                    # Always override concept.domain_id, also if the concept is from condition domain
                    domain_id='Measurement',
                    type_concept_id=32817,
                    start_date=event_date,
                    start_datetime=event_date,
                    visit_occurrence_id=visit_id,
                    concept_id=target_concept_id,
                    source_concept_id=source_concept_id,
                    source_value=source_read_code,  # original before adding cyphers after dots
                    operator_concept_id=operator,
                    unit_concept_id=unit_concept_id,
                    unit_source_value=unit_source_value,
                    value_as_number=value_as_number,
                    data_source=data_source
                )
