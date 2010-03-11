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
  if File.exist?(filename)
    File.delete("#{TMP_PATH}/#{filename}")
  end
end

When /^I encrypt the file "([^\"]*)" for "([^\"]*)"$/ do |filename, recipient|
  RubyGpg.encrypt("#{TMP_PATH}/#{filename}", recipient)
end

When /^I decrypt the file "([^\"]*)" with passphrase "([^\"]*)"$/ do |filename, passphrase|
  RubyGpg.decrypt("#{TMP_PATH}/#{filename}", passphrase)
end

Then /^the file "([^\"]*)" should exist$/ do |filename|
  File.exist?("#{TMP_PATH}/#{filename}").should be_true
end

Then /^the file "([^\"]*)" should not contain "([^\"]*)"$/ do |filename, content|
  File.read("#{TMP_PATH}/#{filename}").should_not include(content)
end

Then /^the file "([^\"]*)" should contain "([^\"]*)"$/ do |filename, content|
  File.read("#{TMP_PATH}/#{filename}").should include(content)
end