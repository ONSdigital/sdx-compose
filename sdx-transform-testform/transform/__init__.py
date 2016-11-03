from flask import Flask
from jinja2 import Environment, PackageLoader

app = Flask(__name__)
env = Environment(loader=PackageLoader('transform', 'templates'))

import transform.views.main  # noqa
