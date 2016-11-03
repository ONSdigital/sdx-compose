from transform import app
from settings import logger
import os

if __name__ == '__main__':
    # Startup
    logger.debug("START")
    port = int(os.getenv("PORT"))
    app.run(debug=True, host='0.0.0.0', port=port)
