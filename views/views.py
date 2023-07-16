from flask import jsonify, abort
import json
import logging

from flask import Flask


sensor_manifest_path='sensors-mock/sensors_manifest.json'

from flask import session, redirect, url_for, escape, request, render_template
from datetime import timedelta
from functools import wraps

users = {"a": "a", "b": "b"}

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'username' not in session:
            return redirect(url_for('login', next=request.url))
        return f(*args, **kwargs)
    return decorated_function


def init_app(app):

    @app.route('/')
    def index():
        logging.info(f'entering in /')
        if 'username' in session:
            return 'Logged in as %s' % escape(session['username'])
        return redirect(url_for('login'))

    @app.route('/login', methods=['GET', 'POST'])
    def login():
        logging.info(f'entering in /login')
        error = None
        if request.method == 'POST':
            username = request.form['username']
            password = request.form['password']

            if not username in users or users[username] != password:
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
        return jsonify({"message" : "About page"})

    # Load sensor data from the JSON file
    with open(sensor_manifest_path) as f:
        sensor_data = json.load(f)

    @app.route('/sensors', methods=['GET'])
    @login_required
    def get_sensor_types():
        with open(sensor_manifest_path) as f:
            data = json.load(f)

        sensor_types = [sensor['type'] for sensor in data['sensors']]
        return jsonify(sensor_types), 200

    @app.route('/sensors/<type>', methods=['GET'])
    @login_required
    def get_sensors_of_type(type):
        with open(sensor_manifest_path) as f:
            data = json.load(f)

        for sensor in data['sensors']:
            if sensor['type'] == type:
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
                    return jsonify({ 'type': sensor_type, 'id': sensor_id })
        # If we didn't find the requested sensor, return a 404
        abort(404)
