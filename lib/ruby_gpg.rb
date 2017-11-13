require 'open3'

module RubyGpg
  extend self

  Config = Struct.new(:executable, :homedir)
  def config
    @config ||=  Config.new("gpg", "~/.gnupg")
  end

  def gpg_command
    gpg_command_string
  end
  
  def encrypt_multi(file, recipients, opts = {})
    options = {
      :armor => false
    }.merge(opts)
    
    output = output_filename(file, options)
    
    command = gpg_command_array.dup

    command << '-a' if opts[:armor]
    command << '--trust-model' << opts[:'trust-model'] if opts[:'trust-model']
    command << '--output' << output
    recipients.each { |recipient|
      command << '--recipient' << recipient
    }
    command << '--encrypt' << file
    
    run_command(command)
  end

  def encrypt(file, recipient, opts = {})
    encrypt_multi(file, Array(recipient), opts) 
  end
  
  # Encrypt a string from stdin
  def encrypt_string(string, recipient, opts = {})
    command = gpg_command_array.dup
    command << '-a' if opts[:armor]
    command << '--encrypt'
    command << '--recipient' << recipient
    run_command(command, string)
  end
  
  def decrypt(file, passphrase = nil, opts = {})
    outfile = opts[:output].nil? ? file.gsub(/\.gpg$|\.asc$/, '') : opts[:output]

    command = gpg_command_array.dup
    command << '--output' << outfile
    command << '--passphrase' << passphrase if passphrase
    command << '--decrypt' << file

    run_command(command)
  end
  
  def decrypt_string(string, passphrase = nil)
    command = gpg_command_array.dup
    command << '--passphrase' << passphrase if passphrase
    command << '--decrypt'

    run_command(command, string)
  end
  
  private

  def gpg_command_array
    [
      config.executable,
      '--homedir', config.homedir,
      '--quiet',
      '--no-secmem-warning',
      '--no-permission-warning',
      '--no-tty',
      '--yes'
    ]
  end

  def gpg_command_string
    gpg_command_array.join(' ')
  end
  
  def run_command(command, input = nil)
    opts = { binmode: true, stdin_data: input}

    output, error, status = Open3.capture3(*command, opts)

    if status.exitstatus != 0
      raise "GPG command (#{command.join(' ')}) failed with: #{error}"
    end

    output
  end
  
  # Return the output filename to use
  def output_filename(file, opts)
    extension = opts[:armor] ? "asc" : "gpg"
    opts[:output].nil? ? "#{file}.#{extension}" : opts[:output]
  end
end
