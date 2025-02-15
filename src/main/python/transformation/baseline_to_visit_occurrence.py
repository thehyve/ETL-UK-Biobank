from __future__ import annotations

from typing import List, TYPE_CHECKING
import pandas as pd

from ..util import get_datetime, create_baseline_visit_occurrence_id

if TYPE_CHECKING:
    from src.main.python.wrapper import Wrapper


def baseline_to_visit_occurrence(wrapper: Wrapper) -> List[Wrapper.cdm.VisitOccurrence]:
    source = wrapper.source_data.get_source_file('baseline.csv')
    df = source.get_csv_as_df(apply_dtypes=False,
                              usecols=['eid', '54-0.0', '54-1.0', '54-2.0', '54-3.0',
                                       '53-0.0', '53-1.0', '53-2.0', '53-3.0'])
    for _, row in df.iterrows():
        person_id = row['eid']
        # One-day visits for instances 0 to 3
        for instance in range(4):
            # Field_id 53 contains the date of the visit
            date_column = f'53-{instance}.0'
            if row[date_column] == '' or pd.isna(row[date_column]):
                continue

            date = get_datetime(row[date_column])

            # Field_id 54 contains the assessment centre
            assessment_center = row.get(f'54-{instance}.0', None)

            yield wrapper.cdm.VisitOccurrence(
                visit_occurrence_id=create_baseline_visit_occurrence_id(row['eid'], instance),
                person_id=person_id,
                visit_concept_id=44818519,  # Clinical Study Visit
                visit_start_date=date.date(),
                visit_start_datetime=date,
                visit_end_date=date.date(),
                visit_end_datetime=date,
                visit_type_concept_id=32883,  # Survey
                care_site_id=None if pd.isna(assessment_center) else assessment_center,
                record_source_value=f'baseline-{instance}',
                data_source='baseline'
            )
