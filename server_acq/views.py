from flask import render_template
from server_acq import app

@app.route('/')
def home():
    return 'hola mundo'
    # return render_template('home.html')
