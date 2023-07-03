"""
init of module some-module
"""
from flask import Flask

__version__ = '0.0.1'
__author__ = 'some-author'


app = Flask(__name__)

from server_acq import views