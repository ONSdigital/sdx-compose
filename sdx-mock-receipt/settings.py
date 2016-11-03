import logging
import os

logger = logging.getLogger(__name__)

LOGGING_FORMAT = "%(asctime)s|%(levelname)s: sdx-mock-receipt: %(message)s"
LOGGING_LEVEL = logging.getLevelName(os.getenv('LOGGING_LEVEL', 'DEBUG'))

RECEIPT_USER = os.getenv("RECEIPT_USER", "")
RECEIPT_PASS = os.getenv("RECEIPT_PASS", "")
