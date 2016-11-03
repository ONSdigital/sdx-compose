Feature: System Performance
  As a system in the NGD
  I want to transform decrypted data being sent from EQ
  So that I can use them in downstream systems

  Scenario: Minimum Performance Requirements are met
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
    And I clear the ftp server of current files
    When I encrypt and queue 100 random answers to the survey
    Then I should see 100 copies of downstream formats in ftp within 1 minute