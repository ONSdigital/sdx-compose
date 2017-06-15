#!/bin/bash

EXPECTED=${EXPECTED:=1}
RESOLUTION=${RESOLUTION:=1}
PORT=${PORT:=80}

# Thingy for the progess bar
pstr="[=======================================================================]"

echo "Sending data"
json='{ "tx_id": "0f534ffc-9442-414c-b39f-a756b4adc6cb", "type": "uk.gov.ons.edc.eq:surveyresponse", "origin": "uk.gov.ons.edc.eq", "survey_id": "023","version": "0.0.1","collection": {"exercise_sid": "hfjdskf",  "instrument_id": "0203", "period": "0216"},"submitted_at": "2016-03-12T10:39:40Z", "metadata": { "user_id": "789473423", "ru_ref": "12345678901A" }, "data": {"11": "01/04/2016",  "12": "31/10/2016", "20": "1800000", "51": "84", "52": "10", "53": "73", "54": "24", "50": "205", "22": "705000", "23": "900", "24": "74", "25": "50", "26": "100",  "21": "60000", "27": "7400", "146": "some comment"}}'
survey="{\"quantity\":\"${EXPECTED}\",\"survey\":${json}}"
curl http://localhost:${PORT}/ -X POST -d "${survey}" -H "Content-Type: application/json"

START=${SECONDS}
echo
echo "Starting at $(date)"
echo "Waiting for ${EXPECTED} files"

echo "Start with $(find pure-ftp-structure/EDC_QData -type f | wc -l)"

while :
do
  DONE=$(find pure-ftp-structure/EDC_QData -type f | wc -l)
  sleep ${RESOLUTION}

  # Work out the percentage complete
  PERC=$((100*DONE/EXPECTED))
  printf "\r%3d.%1d%% %.${PERC}s" $(( DONE * 100 / EXPECTED )) $(( (DONE * 1000 / EXPECTED) % 10 )) $pstr

  if [ "${DONE}" -ge "${EXPECTED}" ];
  then
    break
  fi
done

DURATION=$((SECONDS-START))
echo
echo "Done at $(date) [took approx ${DURATION}s]"
echo "Final count $(find pure-ftp-structure/EDC_QData -type f | wc -l)"
