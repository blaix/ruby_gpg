Feature: Decryption
  In order to read an encrypted file
  As a user
  I want to decrypt it
  
  Background:
    Given a file named "secrets" containing "some content"
    And a key pair for Slow Joe Crow with passphrase test

  Scenario: Decrypt with proper recipient/recipient
    Given I encrypt the file "secrets" for "Slow Joe Crow"
    And the file "secrets" does not exist
    When I decrypt the file "secrets.gpg" with passphrase "test"
    Then the file "secrets" should exist
    And the file "secrets" should contain "some content"
  
  # TODO: Scenario for failed decrypt (bad recipient and bad passprhase)
