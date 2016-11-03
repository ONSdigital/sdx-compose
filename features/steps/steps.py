from behave import given, when, then
from ftplib import FTP
from random import randint
from datetime import datetime
from encrypter import Encrypter
import pika

import os
import requests
import time
import json

import settings

PATHS = {
    'pck': "EDC_QData",
    'image': "EDC_QImages/Images",
    'index': "EDC_QImages/Index",
    'receipt': "EDC_QReceipts"
}


def login_to_ftp():
    config = {'USE_MLSD': True}

    ftp = FTP(settings.FTP_HOST, timeout=5)
    ftp.login(user=settings.FTP_USER, passwd=settings.FTP_PASS)

    try:
        # Perform a simple mlsd test
        len([fname for fname, fmeta in ftp.mlsd(path=PATHS['pck'])])
    except:
        config['USE_MLSD'] = False

    return ftp, config


def get_folder_contents(path):
    ftp, config = login_to_ftp()
    data = []

    if config['USE_MLSD']:
        for fname, fmeta in ftp.mlsd(path=path):
            if fname not in ('.', '..'):
                fmeta['modify'] = mod_to_iso(fmeta['modify'])
                fmeta['filename'] = fname

                data.append(fmeta)
    else:
        for fname in ftp.nlst(path):
            fmeta = {}
            if fname not in ('.', '..'):
                fmeta['filename'] = fname

    return data


def get_ftp_contents():

        ftp_data = {}
        ftp_data['pck'] = get_folder_contents(PATHS['pck'])
        ftp_data['index'] = get_folder_contents(PATHS['index'])
        ftp_data['image'] = get_folder_contents(PATHS['image'])
        ftp_data['receipt'] = get_folder_contents(PATHS['receipt'])

        return ftp_data


def ftp_file_count():
    file_list = []

    ftp_contents = get_ftp_contents()

    for key, ftp_folder_contents in ftp_contents.items():
        for ftp_file in ftp_folder_contents:
            file_list.append(ftp_file['filename'])

    return len(file_list)


def mod_to_iso(file_modified):
    t = datetime.strptime(file_modified, '%Y%m%d%H%M%S')
    return t.isoformat()


def is_downstream_file(file_to_test, ext_to_check):
    filename, ext = os.path.splitext(file_to_test['filename'])

    return ext.lower() == ext_to_check


def get_file_contents(datatype, filename):
    ftp, config = login_to_ftp()
    ftp.retrbinary("RETR " + PATHS[datatype] + "/" + filename, open('tmpfile', 'wb').write)

    transferred = open('tmpfile', 'r')

    return transferred.read()


@given('I have a survey with the following attributes')
def survey_attributes(context):
    context.survey_data = {}

    for row in context.table.rows:
        context.survey_data[row['attribute']] = row['value']


@given('the survey collection has the following attributes')
def collection_attributes(context):
    collection = {}

    for row in context.table.rows:
        collection[row['attribute']] = row['value']

    context.survey_data['collection'] = collection


@given('the survey has the following metadata attributes')
def metadata_attributes(context):
    metadata = {}

    for row in context.table.rows:
        metadata[row['attribute']] = row['value']

    context.survey_data['metadata'] = metadata


@given('I have the following answers to the survey')
def survey_answers(context):
    answers = {}

    for row in context.table.rows:
        answers[row['question_id']] = row['answer']

    context.survey_data['data'] = answers


@given('I use the public key to encrypt {unencrypted}')
def encrypt_data(context, unencrypted):
    encrypter = Encrypter()
    unencrypted_json = json.loads(unencrypted)
    context.encrypted_data = encrypter.encrypt(unencrypted_json)


@when('I encrypt the survey data')
@given('I encrypt the survey data')
def request_and_encrypt_data(context):
    context.execute_steps('''
        Given I use the public key to encrypt {unencrypted}
    '''.format(unencrypted=json.dumps(context.survey_data)))


