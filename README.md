# sdx-transform-testform

[![Build Status](https://travis-ci.org/ONSdigital/sdx-transform-testform.svg?branch=master)](https://travis-ci.org/ONSdigital/sdx-transform-testform)

The sdx-transform-testform app is used within the Office National of Statistics (ONS) for transforming Survey Data Exchange (SDX) Surveys to an XML format.

## Installation

Using virtualenv and pip, create a new environment and install within using:

    $ pip install -r requirements.txt

It's also possible to install within a container using docker. From the sdx-transform-testform directory:

    $ docker build -t sdx-transform-testform .

## Usage

Start sdx-transform-testform service using the following command:

    python server.py

## API

 * `POST /xml` - transform to xml

### Example Data
```
{
   "type": "uk.gov.ons.edc.eq:surveyresponse",
   "file-type": "xml",
   "origin": "uk.gov.ons.edc.eq",
   "survey_id": "194825",
   "version": "0.0.1",
   "collection": {
     "exercise_sid": "hfjdskf",
     "instrument_id": "10",
     "period": "0616"
   },
   "submitted_at": "2016-03-12T10:39:40Z",
   "metadata": {
     "user_id": "789473423",
     "ru_ref": "1234570071A"
   },
   "data": {
     "1": "2",
     "2": "4",
     "3": "2",
     "4": "Y"
   }
}
```
### Example Response

```
<?xml version="1.0" encoding="UTF-8"?>
<UnitDataSet>
   <UnitDataRecord>
       <UnitDataPoint>
           <Type>Identifier</Type>
           <Population>Response</Population>
           <InstanceVariable>SurveyId</InstanceVariable>
           <!-- survey_id -->
           <Datum>194825</Datum>
       </UnitDataPoint>
       <UnitDataPoint>
           <Type>Identifier</Type>
           <Population>Response</Population>
           <InstanceVariable>LimeQuestionnaireId</InstanceVariable>
           <!-- instrument_id -->
           <Datum>10</Datum>
       </UnitDataPoint>
       <UnitDataPoint>
           <Type>Identifier</Type>
           <Population>Response</Population>
           <InstanceVariable>QuestionnaireId</InstanceVariable>
           <!-- ru_ref -->
           <Datum>1234570071</Datum>
       </UnitDataPoint>
       <UnitDataPoint>
           <Type>Identifier</Type>
           <Population>Response</Population>
           <InstanceVariable>ResponseSubmitTime</InstanceVariable>
           <!-- submitted_at -->
           <Datum>2016-03-12 10:39:40+00:00</Datum>
       </UnitDataPoint>
       <UnitDataPoint>
           <!-- Question 1 -->
           <Type>Identifier</Type>
           <Population>Establishment</Population>
           <InstanceVariable>1</InstanceVariable>
           <Datum>2</Datum>
       </UnitDataPoint>
       <UnitDataPoint>
           <!-- Question 2 -->
           <Type>Identifier</Type>
           <Population>Establishment</Population>
           <InstanceVariable>2</InstanceVariable>
           <Datum>4</Datum>
       </UnitDataPoint>
       <UnitDataPoint>
           <!-- Question 3 -->
           <Type>Identifier</Type>
           <Population>Establishment</Population>
           <InstanceVariable>3</InstanceVariable>
           <Datum>2</Datum>
       </UnitDataPoint>
       <UnitDataPoint>
           <!-- Question 4 -->
           <Type>Identifier</Type>
           <Population>Establishment</Population>
           <InstanceVariable>4</InstanceVariable>
           <Datum>Y</Datum>
       </UnitDataPoint>
       <UnitDataPoint>
           <Type>Identifier</Type>
           <Population>Response</Population>
           <InstanceVariable>Forced</InstanceVariable>
           <Datum>true</Datum>
       </UnitDataPoint>
   </UnitDataRecord>
</UnitDataSet>
```
