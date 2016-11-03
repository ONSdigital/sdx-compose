FROM onsdigital/flask-crypto

ADD server.py /app/server.py
ADD settings.py /app/settings.py
ADD startup.sh /app/startup.sh
ADD templates /app/templates

# set working directory to /app/
WORKDIR /app/

EXPOSE 5000

ENTRYPOINT ./startup.sh
