Given /^a key pair for Slow Joe Crow with passphrase test$/ do
  # Already built keys in spec/gpg_home. Tell RubyGpg to use this...
  RubyGpg.config.homedir = File.dirname(__FILE__) + '/../../test_keys'
end

Given /^a file named "([^\"]*)" containing "([^\"]*)"$/ do |filename, content|
  File.open("#{TMP_PATH}/#{filename}", 'w') do |f|
    f.write(content)
  end
end

Given /^the file "([^\"]*)" does not exist$/ do |filename|
  if File.exist?("#{TMP_PATH}/#{filename}")
    File.delete("#{TMP_PATH}/#{filename}")
  end
end

Given /^I read the file "([^\"]*)" to a string$/ do |filename|
  @string = File.read("#{TMP_PATH}/#{filename}")
end

Given /^the string should not be "([^\"]*)"$/ do |string|
  @string.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').strip.should_not == string.strip
end

When /^I encrypt the file "([^\"]*)" for "([^\"]*)"$/ do |filename, recipient|
  RubyGpg.encrypt("#{TMP_PATH}/#{filename}", recipient)
end

When /^I try to encrypt the file "([^\"]*)" for "([^\"]*)"$/ do |filename, recipient|
  @command = lambda {
    RubyGpg.encrypt("#{TMP_PATH}/#{filename}", recipient)
  }
end

When /^I decrypt the file "([^\"]*)" with passphrase "([^\"]*)"$/ do |filename, passphrase|
  RubyGpg.decrypt("#{TMP_PATH}/#{filename}", passphrase)
end

When /^I decrypt the string with passphrase "([^\"]*)"$/ do |passphrase|
  @string = RubyGpg.decrypt_string(@string, passphrase)
end

Then /^the command should raise an error matching "([^\"]*)"$/ do |error|
  @command.should raise_error(/#{Regexp.escape(error)}/)
end

Then /^the file "([^\"]*)" should exist$/ do |filename|
  File.exist?("#{TMP_PATH}/#{filename}").should be_true
end

Then /^the file "([^\"]*)" should not exist$/ do |filename|
  File.exist?("#{TMP_PATH}/#{filename}").should_not be_true
end

Then /^the file "([^\"]*)" should not contain "([^\"]*)"$/ do |filename, content|
  File.read("#{TMP_PATH}/#{filename}").should_not include(content)
end

Then /^the file "([^\"]*)" should contain "([^\"]*)"$/ do |filename, content|
  File.read("#{TMP_PATH}/#{filename}").should include(content)
end

Then /^the string should be "([^\"]*)"$/ do |string|
  @string.strip.should == string.strip
end
