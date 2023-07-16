#!/opt/venv/bin/python

import logging
from version import hash, branch
from flask import Flask

logging.basicConfig(level=logging.INFO)
logging.info('Starting acquisition server ...')
logging.info(f'Version: {hash}@{branch}')

app = Flask(__name__)
app.secret_key = 'some-secret-key'
import views
views.init_app(app)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
