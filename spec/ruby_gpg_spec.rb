require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyGpg" do
  it "allows the use of a custom path to the gpg executable" do
    RubyGpg.config.executable = "/custom/path/to/gpg"
    RubyGpg.gpg_command.should =~ /^\/custom\/path\/to\/gpg/
  end
  
  it "allows the use of a custom gpg home directory" do
    RubyGpg.config.homedir = "/custom/path/to/home"
    RubyGpg.gpg_command.should include("--homedir /custom/path/to/home")
  end
  
  it "should run with sane, headless defaults" do
    command = RubyGpg.gpg_command
    command.should include("--no-secmem-warning")
    command.should include("--no-permission-warning")
    command.should include("--no-tty")
    command.should include("--yes")
  end
  
  describe '.encrypt(filename, recipient)' do
    def expect_command_to_match(part_of_command)
      Open3.expects(:popen3).with do |command|
        case part_of_command
        when Regexp: command =~ part_of_command
        when String: command.include?(part_of_command)
        else raise "Can't match that"
        end
      end
    end
    
    def run_encrypt
      RubyGpg.encrypt('filename', 'recipient')
    end
    
    it "uses the configured gpg command" do
      expect_command_to_match(/^#{Regexp.escape(RubyGpg.gpg_command)}/)
      run_encrypt
    end
    
    it "issues an encrypt command to gpg" do
      expect_command_to_match("--encrypt")
      run_encrypt
    end
    
    it "issues the encrypt command for the passed filename" do
      expect_command_to_match(/filename$/)
      run_encrypt
    end
    
    it "issues the encrypts command for the passed recipient" do
      expect_command_to_match("--recipient recipient")
      run_encrypt
    end
    
    it "save encrypted version to filename.gpg" do
      expect_command_to_match("--output filename.gpg")
      run_encrypt
    end
    
    it "raises any errors from gpg" do
      stdin = StringIO.new
      stdout = StringIO.new
      stderr = StringIO.new("error message")
      
      Open3.stubs(:popen3).yields(stdin, stdout, stderr)
      lambda { run_encrypt }.should raise_error(/error message/)
    end
  end
end
