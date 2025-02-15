declareTest(2500, 'Covid19 TPP GP clinical to stem, correct date')
add_baseline(eid = 2500)
add_covid19_tpp_gp_clinical(eid = 2500, event_dt = '19/04/2020', code_type = 1, code = '242..', value = 10.0)
expect_measurement(person_id = 2500, measurement_date='2020-04-19')

declareTest(2501, 'Covid19 TPP GP clinical to stem, missing date')
add_baseline(eid = 2501)
add_covid19_tpp_gp_clinical(eid = 2501, event_dt = '', code_type = 1, code = '242..', value = 10.0)
expect_no_measurement(person_id = 2501, measurement_concept_id=4200295)

declareTest(2502, 'Covid19 TPP GP clinical to stem, CTV3 code measurement with value')
add_baseline(eid = 2502)
add_covid19_tpp_gp_clinical(eid = 2502, event_dt = '05/04/1995', code_type = 0, code = 'XE2q5', value=10.0)
expect_measurement(person_id = 2502, measurement_concept_id = 37392176,  value_as_number = 10, measurement_source_concept_id = 0, measurement_source_value = 'XE2q5')

declareTest(2503, 'Covid19 TPP GP clinical to stem, local TPP code')
add_baseline(eid = 2503)
add_covid19_tpp_gp_clinical(eid = 2503, event_dt = '12/03/1999', code_type = 1, code = '242..', value = 10.0)
expect_measurement(person_id = 2503, measurement_concept_id = 4060733,  measurement_source_concept_id = 45431729, measurement_source_value = '242..')

declareTest(2504, 'Covid19 TPP GP clinical to stem, code is -1')
add_baseline(eid = 2504)
add_covid19_tpp_gp_clinical(eid = 2504, event_dt = '12/03/1999', code = '-1')
expect_no_measurement(person_id = 2504)

declareTest(2505, 'Covid19 TPP GP clinical to stem, missing code')
add_baseline(eid = 2505)
add_covid19_tpp_gp_clinical(eid = 2505, event_dt = '12/03/1999', code_type = 1, value = 10.0)
expect_no_measurement(person_id = 2505, measurement_concept_id = 0)

declareTest(2506, 'Covid19 TPP GP clinical to stem, value')
add_baseline(eid = 2506)
add_covid19_tpp_gp_clinical(eid = 2506, event_dt = '12/03/1999', code_type = 1, code = '242..', value = 10.0)
expect_measurement(person_id = 2506, value_as_number = 10.0)

declareTest(2507, 'Covid19 TPP GP clinical to stem, visit_occurrence_id')
add_baseline(eid = 2507)
add_covid19_tpp_gp_clinical(eid = 2507, event_dt = '12/03/1999', code_type = 1, code = '242..', value = 10.0)
expect_measurement(person_id = 2507, visit_occurrence_id="5000250719990312")

declareTest(2508, 'Covid19 TPP GP clinical to stem, local code with value')
add_baseline(eid = 2508)
add_covid19_tpp_gp_clinical(eid = 2508, event_dt = '20/03/2021', code_type = 1, code = 'Y20d2', value = '')
expect_measurement(person_id = 2508, measurement_concept_id = 756065, value_as_concept_id = 9190)

declareTest(2509, 'Covid19 TPP GP clinical to stem, no meas when future date')
add_baseline(eid = 2509)
add_covid19_tpp_gp_clinical(eid = 2509, event_dt = '01/07/2037', code=1018251000000107)
expect_no_measurement(person_id = 2509, measurement_date = '2037-07-01')

declareTest(2510, 'Covid19 TPP GP clinical read v2 code no trailing zeros')
add_baseline(eid = 2510)
add_covid19_tpp_gp_clinical(eid = 2510, code_type = 0, code='2469.', value=10.0)
expect_measurement(person_id = 2510, measurement_concept_id = 4062019)

declareTest(2511, 'Covid19 TPPk GP clinical read v2 code no trailing zeros 2')
add_baseline(eid = 2511)
add_covid19_tpp_gp_clinical(eid = 2511, code_type = 0, code='42P..', value=10.0)
expect_measurement(person_id = 2511, measurement_concept_id = 37393863)

