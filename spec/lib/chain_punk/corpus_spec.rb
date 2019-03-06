# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk::Corpus do
  subject { ChainPunk::Corpus.new(text, options) }

  let(:text) {}
  let(:options) { {} }

  context '#train' do
    context 'when called with some text' do
      let(:text) { 'abbba' }
      let(:text) { 'a b. b a. a b c. b a' }
      let(:options) { { closures: '.', boundaries: ' ' } }

      it 'returns a corpus' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b],
          ['b'] => %w[a c a]
        )
      end

      it 'records the graphemes that start each phrase' do
        expect(subject.starting_graphemes).to eq(%w[a b a b])
      end
    end

    context 'when called with boundaries' do
      let(:text) { 'a b b-b a' }
      let(:options) { { boundaries: [' ', '-'] } }

      it 'returns frequency table split by the boundaries' do
        expect(subject.frequency_table).to eq(
          ['a'] => ['b'], ['b'] => %w[b b a]
        )
      end

      context 'when called with some text that starts/ends with the supplied boundaries' do
        let(:text) { ' a b b-b a ' }

        it 'returns frequency table split by the boundaries' do
          expect(subject.frequency_table).to eq(
            ['a'] => ['b'],
            ['b'] => %w[b b a]
          )
        end
      end
    end

    context 'when called with closures' do
      let(:text) { 'ab.ba!abba?' }
      let(:options) { { closures: ['.', '!', '?'] } }

      it 'returns frequency table first split into phrases by the closures' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end

      context 'when called with some text that starts/ends with the supplied closures' do
        let(:text) { '.ab.ba.abba.' }
        let(:options) { { closures: ['.'] } }

        it 'returns frequency table first split into phrases by the closures' do
          expect(subject.frequency_table).to eq(
            ['a'] => %w[b b], ['b'] => %w[a b a]
          )
        end
      end
    end

    context 'when called with a boundaries and a closures' do
      let(:text) { 'a b. b a. a b b a' }
      let(:options) { { closures: ['.'], boundaries: [' '] } }

      it 'returns frequency table split into phrases by the closures, then the boundaries' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end
    end

    context 'when called with exclusions' do
      let(:text) { 'a b. b a. a b;.. b +a' }
      let(:options) { { closures: ['.'], boundaries: [' '], exclusions: [';..', '+'] } }

      it 'returns frequency table with the exclusions removed' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end
    end
  end
end
