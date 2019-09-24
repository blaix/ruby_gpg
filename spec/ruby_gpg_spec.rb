require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RubyGpg" do
  class MockProcessStatus
    attr_accessor :exitstatus
    def initialize(exitstatus)
      @exitstatus = exitstatus
    end
  end

  def expect_command_to_match(part_of_command)
    Open3.expects(:capture3).with do |*command, _opts|
      command_str = command.join(' ')
      case part_of_command
      when Regexp
        expect(command_str).to match part_of_command
      when String
        expect(command_str).to include part_of_command
      else
        raise "Can't match that"
      end
    end.returns(@result)
  end

  def expect_input_string_to_eq(string)
    Open3.expects(:capture3).with do |*_command, opts|
      expect(opts[:stdin_data]).to eq string
    end.returns(@result)
  end

  def stub_output(output)
    @result[0] = output
  end

  def stub_error(error)
    @result[1] = error
  end

  def stub_exitstatus(exitstatus)
    @result[2] = MockProcessStatus.new(exitstatus)
  end

  before do
    @result = ["", "", MockProcessStatus.new(0)]
    Open3.stubs(:capture3).returns(@result)
  end

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
    command.should include("--quiet")
    command.should include("--yes")
  end

  describe '.encrypt(filename, recipient)' do
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

    it "saves encrypted version to filename.gpg" do
      expect_command_to_match("--output filename.gpg")
      run_encrypt
    end

    it "raises any errors from gpg" do
      stub_error("error message")
      stub_exitstatus(1)
      lambda { run_encrypt }.should raise_error(/GPG command \(.*gpg.*--encrypt.*filename\) failed with: error message/)
    end

    it "does not raise if gpg exit status is 0" do
      stub_error("error message")
      lambda { run_encrypt }.should_not raise_error
    end
  end

  describe '.encrypt(filename, recipient, opts) with armor specified' do
    def run_encrypt
      RubyGpg.encrypt('filename', 'recipient', {:armor => true})
    end

    it "saves armored version to filename.asc" do
      expect_command_to_match("-a --output filename.asc")
      run_encrypt
    end
  end

  describe '.encrypt(filename, recipient, opts) with trust-model' do
    def run_encrypt
      RubyGpg.encrypt('filename', 'recipient', {:'trust-model' => :always})
    end

    it "issues the encrypts command for the passed trust-model" do
      expect_command_to_match("--trust-model always")
      run_encrypt
    end
  end

  describe '.encrypt(filename, recipient) with not a string' do
    it 'issues calls to_s on filename' do
      expect_command_to_match('1024')

      RubyGpg.encrypt(1024, 'recipient')
    end
  end

  describe '.encrypt(filename, recipient, opts) with ascii output file specified' do
    def run_encrypt
      RubyGpg.encrypt('filename', 'recipient', {:armor => true, :output => "foo.asc"})
    end

    it "saves armored version to foo.asc" do
      expect_command_to_match("-a --output foo.asc")
      run_encrypt
    end
  end

  describe '.encrypt_string(string, recipient, opts)' do
    def run_encrypt_string
      RubyGpg.encrypt_string("string to encrypt", "recipient")
    end

    it "uses the configured gpg command" do
      expect_command_to_match(/^#{Regexp.escape(RubyGpg.gpg_command)}/)
      run_encrypt_string
    end

    it "issues an encrypt command to gpg" do
      expect_command_to_match("--encrypt")
      run_encrypt_string
    end

    it "issues the encrypts command for the passed recipient" do
      expect_command_to_match("--recipient recipient")
      run_encrypt_string
    end

    it "sends the passed string as stdin" do
      expect_input_string_to_eq("string to encrypt")
      run_encrypt_string
    end

    it "returns the encrypted string" do
      stub_output("encrypted string")
      run_encrypt_string.should == "encrypted string"
    end

  end

  describe '.encrypt_string(string, recipient, opts) with trust-model' do
    def run_encrypt
      RubyGpg.encrypt_string('string to encrypt', 'recipient', {:'trust-model' => :always})
    end

    it "issues the encrypts command for the passed trust-model" do
      expect_command_to_match("--trust-model always")
      run_encrypt
    end
  end

  describe '.decrypt(filename)' do
    def run_decrypt(passphrase = nil)
      RubyGpg.decrypt('filename.gpg', passphrase)
    end

    it "uses the configured gpg command" do
      expect_command_to_match(/^#{Regexp.escape(RubyGpg.gpg_command)}/)
      run_decrypt
    end

    it "issues a decrypt command to gpg" do
      expect_command_to_match("--decrypt")
      run_decrypt
    end

    it "accepts an optional passphrase" do
      expect_command_to_match("--passphrase secret")
      run_decrypt("secret")
    end

    it "issues the decrypt command for the passed filename" do
      expect_command_to_match(/filename\.gpg$/)
      run_decrypt
    end

    it "saves decrypted version to filename without .gpg extension" do
      # Note the space after "filename". Without the space it is possible that
      # the file extention still exists
      expect_command_to_match("--output filename ")
      run_decrypt
    end

    it "raises any errors from gpg" do
      stub_error("error message")
      stub_exitstatus(1)
      lambda { run_decrypt }.should raise_error(/GPG command \(.*gpg.*--decrypt.*filename\.gpg\) failed with: error message/)
    end

    it "does not raise if gpg exits with 0" do
      stub_error("error message")
      lambda { run_decrypt }.should_not raise_error
    end
  end

  describe '.decrypt(filename) for asc file' do
    def run_decrypt(passphrase = nil, opts = {})
      RubyGpg.decrypt('filename.asc', passphrase, opts)
    end

    it "issues the decrypt command for the ascii filename" do
      # Note the space after "filename". Without the space it is possible that
      # the file extention still exists
      expect_command_to_match("--output filename ")
      run_decrypt
    end

    it "issues the decrypt command for the filename passed in options" do
      expect_command_to_match("--output foo.txt ")
      run_decrypt(nil, {:output => "foo.txt"})
    end

  end

  describe '.decrypt_string(string)' do
    def run_decrypt_string(passphrase = nil)
      RubyGpg.decrypt_string('encrypted string', passphrase)
    end

    it "uses the configured gpg command" do
      expect_command_to_match(/^#{Regexp.escape(RubyGpg.gpg_command)}/)
      run_decrypt_string
    end

    it "issues a decrypt command to gpg" do
      expect_command_to_match("--decrypt")
      run_decrypt_string
    end

    it "accepts an optional passphrase" do
      expect_command_to_match("--passphrase secret")
      run_decrypt_string("secret")
    end

    it "sends the passed string as stdin" do
      expect_input_string_to_eq("encrypted string")
      run_decrypt_string
    end

    it "returns the decrypted string" do
      stub_output("decrypted string")
      run_decrypt_string.should == "decrypted string"
    end

    it "raises any errors from gpg" do
      stub_error("error message")
      stub_exitstatus(1)
      lambda { run_decrypt_string }.should raise_error(/GPG command \(.*gpg.*--decrypt.*\) failed with: error message/)
    end

    it "does not raise if gpg exitstatus is 0" do
      stub_error("error message")
      lambda { run_decrypt_string }.should_not raise_error
    end
  end
end
