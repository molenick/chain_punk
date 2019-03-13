# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk do
  subject { ChainPunk::Generator.new(corpus.frequency_table) }
  let(:source_text) {}
  let(:corpus) {}
  let(:corpus_options) {}
  let(:generator) {}
  let(:generator_length) {}
  let(:generator_options) { {} }

  context 'when setup to generate words' do
    let(:source_text) { IO.read('spec/fixtures/names.txt') }
    let(:corpus_options) { { closures: ["\n"] } }
    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }
    let(:generator_length) { 5 }

    it 'generates a word' do
      expect(subject.generate(generator_length, generator_options).length).to eq(generator_length)
    end
  end

  context 'when setup to generate sentences' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus_options) { { boundaries: [' '], closures: ['.', '!', '?'], exclusions: [':', ';', '"', ','] } }
    let(:generator_options) { { boundary: ' ', closure: '.' } }
    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }
    let(:generator_length) { 4 }

    it 'generates a sentence' do
      expect(generator.generate(generator_length, generator_options).split(' ').count).to be <= generator_length
    end

    it 'ends with the closure' do
      expect(generator.generate(generator_length, generator_options)[-1]).to eq('.')
    end
  end

  context 'when setup to generate sentences with an index size of 2' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus_options) { { boundaries: [' '], closures: ['.', '!', '?'], exclusions: [':', ';', '"', ','], index_size: 2 } }
    let(:generator_options) { { boundary: ' ', closure: '.', index_size: 2 } }
    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }
    let(:generator_length) { 4 }

    it 'generates a sentence' do
      expect(generator.generate(generator_length, generator_options).split(' ').count).to eq(generator_length)
    end

    it 'ends with the closure' do
      expect(generator.generate(generator_length, generator_options)[-1]).to eq('.')
    end
  end

  context 'when called with some seeds' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus_options) { { boundaries: [' '], closures: ['.', '!', '?'], exclusions: [':', ';', '"', ','] } }
    let(:generator_options) { { boundary: ' ', seeds: [['bird']] } }
    let(:generator_length) { 1 }
    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }

    it 'generates a phrase starting with the seeds' do
      expect(generator.generate(generator_length, generator_options)).to eq('bird')
    end
  end
end
