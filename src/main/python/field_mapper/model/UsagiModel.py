# Copyright 2020 The Hyve
#
# Licensed under the GNU General Public License, version 3,
# or (at your option) any later version (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.gnu.org/licenses/
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# !/usr/bin/env python3
from enum import Enum
from datetime import datetime

from src.main.python.field_mapper.util.type_conversion import to_int


class MappingStatus(Enum):
    UNCHECKED = 1
    APPROVED = 2
    IGNORED = 3
    FLAGGED = 4


class MappingType(Enum):
    EVENT = 1
    VALUE = 2
    UNIT = 3

    @classmethod
    def get(cls, value):
        # Translate new MAPS_TO relationships to old names
        if value == 'MAPS_TO':
            value = 'EVENT'
        elif value == 'MAPS_TO_VALUE':
            value = 'VALUE'
        elif value == 'MAPS_TO_UNIT':
            value = 'UNIT'
        return cls[value]


class UsagiRow:

    def __init__(self, row, filename):
        self.field_id: str = row['sourceCode'].strip()
        self.field_description: str = row['sourceName'].strip()
        self.value_code: str = row.get('sourceValueCode', '').strip()
        self.value_description: str = row.get('sourceValueName', '').strip()
        self.unit_description: str = row.get('sourceUnitName', '').strip()
        self.target: TargetMapping = TargetMapping(row)
        self.status: MappingStatus = MappingStatus[row['mappingStatus']]
        self.comment: str = row['comment']
        self.source_file_name: str = filename  # For provenance of data


class TargetMapping:

    def __init__(self, row):
        self.concept_id: int = int(row['conceptId'])
        self.created_by: str = row['createdBy']
        self.created_on: datetime = datetime.fromtimestamp(to_int(row['createdOn'])/1000)
        self.type: MappingType = MappingType.get(row['mappingType'])
        self.status_set_by: str = row['statusSetBy']
        self.status_set_on: datetime = datetime.fromtimestamp(to_int(row['statusSetOn'])/1000)

    def __str__(self):
        return f'concept_id: {self.concept_id}, ' \
               f'type: {self.type}'

    def __eq__(self, other):
        return self.concept_id == other.concept_id and \
               self.created_by == other.created_by and \
               self.created_on == other.created_on and \
               self.type == other.type and \
               self.status_set_by == other.status_set_by and \
               self.status_set_on == other.status_set_on


def create_fake_target_mapping(concept_id):
    # For use with a fixed event_concept_id
    return TargetMapping({
        'conceptId': concept_id,
        'createdBy': '<config>',
        'createdOn': '0',
        'mappingType': 'EVENT',
        'statusSetBy': '<config>',
        'statusSetOn': '0'
    })
