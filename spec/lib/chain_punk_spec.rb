# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk do
  subject { ChainPunk::Generator.new(corpus.frequency_table) }

  let(:source_text) { nil }

  let(:corpus) { nil }
  let(:corpus_seperators) { [] }
  let(:corpus_terminator) { nil }
  let(:corpus_exclusions) { [] }

  let(:generator) { nil }
  let(:generator_seperator) { nil }
  let(:generator_terminator) { nil }
  let(:generator_length) { nil }

  context 'when setup to generate words' do
    let(:source_text) { IO.read('spec/fixtures/names.txt') }
    let(:corpus_terminator) { "\n" }
    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_seperators, corpus_terminator, corpus_exclusions) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }
    let(:generator_length) { 5 }

    it 'generates a word' do
      expect(subject.create_phrase(generator_length, generator_seperator, generator_terminator).length).to eq(generator_length)
    end
  end

  context 'when setup to generate sentences' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus_seperators) { [' '] }
    let(:corpus_terminator) { '.' }
    let(:corpus_exclusions) { [':', ';', '"', ','] }
    let(:generator_seperator) { ' ' }
    let(:generator_terminator) { '.' }
    let(:generator_length) { 10 }

    let(:corpus) { ChainPunk::Corpus.new(source_text, corpus_seperators, corpus_terminator, corpus_exclusions) }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }

    it 'generates a sentence' do
      expect(generator.create_phrase(generator_length, generator_seperator, generator_terminator).split(generator_seperator).count).to eq(generator_length)
    end

    it 'ends with the generator_terminator' do
      expect(generator.create_phrase(generator_length, generator_seperator, generator_terminator)[-1]).to eq('.')
    end
  end
end
