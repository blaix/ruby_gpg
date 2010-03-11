Feature: Encryption
  In order to keep a file private
  As a user
  I want to encrypt the file

  Scenario: Encrypt
    Given a file containing "some content"
    When I encrypt the file for "recipient"
    Then the file should not contain "some content"
