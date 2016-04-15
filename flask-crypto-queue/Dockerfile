FROM onsdigital/flask-crypto

ADD requirements.txt /requirements.txt

RUN apk update && apk upgrade \
  && apk add curl python3 \
  && curl -sS https://bootstrap.pypa.io/get-pip.py | python3

RUN apk add --no-cache --virtual=build-dependencies ca-certificates libffi-dev openssl-dev g++ make python3-dev \
  && pip3 install -U -I -r /requirements.txt \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/* \
  && rm -rf /root/.cache/pip/* \