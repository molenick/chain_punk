# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk::Corpus do
  subject { ChainPunk::Corpus.new(text, options) }
  let(:text) {}
  let(:options) { {} }

  context '#train' do
    context 'when called without text' do
      it 'doesnt do much' do
        expect(subject.frequency_table).to eq({})
      end
    end

    context 'when called with some text' do
      let(:text) { 'acab' }

      it 'returns a frequency_table' do
        expect(subject.frequency_table).to eq(['a'] => [['c'], ['b']], ['c'] => [['a']])
      end

      it 'records the graphemes that start each phrase' do
        expect(subject.seeds).to eq([['a']])
      end
    end

    context 'when called with boundaries' do
      let(:text) { 'a b b-b a' }
      let(:options) { { boundaries: [' ', '-'] } }

      it 'returns a frequency table divided by boundaries' do
        expect(subject.frequency_table).to eq(['a'] => [['b']], ['b'] => [['b'], ['b'], ['a']])
      end

      it 'records the graphemes that start each phrase' do
        expect(subject.seeds).to eq([['a']])
      end

      context 'when called with some text that starts/ends with the supplied boundaries' do
        let(:text) { ' a b b-b a ' }

        it 'returns a frequency table without boundaries' do
          expect(subject.frequency_table).to eq(['a'] => [['b']], ['b'] => [['b'], ['b'], ['a']])
        end

        it 'records the graphemes that start each phrase' do
          expect(subject.seeds).to eq([['a']])
        end
      end
    end

    context 'when called with closures' do
      let(:text) { 'ab.ba!abba?' }
      let(:options) { { closures: ['.', '!', '?'] } }

      it 'returns a frequency table divided by closures' do
        expect(subject.frequency_table).to eq(['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']])
      end

      context 'when called with some text that starts or ends with the supplied closures' do
        let(:text) { '.ab.ba.abba.' }
        let(:options) { { closures: ['.'] } }

        it 'returns a frequency table first split into phrases by the closures' do
          expect(subject.frequency_table).to eq(['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']])
        end

        it 'records the graphemes that start each phrase' do
          expect(subject.seeds).to eq([['a'], ['b'], ['a']])
        end
      end
    end

    context 'when called with exclusions' do
      let(:text) { 'a.b.a.a.b' }
      let(:options) { { exclusions: ['.'] } }

      it 'returns a frequency table with the exclusions removed' do
        expect(subject.frequency_table).to eq(['a'] => [['b'], ['a'], ['b']], ['b'] => [['a']])
      end

      it 'records the graphemes that start each phrase' do
        expect(subject.seeds).to eq([['a']])
      end
    end

    context 'when called with index size of 1' do
      let(:text) { 'acab' }
      let(:options) { { index_size: 1 } }

      it 'returns a frequency_table' do
        expect(subject.frequency_table).to eq(['a'] => [['c'], ['b']], ['c'] => [['a']])
      end

      it 'records the graphemes that start each phrase' do
        expect(subject.seeds).to eq([['a']])
      end
    end

    context 'when called with index size of 2' do
      let(:text) { 'acab.' }
      let(:options) { { index_size: 2, closures: ['.'] } }

      it 'returns a frequency_table' do
        expect(subject.frequency_table).to eq(['a', 'c'] => [['a', 'b']], ['c', 'a'] => [['b']])
      end

      it 'records the graphemes that start each phrase' do
        expect(subject.seeds).to eq([['a', 'c']])
      end
    end

    context 'when called with multiple options' do
      let(:text) { 'j a b. b a. a b b a' }
      let(:options) { { exclusions: ['j'], closures: ['.'], boundaries: [' '] } }

      it 'returns a frequency table split into phrases by the closures, then the boundaries' do
        expect(subject.frequency_table).to eq(['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']])
      end

      it 'records the graphemes that start each phrase' do
        expect(subject.seeds).to eq([['a'], ['b'], ['a']])
      end
    end

    context 'when exclusions, boundaries and closures are the same' do
      let(:text) { 'j a b. b a. a b b a' }
      let(:options) { { exclusions: ['b'], closures: ['b'], boundaries: ['b'] } }

      it 'returns an empty hash' do
        expect(subject.frequency_table).to eq({})
      end

      it 'makes a single starting grapheme out of what is left' do
        expect(subject.seeds).to eq([['j a .  a. a   a']])
      end
    end

    context 'when exclusions, boundaries and closures overlap' do
      let(:text) { 'j a b. b a. a b b a' }
      let(:options) { { exclusions: ['b', 'j'], closures: ['.', 'b'], boundaries: [' ', 'b'] } }

      it 'returns the same as if the overlapping graphemes were not present' do
        expect(subject.frequency_table).to eq(['a'] => [['a']])
      end

      it 'returns seeds as if the overlapping graphemes were not present' do
        expect(subject.seeds).to eq([['a'], ['a'], ['a']])
      end
    end
  end
end
