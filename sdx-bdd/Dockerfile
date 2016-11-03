FROM onsdigital/flask-crypto

# set working directory to /app/
WORKDIR /app/

ADD build_server.py /app
ADD requirements.txt /app

ADD static /app/static
ADD templates /app/templates
ADD features /app/features

# install python dependencies
RUN pip3 install -r requirements.txt

EXPOSE 5000

ENTRYPOINT python3 build_server.py