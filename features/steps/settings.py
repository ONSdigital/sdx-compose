import os
import logging

logger = logging.getLogger(__name__)


def get_key(key_name):
    """
    TODO remove these once the encrypted key story is finished
    :return:
    """
    logger.debug("Opening file %", key_name)
    key = open(key_name, 'r')
    contents = key.read()
    logger.debug("Key is %s", contents)
    return contents


POSIE_URL = os.getenv('POSIE_URL', 'http://posie:5000')
KEY_URL = "{}/key".format(POSIE_URL)
DECRYPT_URL = "{}/decrypt".format(POSIE_URL)
TRANSFORM_URL = os.getenv('TRANSFORM_URL', 'http://sdx-transform-cs:5000')

FTP_HOST = os.getenv('FTP_HOST', 'pure-ftpd')
FTP_USER = os.getenv('FTP_USER')
FTP_PASS = os.getenv('FTP_PASS')

RABBIT_QUEUE = os.getenv('RABBITMQ_QUEUE', 'survey')

RABBIT_URL = 'amqp://{user}:{password}@{hostname}:{port}/{vhost}'.format(
    hostname=os.getenv('RABBITMQ_HOST', 'rabbit'),
    port=os.getenv('RABBITMQ_PORT', 5672),
    user=os.getenv('RABBITMQ_DEFAULT_USER', 'rabbit'),
    password=os.getenv('RABBITMQ_DEFAULT_PASS', 'rabbit'),
    vhost=os.getenv('RABBITMQ_DEFAULT_VHOST', '%2f'),
    socket_timeout=5
)

EQ_JWT_LEEWAY_IN_SECONDS = 120

# EQ's keys
EQ_PUBLIC_KEY = get_key(os.getenv('EQ_PUBLIC_KEY', "/keys/sdc-submission-signing-sr-public-key.pem"))

# Posies keys
PRIVATE_KEY = get_key(os.getenv('PRIVATE_KEY', "/keys/sdc-submission-encryption-sdx-private-key.pem"))
PRIVATE_KEY_PASSWORD = os.getenv("PRIVATE_KEY_PASSWORD", "digitaleq")

LOGGING_FORMAT = "%(asctime)s|%(levelname)s: %(message)s"
LOGGING_LOCATION = "error.log"
LOGGING_LEVEL = logging.DEBUG