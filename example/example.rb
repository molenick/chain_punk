require 'rubygems'
require 'bundler/setup'
require 'chain_punk'

# Generate five names from a sample set of English names
text = IO.read('docs/names.txt').downcase
corpus = ChainPunk::Corpus.new(text, closures: ["\n"], exclusions: [' '])
generator = ChainPunk::Generator.new(corpus.frequency_table)

[*1..5].each do
  puts generator.generate(rand(4..8)).capitalize
end

# Generate five sentences from a translation of the Code of Hammurabi
text = IO.read('docs/code_of_hammurabi.txt')
corpus = ChainPunk::Corpus.new(text, boundaries: [' '], closures: ['.', ';'])
generator = ChainPunk::Generator.new(corpus.frequency_table)

[*1..5].each do
  puts generator.generate(rand(4..8), boundary: ' ')
end
