# Proquint

A library for converting numbers to readable, pronounceable, spellable
identifiers.

See http://arxiv.org/html/0901.4016.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proquint'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proquint

## Usage

    require 'proquint'
    Proquint.encode(1)                  #=> "babad"
    Proquint.encode(1234567890123456)   #=> "babah-karij-gufap-rorab"
    Proquint.encode(0x)                 #=> "babah-karij-gufap-rorab"
    Proquint.encode(0x1234567890abcdef) #=> "damuh-jinum-nafor-suloz"
    Proquint.decode("nobol-gonad")      #=> [38951, 14913]
    Proquint.words2num([38951, 14913])  #=> 2552707649

## Contributing

1. Fork it ( https://github.com/[my-github-username]/proquint/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
