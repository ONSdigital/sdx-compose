Feature: Transforming Valid EQ Payloads
  As a system in the NGD
  I want to decrypt and transform MCI surveys being sent from EQ
  So that I can use them in downstream systems

  Scenario: The Monthly Business Survey should be transformed
    Given I have a survey with the following attributes
      | attribute                  | value                                    |
      | type                       | uk.gov.ons.edc.eq:surveyresponse         |
      | version                    | 0.0.1                                    |
      | origin                     | uk.gov.ons.edc.eq                        |
      | survey_id                  | 023                                      |
      | submitted_at               | 2016-03-12T10:39:40Z                     |
    And the survey collection has the following attributes
      | attribute                  | value                                    |
      | exercise_sid               | hfjdskf                                  |
      | instrument_id              | 0203                                     |
      | period                     | 2016-02-01                               |
    And the survey has the following metadata attributes
      | attribute                  | value                                    |
      | user_id                    | 789473423                                |
      | ru_ref                     | 12345678901A                             |
    And I have the following answers to the survey
      | question_id  | answer               |
      | 11           | 01/04/2016           |
      | 12           | 31/10/2016           |
      | 20           | 1800000              |
      | 22           | 705000               |
      | 23           | 900                  |
      | 24           | 74                   |
      | 25           | 50                   |
      | 26           | 100                  |
      | 21           | 60000                |
      | 146          | some comment         |
    And I clear the ftp server of current files
    And I encrypt the survey data
    When I put the encrypted survey data on the queue
    Then I should see downstream formats in ftp
    And the downstream format content should be as expected

  Scenario: Monthly Business Survey (Fuel Inc) should be transformed
    Given I have a survey with the following attributes
      | attribute                  | value                                    |
      | type                       | uk.gov.ons.edc.eq:surveyresponse         |
      | version                    | 0.0.1                                    |
      | origin                     | uk.gov.ons.edc.eq                        |
      | survey_id                  | 023                                      |
      | submitted_at               | 2016-03-12T10:39:40Z                     |
    And the survey collection has the following attributes
      | attribute                  | value                                    |
      | exercise_sid               | hfjdskf                                  |
      | instrument_id              | 0205                                     |
      | period                     | 2016-02-01                               |
    And the survey has the following metadata attributes
      | attribute                  | value                                    |
      | user_id                    | 789473423                                |
      | ru_ref                     | 12345678901A                             |
    And I have the following answers to the survey
      | question_id  | answer               |
      | 11           | 01/04/2016           |
      | 12           | 31/10/2016           |
      | 20           | 1800000              |
      | 22           | 705000               |
      | 23           | 900                  |
      | 24           | 74                   |
      | 25           | 50                   |
      | 26           | 100                  |
      | 21           | 60000                |
      | 27           | 7400                 |
      | 146          | some comment         |
    And I clear the ftp server of current files
    And I encrypt the survey data
    When I put the encrypted survey data on the queue
    Then I should see downstream formats in ftp
    And the downstream format content should be as expected

  Scenario: Quarterly Business Survey should be transformed
    Given I have a survey with the following attributes
      | attribute                  | value                                    |
      | type                       | uk.gov.ons.edc.eq:surveyresponse         |
      | version                    | 0.0.1                                    |
      | origin                     | uk.gov.ons.edc.eq                        |
      | survey_id                  | 023                                      |
      | submitted_at               | 2016-03-12T10:39:40Z                     |
    And the survey collection has the following attributes
      | attribute                  | value                                    |
      | exercise_sid               | hfjdskf                                  |
      | instrument_id              | 0213                                     |
      | period                     | 2016-02-01                               |
    And the survey has the following metadata attributes
      | attribute                  | value                                    |
      | user_id                    | 789473423                                |
      | ru_ref                     | 12345678901A                             |
    And I have the following answers to the survey
      | question_id  | answer               |
      | 11           | 01/04/2016           |
      | 12           | 31/10/2016           |
      | 20           | 1800000              |
      | 22           | 705000               |
      | 23           | 900                  |
      | 24           | 74                   |
      | 25           | 50                   |
      | 26           | 100                  |
      | 21           | 60000                |
      | 51           | 84                   |
      | 52           | 10                   |
      | 53           | 73                   |
      | 54           | 24                   |
      | 50           | 205                  |
      | 146          | some comment         |
    And I clear the ftp server of current files
    And I encrypt the survey data
    When I put the encrypted survey data on the queue
    Then I should see downstream formats in ftp
    And the downstream format content should be as expected

  Scenario: Quarterly Business Survey (Fuel Inc) should be transformed
    Given I have a survey with the following attributes
      | attribute                  | value                                    |
      | type                       | uk.gov.ons.edc.eq:surveyresponse         |
      | version                    | 0.0.1                                    |
      | origin                     | uk.gov.ons.edc.eq                        |
      | survey_id                  | 023                                      |
      | submitted_at               | 2016-03-12T10:39:40Z                     |
    And the survey collection has the following attributes
      | attribute                  | value                                    |
      | exercise_sid               | hfjdskf                                  |
      | instrument_id              | 0215                                     |
      | period                     | 2016-02-01                               |
    And the survey has the following metadata attributes
      | attribute                  | value                                    |
      | user_id                    | 789473423                                |
      | ru_ref                     | 12345678901A                             |
    And I have the following answers to the survey
      | question_id  | answer               |
      | 11           | 01/04/2016           |
      | 12           | 31/10/2016           |
      | 20           | 1800000              |
      | 22           | 705000               |
      | 23           | 900                  |
      | 24           | 74                   |
      | 25           | 50                   |
      | 26           | 100                  |
      | 21           | 60000                |
      | 27           | 7400                 |
      | 51           | 84                   |
      | 52           | 10                   |
      | 53           | 73                   |
      | 54           | 24                   |
      | 50           | 205                  |
      | 146          | some comment         |
    And I clear the ftp server of current files
    And I encrypt the survey data
    When I put the encrypted survey data on the queue
    Then I should see downstream formats in ftp
    And the downstream format content should be as expected