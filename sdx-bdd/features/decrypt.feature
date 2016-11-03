Feature: Decrypting EQ Payloads
  As a user in the NGD
  I want to decrypt data being sent from EQ
  So that I can transform EQ data to downstream formats

  Scenario Outline: Decryption Service
      Given I request a public key from the key endpoint
        And I use the key to encrypt <data>
        When I send the encrypted data to the decryption endpoint
        Then I should receive <data> as a response

    Examples: Test Data
      | data                                               |
      | {"id": "12345", "some_json_key": "some_json_data"} |
      | {"some_key": "some_value"}                         |