Feature: Decrypt String
  In order to read an encrypted string
  As a user
  I want to decrypt it
  
  Scenario: Decrypt with proper recipient/recipient
    Given a key pair for Slow Joe Crow with passphrase test
    And a file named "secrets" containing "some content"
    And I encrypt the file "secrets" for "Slow Joe Crow"
    And I read the file "secrets.gpg" to a string
    And the string should not be "secrets"
    When I decrypt the string with passphrase "test"
    Then the string should be "secrets"
