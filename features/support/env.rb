$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'ruby_gpg'

require 'rspec/expectations'

require 'tmpdir'
TMP_PATH = Dir.mktmpdir('cucumber')

class Object
  def true?
    !!self
  end
end
