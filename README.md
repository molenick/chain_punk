# Chain Punk ⛓👽

Chain Punk generates text from [markov chains](https://en.wikipedia.org/wiki/Markov_chain) defined by configurable patterns.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'chain_punk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chain_punk

## Usage

Generate five names from a sample set of English names:
```ruby
require 'chain_punk'

text = IO.read('docs/names.txt').downcase
corpus = ChainPunk::Corpus.new(text, closures: ["\n"], exclusions: [' '])
generator = ChainPunk::Generator.new(corpus.frequency_table)
[*1..5].each { puts generator.generate(rand(4..8)).capitalize }
```

Outputs:
```
Iniandi
Frbbemar
Gitelil
Relinor
Mapo
```

Generate five sentences from a translation of the Code of Hammurabi:
```ruby
require 'chain_punk'

text = IO.read('docs/code_of_hammurabi.txt')
corpus = ChainPunk::Corpus.new(text, boundaries: [' '], closures: ['.', ';'])
generator = ChainPunk::Generator.new(corpus.frequency_table)
[*1..5].each { puts generator.generate(rand(4..8),  boundary: ' ') }
```

Outputs:

```
Dam-gal-nunna, who supplied water
protected the divine city
scepter and promoted the weak,
put into execution the
settlement of all mankind to shine brilliantly
```

See the [example app](https://github.com/molenick/chain_punk/blob/master/example/example.rb) for more examples.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/molenick/chain_punk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Before submitting a pull request, please:

1. Write tests to cover your work.
1. Run `rake spec` to run the tests.
1. Run `bundle exec rubocop` and fix any issues.

## Code of Conduct

Everyone interacting in the ChainPunk project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/molenick/chain_punk/blob/master/CODE_OF_CONDUCT.md).
