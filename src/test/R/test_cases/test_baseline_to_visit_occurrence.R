# test IDs 700-799

declareTest(700, 'baseline to visit occurrence')
add_baseline(eid = 700, `53-0.0` = '2009-11-20', `53-1.0` = '2010-01-01', `53-2.0` = '2010-06-15', `53-3.0` = '2011-02-06')
expect_count_visit_occurrence(4, person_id = 700, visit_concept_id = 44818519)
expect_visit_occurrence(person_id = 700, visit_concept_id = 44818519, visit_start_date = '2009-11-20',
                        visit_end_date = '2009-11-20', visit_type_concept_id = 32883)
expect_visit_occurrence(person_id = 700, visit_concept_id = 44818519, visit_start_date = '2010-01-01', 
                        visit_end_date = '2010-01-01', visit_type_concept_id = 32883)
expect_visit_occurrence(person_id = 700, visit_concept_id = 44818519, visit_start_date = '2010-06-15', 
                        visit_end_date = '2010-06-15', visit_type_concept_id = 32883)
expect_visit_occurrence(person_id = 700, visit_concept_id = 44818519, visit_start_date = '2011-02-06', 
                        visit_end_date = '2011-02-06', visit_type_concept_id = 32883)

declareTest(701, 'baseline to visit occurrence with missing dates')
add_baseline(eid = 701, `53-0.0` = '2009-11-20', `53-1.0` = '2010-01-01', `53-2.0` = '', `53-3.0` = '')
expect_count_visit_occurrence(2, person_id = 701, visit_concept_id = 44818519)
expect_visit_occurrence(person_id = 701, visit_concept_id = 44818519, visit_start_date = '2009-11-20',
                        visit_end_date = '2009-11-20', visit_type_concept_id = 32883)
expect_visit_occurrence(person_id = 701, visit_concept_id = 44818519, visit_start_date = '2010-01-01', 
                        visit_end_date = '2010-01-01', visit_type_concept_id = 32883)

declareTest(702, 'baseline to visit occurrence with multiple centre of cares')
add_baseline(eid = 702, `53-0.0` = '2009-11-20', `53-1.0` = '2010-01-01')
expect_count_visit_occurrence(2, person_id = 702, visit_concept_id = 44818519)
expect_visit_occurrence(person_id = 702, visit_concept_id = 44818519, visit_start_date = '2009-11-20',
                        visit_end_date = '2009-11-20', visit_type_concept_id = 32883)
expect_visit_occurrence(person_id = 702, visit_concept_id = 44818519, visit_start_date = '2010-01-01',
                        visit_end_date = '2010-01-01', visit_type_concept_id = 32883)

# TODO: test care site logic from corresponding instance
