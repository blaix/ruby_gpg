Given /^a file containing "([^\"]*)"$/ do |content|
  @file_path = "#{TMP_PATH}/cucumber_test_file"
  File.open(@file_path, 'w') do |f|
    f.write(content)
  end
end

When /^I encrypt the file for "([^\"]*)"$/ do |recipient|
  RubyGpg.encrypt(@file_path, recipient)
end
