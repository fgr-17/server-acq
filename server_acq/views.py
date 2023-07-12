from flask import Flask, jsonify
from server_acq import app

@app.route('/')
def home():
    return jsonify({"message": "Main dashboard"})
    # return render_template('home.html')

@app.route('/about')
def about():
    return jsonify({"message" : "About page"})

# @app.route('/sensors')
# def about():
#     return jsonify({"sensors classes" : [{"name" : "level"},
#                                          {"name" : "height"},
#                                          {"name" : "chlorine"}]
#                                          })