def queue_msg(message):
    connection = pika.BlockingConnection(pika.URLParameters(settings.RABBIT_URL))

    channel = connection.channel()

    channel.queue_declare(queue=settings.RABBIT_QUEUE, durable=True)

    channel.basic_publish(exchange='',
                          routing_key=settings.RABBIT_QUEUE,
                          body=message)


@when('I encrypt and queue 100 random answers to the survey')
def a_hundred_surveys(context):
    base_question_nos = [11, 12, 20, 21, 22, 23, 24, 25, 26]

    for i in range(0, 100):
        answers = {}

        for question_no in base_question_nos:
            answers[question_no] = str(randint(0, 10000))
            context.survey_data['data'] = answers

        context.execute_steps('''When I encrypt the survey data
            And I put the encrypted survey data on the queue''')


@when('I put the encrypted survey data on the queue')
def add_encrypted_data_to_queue(context):
    queue_msg(context.encrypted_data)


@when('I send the encrypted data to the decryption endpoint')
def decrypt_data(context):
    # Ask posie to decode message
    r = requests.post(settings.DECRYPT_URL, data=context.encrypted_data, timeout=1)

    context.decrypted_data = json.loads(r.text)


@then('I should receive the unencrypted data as a response')
def check_encryption(context):
    assert context.survey_data == context.decrypted_data, "Decrypted data did not match expected output"


@then('I should receive {data} as a response')
def check_encryption_data(context, data):
    assert context.decrypted_data == json.loads(data), "Decrypted data did not match expected output"


@given('I clear the ftp server of current files')
def clear_ftp(context):
    ftp, config = login_to_ftp()

    removed = 0

    if config['USE_MLSD']:
        for key, path in PATHS.items():
            for fname, fmeta in ftp.mlsd(path=path):
                if fname not in ('.', '..'):
                    ftp.delete(path + "/" + fname)
                    removed += 1
    else:
        for fname in ftp.nlst(path):
            if fname not in ('.', '..'):
                ftp.delete(path + "/" + fname)
                removed += 1


@then('I should see downstream formats in ftp')
def check_ftp(context):

    # Retry 5 times before failing
    for n in range(1, 5):
        current_ftp = get_ftp_contents()

        len_pck = len([1 for e in current_ftp['pck']])

        if len_pck > 0:
            break

        time.sleep(1)

    num_pck = sum([1 if is_downstream_file(e, '') else 0 for e in current_ftp['pck']])
    num_jpg = sum([1 if is_downstream_file(e, '.jpg') else 0 for e in current_ftp['image']])
    num_receipt = sum([1 if is_downstream_file(e, '.dat') else 0 for e in current_ftp['receipt']])
    num_csv = sum([1 if is_downstream_file(e, '.csv') else 0 for e in current_ftp['index']])

    assert num_pck == 1, "Incorrect number of pcks: %d" % num_pck
    assert num_jpg >= 1, "Incorrect number of jpgs: %d" % num_jpg
    assert num_receipt == 1, "Incorrect number of receipts: %d" % num_receipt
    assert num_csv == 1, "Incorrect number of csvs: %d" % num_csv

    context.ftp_contents = current_ftp


@then('the downstream format content should be as expected')
def check_contents(context):
    pck_url = "{}/pck".format(settings.TRANSFORM_URL)
    receipt_url = "{}/idbr".format(settings.TRANSFORM_URL)

    pck_contents = get_file_contents('pck', context.ftp_contents['pck'][0]['filename'])
    idbr_contents = get_file_contents('receipt', context.ftp_contents['receipt'][0]['filename'])

    survey_json = json.dumps(context.survey_data)
    r = requests.post(pck_url, survey_json)

    assert r.text == pck_contents, "PCK Content does not match expected"

    r = requests.post(receipt_url, survey_json)

    assert r.text == idbr_contents, "IDBR Content does not match expected"


@then('I should see 100 copies of downstream formats in ftp within 1 minute')
def check_ftp_100(context):
    time.sleep(60)

    file_count = ftp_file_count()

    assert file_count == 400, "Incorrect number of downstream files: %d" % file_count
