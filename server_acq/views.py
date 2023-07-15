from flask import Flask, jsonify, abort
import json
from server_acq import app

sensor_manifest_path='sensors-mock/sensors_manifest.json'

@app.route('/')
def home():
    return jsonify({"message": "Main dashboard"})
    # return render_template('home.html')

@app.route('/about')
def about():
    return jsonify({"message" : "About page"})

# Load sensor data from the JSON file
with open(sensor_manifest_path) as f:
    sensor_data = json.load(f)

@app.route('/sensors', methods=['GET'])
def get_sensor_types():
    with open(sensor_manifest_path) as f:
        data = json.load(f)

    sensor_types = [sensor['type'] for sensor in data['sensors']]
    return jsonify(sensor_types), 200


@app.route('/sensors/<type>', methods=['GET'])
def get_sensors_of_type(type):
    with open(sensor_manifest_path) as f:
        data = json.load(f)

    for sensor in data['sensors']:
        if sensor['type'] == type:
            return jsonify(sensor['sensors']), 200

    abort(404)

@app.route('/sensors/<string:sensor_type>/<string:sensor_id>', methods=['GET'])
def get_sensor_data(sensor_type, sensor_id):
    # Find the sensor type in the sensor_data
    for sensor_type_obj in sensor_data['sensors']:
        if sensor_type_obj['type'] == sensor_type:
            # Check if the requested sensor ID is in this sensor type's list
            if sensor_id in sensor_type_obj['sensors']:
                # If it is, return the sensor's data
                # You might want to replace this with a function that reads the sensor's actual data
                return jsonify({ 'type': sensor_type, 'id': sensor_id })
    # If we didn't find the requested sensor, return a 404
    abort(404)
