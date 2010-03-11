require 'open3'

module RubyGpg
  extend self

  Config = Struct.new(:executable, :homedir)
  def config
    @config ||=  Config.new("gpg", "~/.gnupg")
  end

  def gpg_command
    "#{config.executable} --homedir #{config.homedir}" +
    " --no-secmem-warning --no-permission-warning --no-tty --yes"
  end
  
  def encrypt(file, recipient)
    command = "#{gpg_command} --output #{file}.gpg" +
              " --recipient \"#{recipient}\" --encrypt #{file}"
    run_command(command)
  end
  
  def decrypt(file, passphrase = nil)
    outfile = file.gsub(/\.gpg$/, '')
    command = "#{gpg_command} --output #{outfile}"
    command << " --passphrase #{passphrase}" if passphrase
    command << " --decrypt #{file}"
    run_command(command)
  end
  
  private
  def run_command(command)
    Open3.popen3(command) do |stdin, stdout, stderr|
      stdin.close_write
      unless $?.exitstatus == 0
        msg = "GPG command (#{command}) failed"
        errors = stderr.read
        msg << " with: #{errors}" if errors && !errors.empty?
        raise msg
      end
    end
  end
end
