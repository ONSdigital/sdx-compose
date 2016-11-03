import json
import argparse
import pystache


def create_report(loaded_json, html_filename):

    htmlfile = open(html_filename, 'w')
    template = open("./stashe/default.html", 'r').read()

    htmlfile.write(pystache.render(template, {'reports': loaded_json}))


def parse_tags(loaded_json):
    for report_json in loaded_json:
        if report_json['tags']:
            report_json['tags'] = ",".join(map(lambda tag: tag.name, report_json.tags))
        else:
            report_json['tags'] = ''

if __name__ == '__main__':
    publisher = argparse.ArgumentParser(description='Convert behave json to formatted html.')
    publisher.add_argument('--json', help='The input json file to convert', default='behave.json')
    publisher.add_argument('--html', help='The output html report to create', default='index.html')

    args = publisher.parse_args()

    loaded_json = json.loads(open(args.json, 'r').read())
    parse_tags(loaded_json)

    create_report(loaded_json, args.html)
