# Ruby GPG

Ruby wrapper for the `gpg` binary. You probably want to be using the
`ruby-gpgme` gem instead, but if you can't install the gpgme libraries
for some reason, I guess you have to settle for this.

## Installation

    gem install ruby_gpg

## Configuration

    # Defaults to "gpg"
    RubyGpg.config.executable = "/custom/path/to/gpg"
    
    # Defaults to "~/.gnupg"
    RubyGpg.config.homedir = "/custom/path/to/home"

## Usage

    # creates /path/to/file.gpg:
    RubyGpg.encrypt("/path/to/file", "Mr. Recipient")
  
    # creates /path/to/file:
    RubyGpg.decrypt("/path/to/file.gpg", "passphrase")

For more details, see the
[RDocs](http://rdoc.info/projects/blaix/ruby_gpg).

## Credits

* [Raphaël Pinson](https://github.com/raphink) modernized things and added some
features. Thanks.
* Scott and Divya of [gitcaps](http://github.com/gitcapps) added some sorely
missing features. Thanks, guys.

## Copyright

Copyright (c) 2010 Justin Blake. See LICENSE for details.