declareTest(2512, 'Covid19 TPP GP clinical to stem, domain_id=Measure when value_as_number > 0')
add_baseline(eid = 2512)
add_covid19_tpp_gp_clinical(eid = 2512, event_dt = '01/07/2017', code_type = 1, code='242..', value=23.0)
expect_measurement(person_id = 2512, measurement_date = '2017-07-01')

declareTest(2513, 'Covid19 TPP GP clinical to stem, domain_id=Measure when value_as_concept_id != None')
add_baseline(eid = 2513)
add_covid19_tpp_gp_clinical(eid = 2513, event_dt = '01/07/2017', code_type=1, code='Y20d2', value='')
expect_measurement(person_id = 2513, measurement_date = '2017-07-01')

declareTest(2514, 'Covid19 TPP GP clinical to stem, domain_id=None when value_as_number == 0')
add_baseline(eid = 2514)
add_covid19_tpp_gp_clinical(eid = 2514, event_dt = '01/07/2017', code_type=1, code='242..', value=0.0)
expect_no_measurement(person_id = 2514, measurement_date = '2017-07-01')
expect_condition_occurrence(person_id = 2514, condition_start_date='2017-07-01', condition_concept_id=4060733)

declareTest(2515, 'Covid19 TPP GP clinical to stem, G801. to condition')
add_baseline(eid = 2515)
add_covid19_tpp_gp_clinical(eid = 2515, event_dt = '01/07/2018', code_type=1, code='G801.', value=0)
expect_condition_occurrence(person_id = 2515, condition_start_date='2018-07-01', condition_concept_id=77310)

declareTest(2516, 'Covid19 TPP GP clinical to stem, CTV3 code to observation')
add_baseline(eid = 2516)
add_covid19_tpp_gp_clinical(eid = 2516, event_dt = '01/07/2019', code_type = 0, code = 'XaF8d')
expect_observation(person_id = 2516, observation_concept_id = 4200295,  observation_source_value = 'XaF8d')

declareTest(2517, 'Covid19 TPP GP clinical to stem, CTV3 code measurement without value')
add_baseline(eid = 2517)
add_covid19_tpp_gp_clinical(eid = 2517, event_dt = '01/07/2020', code_type = 0, code = 'XaJVi', value=NULL)
expect_measurement(person_id = 2517, measurement_concept_id = 4136881,  value_as_number = NULL, measurement_source_value = 'XaJVi')

declareTest(2518, 'Covid19 TPP GP clinical to stem, CTV3 code drug one-to-many')
add_baseline(eid = 2518)
add_covid19_tpp_gp_clinical(eid = 2518, event_dt = '01/01/2005', code_type = 1, code = '65KZ.', value=NULL)
expect_drug_exposure(person_id = 2518, drug_exposure_start_date = '2005-01-01', drug_exposure_end_date = '2005-01-01',
                     drug_concept_id = 529411,  drug_source_value = '65KZ.', drug_source_concept_id = 45482248)
expect_drug_exposure(person_id = 2518, drug_exposure_start_date = '2005-01-01', drug_exposure_end_date = '2005-01-01',
                     drug_concept_id = 529303,  drug_source_value = '65KZ.', drug_source_concept_id = 45482248)
expect_procedure_occurrence(person_id = 2518, procedure_date = '2005-01-01', procedure_concept_id = 3655690,
                            procedure_source_value = '65KZ.', procedure_source_concept_id = 45482248)
expect_drug_era(person_id = 2518, drug_concept_id = 529411)
expect_drug_era(person_id = 2518, drug_concept_id = 529303)

declareTest(2519, 'Covid19 TPP GP clinical to stem, ctv3 DVT (Xa9Bs) condition')
add_baseline(eid = 2519)
add_covid19_tpp_gp_clinical(eid = 2519, event_dt = '01/07/2022', code_type=0, code='Xa9Bs', value=NULL)
expect_condition_occurrence(person_id = 2519, condition_start_date='2022-07-01', condition_concept_id=443537)

declareTest(2520, 'Covid19 TPP GP clinical to stem, ctv3 eGFR (XacUK) condition')
add_baseline(eid = 2520)
add_covid19_tpp_gp_clinical(eid = 2520, event_dt = '01/07/2022', code_type=0, code='XacUK', value=12)
expect_measurement(person_id = 2520, measurement_date='2022-07-01', measurement_concept_id=37393011)