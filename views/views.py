""" Flask paths main file """

import json
import logging
from datetime import timedelta
from functools import wraps
from html import escape

from flask import jsonify, abort

from flask import session, redirect, url_for, request, render_template


SENSOR_MANIFEST_PATH = 'sensors-mock/sensors_manifest.json'

users = {"a": "a", "b": "b"}


def login_required(f):

    """ Decorator to require login on a particular path """

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'username' not in session:
            return redirect(url_for('login', next=request.url))
        return f(*args, **kwargs)
    return decorated_function


def init_app(app):

    """ install all the api paths """

    @app.route('/')
    def index():
        if 'username' in session:
            return f'Logged in as {escape(session["username"])}'
        return redirect(url_for('login'))

    @app.route('/login', methods=['GET', 'POST'])
    def login():
        logging.info('entering in /login')
        error = None
        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']

            if username not in users or users[username] != password:
                error = 'Invalid credentials'
            else:
                session['username'] = username
                session.permanent = True
                app.permanent_session_lifetime = timedelta(minutes=5)
                return redirect(url_for('index'))
        return render_template('login.html', error=error)

    @app.route('/logout')
    def logout():
        session.pop('username', None)
        return redirect(url_for('index'))

    @app.route('/about')
    @login_required
    def about():
        return jsonify({"message": "About page"})

    # Load sensor data from the JSON file
    with open(SENSOR_MANIFEST_PATH, encoding="utf-8") as f:
        sensor_data = json.load(f)

    @app.route('/sensors', methods=['GET'])
    @login_required
    def get_sensor_types():
        with open(SENSOR_MANIFEST_PATH, encoding="utf-8") as f:
            data = json.load(f)

        sensor_types = [sensor['type'] for sensor in data['sensors']]
        return jsonify(sensor_types), 200

    @app.route('/sensors/<stype>', methods=['GET'])
    @login_required
    def get_sensors_of_type(stype):
        with open(SENSOR_MANIFEST_PATH, encoding="utf-8") as f:
            data = json.load(f)

        for sensor in data['sensors']:
            if sensor['type'] == stype:
                return jsonify(sensor['sensors']), 200

        abort(404)

    @app.route('/sensors/<string:sensor_type>/<string:sensor_id>', methods=['GET'])
    @login_required
    def get_sensor_data(sensor_type, sensor_id):
        # Find the sensor type in the sensor_data
        for sensor_type_obj in sensor_data['sensors']:
            if sensor_type_obj['type'] == sensor_type:
                # Check if the requested sensor ID is in this sensor type's list
                if sensor_id in sensor_type_obj['sensors']:
                    # If it is, return the sensor's data
                    # You might want to replace this with a function that reads the sensor's actual data
                    return jsonify({'type': sensor_type, 'id': sensor_id})
        # If we didn't find the requested sensor, return a 404
        abort(404)
