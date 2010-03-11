Feature: Encryption
  In order to keep a file private
  As a user
  I want to encrypt the file

  Scenario: Encrypt
    Given a key pair for Slow Joe Crow with passphrase test
    And a file named "secrets" containing "some content"
    And the file "secrets.gpg" does not exist
    When I encrypt the file "secrets" for "Slow Joe Crow"
    Then the file "secrets.gpg" should exist
    And the file "secrets.gpg" should not contain "some content"
