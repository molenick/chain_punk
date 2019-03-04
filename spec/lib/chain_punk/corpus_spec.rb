# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk::Corpus do
  subject { ChainPunk::Corpus.new(text, separators, terminators, exclusions) }

  let(:text) { nil }
  let(:separators) { [] }
  let(:terminators) { [] }
  let(:exclusions) { [] }

  context '#train' do
    context 'when called with some text' do
      let(:text) { 'abbba' }
      let(:text) { 'a b. b a. a b c. b a' }
      let(:terminators) { '.' }
      let(:separators) { ' ' }

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

    context 'when called with separators' do
      let(:text) { 'a b b-b a' }
      let(:separators) { [' ', '-'] }

      it 'returns frequency table split by the separators' do
        expect(subject.frequency_table).to eq(
          ['a'] => ['b'], ['b'] => %w[b b a]
        )
      end

      context 'when called with some text that starts/ends with the supplied separators' do
        let(:text) { ' a b b-b a ' }

        it 'returns frequency table split by the separators' do
          expect(subject.frequency_table).to eq(
            ['a'] => ['b'],
            ['b'] => %w[b b a]
          )
        end
      end
    end

    context 'when called with terminatorss' do
      let(:text) { 'ab.ba!abba?' }
      let(:terminators) { ['.', '!', '?'] }

      it 'returns frequency table first split into phrases by the terminators' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end

      context 'when called with some text that starts/ends with the supplied terminators' do
        let(:text) { '.ab.ba.abba.' }
        let(:terminators) { '.' }

        it 'returns frequency table first split into phrases by the terminators' do
          expect(subject.frequency_table).to eq(
            ['a'] => %w[b b], ['b'] => %w[a b a]
          )
        end
      end
    end

    context 'when called with a separators and a terminators' do
      let(:text) { 'a b. b a. a b b a' }
      let(:terminators) { '.' }
      let(:separators) { ' ' }

      it 'returns frequency table split into phrases by the terminators, then the separators' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end
    end

    context 'when called with exclusions' do
      let(:text) { 'a b. b a. a b;.. b +a' }
      let(:terminators) { '.' }
      let(:separators) { ' ' }
      let(:exclusions) { [';..', '+'] }

      it 'returns frequency table with the exclusions removed' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end
    end
  end
end
