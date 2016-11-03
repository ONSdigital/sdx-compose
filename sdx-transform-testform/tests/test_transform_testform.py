from server import app
from transform.views import main
from tests.test_data import ce_survey, hh_survey
import unittest

# survey (input), xml path (output)
input_to_output = {ce_survey: 'tests/ce_expected_response.xml',
                   hh_survey: 'tests/hh_expected_response.xml'}


class TestTransformTestformService(unittest.TestCase):

    def setUp(self):
        self.maxDiff = None
        # creates a test client
        self.app = app.test_client()
        # propagate the exceptions to the test client
        self.app.testing = True

    def get_response(self, message):
        response = self.app.post("/xml", data=message)
        return response

    def test_empty_request_returns_400(self):
        response = self.get_response(None)
        self.assertEqual(400, response.status_code)

    def test_invalid_json_returns_400(self):
        response = self.get_response('{ "testing" }')
        self.assertEqual(400, response.status_code)

    def test_missing_date_returns_400(self):
        no_date = """{
            "collection": { "instrument_id": "ce2016" }
        }"""
        response = self.get_response(no_date)
        self.assertEqual(400, response.status_code)

    def test_invalid_date_returns_400(self):
        invalid_date = """{
            "submitted_at": "invalid",
            "collection": { "instrument_id": "ce2016" }
        }"""
        response = self.get_response(invalid_date)
        self.assertEqual(400, response.status_code)

    def test_missing_instrument_id_returns_400(self):
        no_instrument_id = """{
            "submitted_at": "invalid"
        }"""
        response = self.get_response(no_instrument_id)
        self.assertEqual(400, response.status_code)

    def test_invalid_instrument_id_returns_400(self):
        invalid_instrument_id = """{
            "submitted_at": "2016-03-12T10:39:40Z",
            "collection": { "instrument_id": "invalid" }
        }"""
        response = self.get_response(invalid_instrument_id)
        self.assertEqual(400, response.status_code)

    def test_creates_correct_xml(self):
        for survey, xml_path in input_to_output.items():
            response = self.get_response(survey)

            f = open(xml_path)
            contents = f.read()
            f.close()

            expected = str.strip(contents)
            received = response.get_data(as_text=True)
            self.assertEqual(expected, received)
            self.assertEqual(200, response.status_code)
            self.assertEqual('application/xml; charset=utf-8', response.headers['Content-Type'])

    def test_get_template_valid(self):
        template = main.get_template('ce2016')
        self.assertIsNotNone(template)

    def test_get_template_invalid(self):
        template = main.get_template('invalid')
        self.assertIsNone(template)
