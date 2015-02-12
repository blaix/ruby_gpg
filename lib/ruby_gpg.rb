require 'open3'

module RubyGpg
  extend self

  Config = Struct.new(:executable, :homedir)
  def config
    @config ||=  Config.new("gpg", "~/.gnupg")
  end

  def gpg_command
    "#{config.executable} --homedir #{config.homedir} --quiet" +
    " --no-secmem-warning --no-permission-warning --no-tty --yes"
  end
  
  def encrypt(file, recipient, opts = {})
    options = {
      :armor => false
    }.merge(opts)
    
    output = output_filename(file, options)
    
    ascii = options[:armor] == true ? "-a " : ""
    
    command = "#{gpg_command} #{ascii}--output #{output}" +
              " --recipient \"#{recipient}\" --encrypt #{file}"
    
    run_command(command)
  end
  
  # Encrypt a string from stdin
  def encrypt_string(string, recipients, opts = {})
    command = gpg_command.dup
    command << " -a" if opts[:armor]
    command << " --encrypt"
    [recipients].flatten.each do |r|
      command << " --recipient \"#{r}\""
    end
    run_command(command, string)
  end
  
  def decrypt(file, passphrase = nil, opts = {})
    outfile = opts[:output].nil? ? file.gsub(/\.gpg$|\.asc$/, '') : opts[:output]
    command = "#{gpg_command} --output #{outfile}"
    command << " --passphrase #{passphrase}" if passphrase
    command << " --decrypt #{file}"
    run_command(command)
  end
  
  def decrypt_string(string, passphrase = nil)
    command = gpg_command.dup
    command << " --passphrase #{passphrase}" if passphrase
    command << " --decrypt"
    run_command(command, string)
  end
  
  private
  
  def run_command(command, input = nil)
    output = ""
    Open3.popen3(command) do |stdin, stdout, stderr|
      stdin.write(input) if input
      stdin.close
      output << stdout.read
      error = stderr.read
      if error && !error.empty?
        raise "GPG command (#{command}) failed with: #{error}"
      end
    end
    output
  end
  
  # Return the output filename to use
  def output_filename(file, opts)
    extension = opts[:armor] ? "asc" : "gpg"
    opts[:output].nil? ? "#{file}.#{extension}" : opts[:output]
  end
  
end
