# frozen_string_literal: true

require 'spec_helper'
require 'generator'

RSpec.describe ChainPunk::Generator do
  context '#phrase' do
    context 'when called with a length' do
      let(:corpus) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:separator) { ' ' }
      let(:length) { 5 }
      let(:terminator) { nil }

      it 'returns a phrase with 5 graphemes' do
        expect(subject.phrase(corpus, length, separator, terminator).split(separator).size).to eq(5)
      end
    end

    context 'when the seperator is nil' do
      let(:corpus) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:separator) { nil }
      let(:length) { 5 }
      let(:terminator) { nil }

      it 'returns a phrase with no seperator' do
        expect(subject.phrase(corpus, length, separator, terminator).length).to eq(5)
      end
    end

    context 'when called with a terminator' do
      let(:corpus) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:separator) { ' ' }
      let(:length) { 5 }
      let(:terminator) { '.' }

      it 'returns a phrase terminated with the terminator' do
        phrase = subject.phrase(corpus, length, separator, terminator)
        expect(phrase[phrase.size - 1]).to eq '.'
      end
    end
  end
end
