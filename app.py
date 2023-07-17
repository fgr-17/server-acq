#!/opt/venv/bin/python

""" Main app """

import logging
from version import git_hash, git_branch
from flask import Flask
import views

logging.basicConfig(level=logging.INFO)
logging.info('Starting acquisition server ...')
logging.info('Version: %s@%s', git_hash, git_branch)

app = Flask(__name__)
app.secret_key = 'some-secret-key'
views.init_app(app)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
