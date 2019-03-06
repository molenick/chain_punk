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
      expect(subject.create_phrase(generator_length, generator_options).length).to eq(generator_length)
    end
  end

  context 'when setup to generate sentences' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus_options) { { boundaries: [' '], closures: ['.', '!', '?'], exclusions: [':', ';', '"', ','] } }
    let(:generator_options) { { boundary: ' ', closure: '.' } }
    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }
    let(:generator_length) { 5 }

    it 'generates a sentence' do
      expect(generator.create_phrase(generator_length, generator_options).split(' ').count).to eq(generator_length)
    end

    it 'ends with the closure' do
      expect(generator.create_phrase(generator_length, generator_options)[-1]).to eq('.')
    end
  end

  context 'when called with some start words' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus_options) { { boundaries: [' '], closures: ['.', '!', '?'], exclusions: [':', ';', '"', ','] } }
    let(:generator_options) { { boundary: ' ', starting_graphemes: ['bird'] } }
    let(:generator_length) { 1 }
    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }

    it 'generates a sentence starting with the start_grapheme' do
      expect(generator.create_phrase(generator_length, generator_options)).to eq('bird')
    end
  end
end
