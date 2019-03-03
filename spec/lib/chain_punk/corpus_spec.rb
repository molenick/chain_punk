# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk::Corpus do
  subject { ChainPunk::Corpus.new(text, separator, terminator, exclusions) }

  let(:text) { nil }
  let(:separator) { nil }
  let(:terminator) { nil }
  let(:exclusions) { [] }

  context '#train' do
    context 'when called with some text' do
      let(:text) { 'abbba' }

      it 'returns a corpus' do
        expect(subject.frequency_table).to eq(
          ['a'] => ['b'],
          ['b'] => %w[b b a]
        )
      end
    end

    context 'when called with a separator' do
      let(:text) { 'a b bb a' }
      let(:separator) { ' ' }

      it 'returns frequency table split by the separator' do
        expect(subject.frequency_table).to eq(
          ['a'] => ['b'],
          ['b'] => ['bb'],
          ['bb'] => ['a']
        )
      end

      context 'when called with some text that starts/ends with the supplied separator' do
        let(:text) { ' a b bb a ' }

        it 'returns frequency table split by the separator' do
          expect(subject.frequency_table).to eq(
            ['a'] => ['b'],
            ['b'] => ['bb'],
            ['bb'] => ['a']
          )
        end
      end
    end

    context 'when called with a terminator' do
      let(:text) { 'ab.ba.abba' }
      let(:terminator) { '.' }

      it 'returns frequency table first split into phrases by the terminator' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end

      context 'when called with some text that starts/ends with the supplied terminator' do
        let(:text) { '.ab.ba.abba.' }
        let(:terminator) { '.' }

        it 'returns frequency table first split into phrases by the terminator' do
          expect(subject.frequency_table).to eq(
            ['a'] => %w[b b], ['b'] => %w[a b a]
          )
        end
      end
    end

    context 'when called with a separator and a terminator' do
      let(:text) { 'a b. b a. a b b a' }
      let(:terminator) { '.' }
      let(:separator) { ' ' }

      it 'returns frequency table split into phrases by the terminator, then the separator' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end
    end

    context 'when called with exclusions' do
      let(:text) { 'a b. b a. a b;.. b +a' }
      let(:terminator) { '.' }
      let(:separator) { ' ' }
      let(:exclusions) { [';..', '+'] }

      it 'returns frequency table with the exclusions removed' do
        expect(subject.frequency_table).to eq(
          ['a'] => %w[b b], ['b'] => %w[a b a]
        )
      end
    end
  end
end
