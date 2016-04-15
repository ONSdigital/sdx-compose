FROM onsdigital/flask-crypto

ADD requirements.txt /requirements.txt

RUN pip3 install -U -I -r /requirements.txt \
  && rm -rf /var/cache/apk/* \
  && rm -rf /root/.cache/pip/* \