from __future__ import annotations

from typing import List, TYPE_CHECKING
import pandas as pd
from delphyne.model.mapping.code_mapper import CodeMapping

from ..util import get_datetime, add_dot_to_opcsx_code, create_hes_visit_occurrence_id, create_hes_visit_detail_id, refactor_opcs_code


if TYPE_CHECKING:
    from src.main.python.wrapper import Wrapper


def hesin_oper_to_procedure_occurrence(wrapper: Wrapper) -> List[Wrapper.cdm.ProcedureOccurrence]:
    # Load hesin and hesin_oper tables, with selected columns to avoid memory failures
    hesin_oper_source = wrapper.source_data.get_source_file('hesin_oper.csv')
    hesin_oper = hesin_oper_source.get_csv_as_df(apply_dtypes=False, usecols=['eid', 'ins_index',
                                                                              'oper4', 'oper3',
                                                                              'opdate', 'level'])
    hesin_source = wrapper.source_data.get_source_file('hesin.csv')
    hesin = hesin_source.get_csv_as_df(apply_dtypes=False, usecols=['eid', 'ins_index', 'spell_index',
                                                                   'dsource'])
    hesin = hesin.drop_duplicates(subset=['eid', 'ins_index'])  # fix for synthetic data

    df = hesin_oper.merge(hesin, on=['eid', 'ins_index'], how='left', suffixes=('', '_x'))
    df['oper4_ref'] = df['oper4'].apply(refactor_opcs_code)
    df['oper4_dot'] = df['oper4_ref'].apply(add_dot_to_opcsx_code)

    oper4 = wrapper.code_mapper.generate_code_mapping_dictionary('OPCS4')
    oper3 = wrapper.mapping_tables_lookup('./resources/mapping_tables/opcs3.csv', first_only=False)

    for _, row in df.iterrows():
        person_id = row['eid']

        procedure_date = get_datetime(row['opdate'], "%d/%m/%Y")

        if row['oper4'] in ['X998', 'X999']:
            continue

        if not pd.isnull(row['oper4']):
            source_value = row['oper4']
            procedure_targets = oper4.lookup(row['oper4_dot'])
        elif not pd.isnull(row['oper3']):
            source_value = row['oper3']
            procedure_targets = []
            for target_concept_id in oper3.get(row['oper3'], [0]):  # if oper3 code not found, at least create a target 0
                procedure_target = CodeMapping()
                procedure_target.source_concept_code = row['oper3']
                procedure_target.target_concept_id = target_concept_id
                procedure_target.source_concept_id = 0
                procedure_targets.append(procedure_target)
        else:
            continue

        # Visit
        visit_occurrence_id = create_hes_visit_occurrence_id(row['eid'], row['spell_index'])
        visit_detail_id = create_hes_visit_detail_id(row['eid'], row['ins_index'])

        for target in procedure_targets:
            yield wrapper.cdm.ProcedureOccurrence(
                person_id=person_id,
                procedure_concept_id=target.target_concept_id,
                procedure_date=procedure_date,
                procedure_datetime=procedure_date,
                procedure_type_concept_id=32817,  # EHR
                procedure_source_value=source_value,
                procedure_source_concept_id=target.source_concept_id,
                visit_occurrence_id=visit_occurrence_id,
                visit_detail_id=visit_detail_id,
                data_source=f'HES-{row["dsource"]}'
            )
