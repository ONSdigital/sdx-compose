import logging
import os
import sys
from structlog import wrap_logger

LOGGING_FORMAT = "%(asctime)s|%(levelname)s: sdx-transform-testform: %(message)s"
LOGGING_LEVEL = logging.getLevelName(os.getenv('LOGGING_LEVEL', 'DEBUG'))

logging.basicConfig(stream=sys.stdout, level=LOGGING_LEVEL, format=LOGGING_FORMAT)
logger = wrap_logger(logging.getLogger(__name__))
