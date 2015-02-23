$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'ruby_gpg'

require 'rspec/expectations'

TMP_PATH = File.dirname(__FILE__) + '/../../tmp'

class Object
  def true?
    !!self
  end
end
