Feature: Encryption
  In order to keep a file private
  As a user
  I want to encrypt the file

  Background:
    Given a key pair for Slow Joe Crow with passphrase test
    And a file named "secrets" containing "some content"
    And the file "secrets.gpg" does not exist

  Scenario: Encrypt
    When I encrypt the file "secrets" for "Slow Joe Crow"
    Then the file "secrets.gpg" should exist
    And the file "secrets.gpg" should not contain "some content"

  Scenario: Unknown recipient
    When I try to encrypt the file "secrets" for "Sue"
    Then the command should raise an error matching "key not found"
    And the file "secrets.gpg" should not exist
