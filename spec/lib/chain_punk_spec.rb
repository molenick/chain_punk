# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk do
  subject { ChainPunk::Generator.new(corpus.frequency_table) }

  let(:source_text) { nil }
  let(:seperator) { nil }
  let(:terminator) { nil }
  let(:corpus) { nil }
  let(:generator) { nil }
  let(:length) { nil }

  context 'when setup to generate words' do
    let(:source_text) { IO.read('spec/fixtures/names.txt') }
    let(:corpus) { ChainPunk::Corpus.new(source_text, nil, "\n") }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }

    it 'generates a word' do
      length = (3..8).to_a.sample
      expect(subject.create_phrase(length, seperator, terminator).length).to eq(length)
    end
  end

  context 'when setup to generate sentences' do
    let(:source_text) { IO.read('spec/fixtures/the_golden_bird.txt') }
    let(:corpus) { ChainPunk::Corpus.new(source_text, seperator, "\n") }
    let(:generator) { ChainPunk::Generator.new(corpus.frequency_table) }
    let(:seperator) { ' ' }
    let(:terminator) { '.' }
    let(:length) { 10 }

    it 'generates a sentence' do
      expect(generator.create_phrase(length, seperator, terminator).split(seperator).count).to eq(length)
    end

    it 'ends with the terminator' do
      expect(generator.create_phrase(length, seperator, terminator)[-1]).to eq('.')
    end
  end
end
