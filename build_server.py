from flask import Flask, flash, redirect, render_template, \
     request, url_for
from flask_sqlalchemy import SQLAlchemy

import subprocess
import json
import os

from datetime import datetime

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///reports.db'
app.secret_key = 'ksafkjnsakjnfsnafknds'

db = SQLAlchemy(app)


class Report(db.Model):
    __tablename__ = 'reports'
    id = db.Column(db.Integer, primary_key=True)
    created = db.Column(db.DateTime)

    duration = db.Column(db.Float)
    scenarios = db.Column(db.Integer)
    successes = db.Column(db.Integer)
    failures = db.Column(db.Integer)
    steps = db.Column(db.Integer)

    def __init__(self, summary):

        self.created = datetime.utcnow()
        self.duration = summary['scenarios']
        self.scenarios = summary['scenarios']
        self.successes = summary['successes']
        self.failures = summary['failures']
        self.steps = summary['steps']

    def __repr__(self):
        return '<Report %r>' % self.id


def write_report(report_json, report_id):
    report_json_file = open('./static/reports/{}.json'.format(report_id), 'w')

    report_json_file.write(json.dumps(report_json))
    report_json_file.close()


def read_report(report_id):
    report_json_file = open('./static/reports/{}.json'.format(report_id), 'r')

    report_json = report_json_file.read()
    report_json_file.close()

    return json.loads(report_json)


def parse_tags(loaded_json):
    for report_json in loaded_json:
        if report_json['tags']:
            report_json['tags'] = ",".join(map(lambda tag: tag.name, report_json.tags))
        else:
            report_json['tags'] = ''


def scenario_summary(loaded_json):
    scenarios = 0
    successes = 0
    failures = 0
    duration = float(0)
    steps = 0

    for report_json in loaded_json:

        scenarios += len(report_json["elements"])

        for element in report_json["elements"]:
            steps += len(element['steps'])
            failures += len([step for step in element["steps"] if "result" in step and step["result"]["status"] == "failed"])
            duration += sum([step["result"]["duration"] for step in element["steps"] if "result" in step])
            successes = steps - failures

    return {
        "duration": duration,
        "scenarios": scenarios,
        "successes": successes,
        "failures": failures,
        "steps": steps
    }


def run_report(args):
    try:
        subprocess.check_call(args)
    except:
        pass

    try:
        loaded_json = json.loads(open("behave.json", 'r').read())

        parse_tags(loaded_json)
        summary = scenario_summary(loaded_json)

        app.logger.debug(summary)

        new_report = Report(summary)

        db.session.add(new_report)
        db.session.commit()

        write_report(loaded_json, new_report.id)

        flash(u"Published report # {report_id}: ".format(report_id=new_report.id), 'success')
    except:
        flash(u"Error on publishing report", 'danger')


@app.route('/publish/<feature_file>')
def publish_single(feature_file):
    feature_file = "features/{}".format(feature_file)

    if not os.path.exists(feature_file):
        flash(u"Feature file not found", 'danger')
    else:
        publish_args = ["behave", feature_file, "-f", "json.pretty", "-o", "behave.json"]

    run_report(publish_args)

    return redirect(url_for('reports'))


@app.route('/publish')
def publish():
    publish_args = ["behave", "-f", "json.pretty", "-o", "behave.json"]

    run_report(publish_args)

    return redirect(url_for('reports'))


@app.route('/reports/<report_id>')
def report(report_id):
    return render_template('report.html', reports=read_report(report_id))


@app.route('/')
def reports():
    return render_template('index.html', reports=Report.query.order_by('id DESC'))

if __name__ == '__main__':
    db.create_all()
    app.run(debug=True, host='0.0.0.0')
