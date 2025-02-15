select
--     source_numeric.concept_id,
    source_numeric.concept_code as "sourceCode",
    source_numeric.concept_name as "sourceName",
    -1 as "sourceFrequency",
    '' as "sourceAutoAssignedConceptIds",
    0 as "matchScore",
    'UNREVIEWED' as "equivalence",
    'UNCHECKED' as "mappingStatus",
    '' as "statusSetBy",
    0 as "statusSetOn",
    coalesce(target.concept_id,0) as "conceptId",
    coalesce(target.concept_name, 'Unmapped') as "conceptName",
    target.domain_id as "domainId",
    upper(replace(relationship_id, ' ', '_')) as "mappingType",
    '' as "comment",
    '<athena>' as "createdBy",
    round(extract(epoch from now())) as "createdOn",
    '' as "assignedReviewer"
from (select source.concept_id, source.concept_name, source.concept_code, source.vocabulary_id, source.concept_class_id
      from vocab.concept source
      left join vocab.concept_relationship cra on cra.concept_id_1 = concept_id and
                (cra.relationship_id like 'Has Answer' or cra.relationship_id like 'Has Value')
      where cra.concept_id_2 is null and source.vocabulary_id = 'UK Biobank'
        and concept_class_id in ('Variable', 'Question')
        -- exclude some administrative and all fields on wearable data (90xxx)
        and strpos(source.concept_name, 'device ID') = 0
        and strpos(source.concept_name, 'acquisition time') = 0
        and strpos(source.concept_name, 'timestamp') = 0
        and strpos(source.concept_name, 'timestamp (pilot)') = 0
        and strpos(source.concept_name, 'assay date') = 0
        and strpos(source.concept_name, ' flag') = 0
        and not (left(source.concept_code, 1) = '9' and cast(source.concept_code as integer) between 90000 and 91000)
     ) as source_numeric
         left join vocab.concept_relationship on
            concept_id_1 = concept_id and
            relationship_id like 'Maps to%'
         left join vocab.concept target on concept_id_2 = target.concept_id
where source_numeric.vocabulary_id = 'UK Biobank'
  and source_numeric.concept_code not in (
        '30850',
'30850',
'30720',
'30720',
'30250',
'30250',
'2744',
'2744',
'30150',
'30150',
'30050',
'30050',
'30650',
'30650',
'30324',
'30324',
'30860',
'30860',
'2754',
'2754',
'30011',
'30011',
'30111',
'30111',
'30730',
'30730',
'30251',
'30251',
'3546',
'3546',
'30424',
'30424',
'30151',
'30151',
'30740',
'30740',
'30051',
'30051',
'30870',
'30870',
'30660',
'30660',
'30120',
'30120',
'2764',
'2764',
'30880',
'30880',
'30670',
'30670',
'30160',
'30160',
'30700',
'30700',
'30260',
'30260',
'3786',
'3786',
'3786',
'30500',
'30500',
'30334',
'30020',
'30020',
'30680',
'30680',
'30890',
'30890',
'30121',
'30121',
'30140',
'30140',
'30690',
'30690',
'30710',
'30710',
'30820',
'30820',
'30130',
'30130',
'30770',
'30770',
'30060',
'30060',
'3894',
'3894',
'3894',
'30240',
'30240',
'30830',
'30830',
'30510',
'30510',
'30344',
'30344',
'30780',
'30780',
'30021',
'30021',
'189',
'30620',
'30620',
'30141',
'30141',
'30840',
'30840',
'30131',
'30131',
'30040',
'30040',
'30790',
'30790',
'30520',
'30520',
'30630',
'30630',
'30800',
'30800',
'3992',
'3992',
'3992',
'30241',
'30241',
'30030',
'30030',
'30354',
'30354',
'2734',
'2734',
'30530',
'30530',
'30810',
'30810',
'30750',
'30750',
'30640',
'30640',
'30041',
'30041',
'30600',
'30600',
'30100',
'30100',
'30031',
'30031',
'30171',
'30171',
'30760',
'30760',
'2824',
'2824',
'30364',
'30364',
'30271',
'30271',
'30090',
'30090',
'30610',
'30610',
'30180',
'30180',
'4012',
'4012',
'4012',
'2966',
'2966',
'30000',
'30000',
'41149',
'50',
'50',
'30394',
'30394',
'30280',
'30280',
'30091',
'30091',
'3064',
'3064',
'51',
'51',
'30300',
'30300',
'30101',
'30101',
'2976',
'2976',
'2976',
'30181',
'30181',
'30071',
'30071',
'4689',
'4689',
'4689',
'30404',
'30404',
'3160',
'3160',
'30001',
'30001',
'30080',
'30080',
'41234',
'4700',
'4700',
'4700',
'30110',
'30110',
'30161',
'30161',
'30281',
'30281',
'30414',
'30414',
'93',
'93',
'30301',
'30301',
'41235',
'30081',
'30081',
'30010',
'30010',
'2794',
'2794',
'3536',
'3536',
'3536',
'30170',
'30170',
'30261',
'30261',
'30374',
'30374',
'30211',
'30211',
'30314',
'30314',
'20006',
'94',
'94',
'41259',
'30220',
'30220',
'3062',
'3062',
'30270',
'30270',
'30061',
'30061',
'30384',
'30384',
'4079',
'4079',
'2804',
'2804',
'102',
'102',
'30290',
'30290',
'30200',
'30200',
'41261',
'30221',
'30221',
'40008',
'40008',
'47',
'47',
'20009',
'20009',
'3063',
'3063',
'34',
'4080',
'4080',
'20007',
'20007',
'48',
'48',
'30070',
'30070',
'4194',
'4194',
'40009',
'49',
'49',
'4022',
'4022',
'4022',
'30201',
'30201',
'46',
'46',
'30230',
'30230',
'30291',
'30291',
'30190',
'30190',
'4056',
'4056',
'4056',
'40425',
'40425',
'30210',
'30210',
'20010',
'20010',
'30897',
'30897',
'20008',
'20008',
'30191',
'30191',
'30191',
'40007',
'40007',
'30231',
'30231'
    )
order by source_numeric.concept_code, relationship_id
;