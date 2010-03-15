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

Then /^the file "([^\"]*)" should exist$/ do |filename|
  File.exist?("#{TMP_PATH}/#{filename}").should be_true
end

Then /^the file "([^\"]*)" should not contain "([^\"]*)"$/ do |filename, content|
  File.read("#{TMP_PATH}/#{filename}").should_not include(content)
end
