#!/usr/bin/python3

import os
import json

# read the json file
with open('sensors_manifest.json') as f:
    data = json.load(f)

base_dir = 'sensors'

# iterate over the sensor types
for sensor_type in data['sensors']:
    type_name = sensor_type['type']
    # iterate over the sensor ids
    for sensor_id in sensor_type['sensors']:
        # create directory path
        dir_path = os.path.join(base_dir, type_name, sensor_id)
        # create directories
        print(dir_path)
        os.makedirs(dir_path, exist_ok=True)
