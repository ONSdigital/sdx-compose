from transform import app, env
from settings import logger
from flask import request, make_response, jsonify
import dateutil.parser


@app.errorhandler(400)
def errorhandler_400(e):
    return client_error(repr(e))


def client_error(error=None):
    logger.error(error)
    message = {
        'status': 400,
        'message': error,
        'uri': request.url
    }
    resp = jsonify(message)
    resp.status_code = 400
    return resp


@app.errorhandler(500)
def server_error(e):
    logger.error("Server Error", exception=repr(e))
    message = {
        'status': 500,
        'message': "Internal server error: " + repr(e)
    }
    resp = jsonify(message)
    resp.status_code = 500
    return resp


@app.route('/xml', methods=['POST'])
def render_xml():
    response = request.get_json(force=True)
    try:
        submitted_date = dateutil.parser.parse(response['submitted_at'])
        instrument_id = response['collection']['instrument_id']

    except (KeyError, ValueError) as e:
        logger.error("JSON missing required data", exception=repr(e))
        return client_error("Missing required data")

    template = get_template(instrument_id)
    if template is None:
        return client_error("Unknown instrument id: " + instrument_id)

    doc = template.render(response=response, submitted=submitted_date)

    response_obj = make_response(doc)
    response_obj.mimetype = 'application/xml'
    return response_obj


def get_template(instrument_id):
    try:
        file = "{0}.tmpl".format(instrument_id)
        return env.get_template(file)

    except IOError:
        return None
