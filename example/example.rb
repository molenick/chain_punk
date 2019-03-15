# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'chain_punk'

names = IO.read('docs/names.txt').downcase
hammurabi = IO.read('docs/code_of_hammurabi.txt')

# Generate five names from a sample set of English names
corpus = ChainPunk::Corpus.new(names, closures: ["\n"], exclusions: [' '])
generator = ChainPunk::Generator.new(corpus.frequency_table)
[*1..5].each { puts generator.generate(rand(4..8)).capitalize }

# Generate five sentences from a translation of the Code of Hammurabi
corpus = ChainPunk::Corpus.new(hammurabi, boundaries: [' '], closures: ['.', ';'])
generator = ChainPunk::Generator.new(corpus.frequency_table)
[*1..5].each { puts generator.generate(rand(4..8), boundary: ' ') }

# Generate five sentences that begin with words from a chose list of seeds
corpus = ChainPunk::Corpus.new(hammurabi, boundaries: [' '], closures: ['.', ';'])
generator = ChainPunk::Generator.new(corpus.frequency_table)
[*1..5].each { puts generator.generate(rand(4..8), boundary: ' ', seeds: [['When'], ['when']]) }

# Generate five sentences using the starting words of the original text
corpus = ChainPunk::Corpus.new(hammurabi, boundaries: [' '], closures: ['.', ';'])
generator = ChainPunk::Generator.new(corpus.frequency_table)
[*1..5].each { puts generator.generate(rand(4..8), boundary: ' ', seeds: corpus.seeds) }

# Generate text using a sequence of two words (instead of one) to increase order/reduce chaos.
corpus = ChainPunk::Corpus.new(hammurabi, boundaries: [' '], closures: ['.', ';'], index_size: 2)
generator = ChainPunk::Generator.new(corpus.frequency_table)
[*1..5].each { puts generator.generate(rand(4..8), boundary: ' ', index_size: 2) }
