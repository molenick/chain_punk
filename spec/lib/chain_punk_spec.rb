# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk do
  subject { ChainPunk::Generator.new(corpus.frequency_table) }

  let(:source_text) { nil }

  let(:corpus) {}
  let(:corpus_options) {}

  let(:generator) { nil }
  let(:generator_separator) { nil }
  let(:generator_terminator) { nil }
  let(:generator_length) { nil }
  let(:starting_graphemes) { [] }

  context 'when setup to generate words' do
    let(:source_text) { IO.read('spec/fixtures/names.txt') }
    let(:corpus_options) { { terminators: ["\n"] } }
    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }
    let(:generator_length) { 5 }

    it 'generates a word' do
      expect(subject.create_phrase(generator_length, generator_separator, generator_terminator, starting_graphemes).length).to eq(generator_length)
    end
  end

  context 'when setup to generate sentences' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus_options) { { separators: [' '], terminators: ['.', '!', '?'], exclusions: [':', ';', '"', ','] } }
    let(:generator_separator) { ' ' }
    let(:generator_terminator) { '.' }
    let(:generator_length) { 5 }

    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }

    it 'generates a sentence' do
      expect(generator.create_phrase(generator_length, generator_separator, generator_terminator, starting_graphemes).split(generator_separator).count).to eq(generator_length)
    end

    it 'ends with the terminator' do
      expect(generator.create_phrase(generator_length, generator_separator, generator_terminator)[-1]).to eq('.')
    end
  end

  context 'when called with some start words' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus_options) { { separators: [' '], terminators: ['.', '!', '?'], exclusions: [':', ';', '"', ','] } }
    let(:generator_separator) { ' ' }
    let(:generator_terminator) { nil }
    let(:generator_length) { 1 }
    let(:starting_graphemes) { ['bird'] }

    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_options) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }

    it 'generates a sentence starting with the start_grapheme' do
      expect(generator.create_phrase(generator_length, generator_separator, generator_terminator, starting_graphemes)).to eq('bird')
    end
  end
end
