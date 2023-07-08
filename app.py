#!/opt/venv/bin/python
import logging
from version import hash, branch

from server_acq import app

logging.basicConfig(level=logging.INFO)
logging.info('Starting acquisition server ...')
logging.info(f'{hash}@{branch}')
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
