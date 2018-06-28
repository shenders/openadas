# Copyright 2014-2018 United Kingdom Atomic Energy Authority
#
# Licensed under the EUPL, Version 1.1 or – as soon they will be approved by the
# European Commission - subsequent versions of the EUPL (the "Licence");
# You may not use this work except in compliance with the Licence.
# You may obtain a copy of the Licence at:
#
# https://joinup.ec.europa.eu/software/page/eupl5
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.
#
# See the Licence for the specific language governing permissions and limitations
# under the Licence.

import os
import json
import numpy as np
from cherab.core.utility import RecursiveDict
from cherab.core.atomic import Element

"""
Utilities for managing the local rate repository.
"""

# todo: make this a configuration option in a json file, add options to setup.py to set them during install
DEFAULT_REPOSITORY_PATH = os.path.expanduser('~/.cherab/openadas/repository')


def encode_transition(transition):
    """
    Generate a key string from a transition.

    Both integer and string transition descriptions are handled.
    """

    upper, lower = transition

    upper = str(upper).lower()
    lower = str(lower).lower()

    return '{} -> {}'.format(upper, lower)


def valid_ionisation(element, ionisation):
    """
    Returns true if the element can be ionised to the specified level.

    :param ionisation: Integer ionisation level.
    :return: True/False.
    """
    return ionisation <= element.atomic_number



