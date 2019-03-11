# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk::Generator do
  subject { ChainPunk::Generator.new(frequency_table) }

  let(:frequency_table) {}
  let(:grapheme_count) { 0 }
  let(:options) { {} }

  context '#phrase' do
    context 'when called with a grapheme count of zero' do
      let(:frequency_table) { { ['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']] } }
      let(:grapheme_count) { 0 }

      it 'returns a phrase with zero graphemes' do
        expect(subject.generate(grapheme_count).length).to eq(0)
      end
    end

    context 'when called with a grapheme count' do
      let(:frequency_table) { { ['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']] } }
      let(:grapheme_count) { 5 }

      it 'returns a phrase with 5 graphemes' do
        expect(subject.generate(grapheme_count, options).length).to eq(5)
      end
    end

    context 'when called with some starting graphemes' do
      let(:frequency_table) { { ['a'] => ['b', 'b'], ['b'] => ['a', 'b', 'a'] } }
      let(:grapheme_count) { 1 }
      let(:options) { { starting_graphemes: [['a']] } }

      it 'returns a phrase starting with those graphemes' do
        expect(subject.generate(grapheme_count, options)).to eq('a')
      end
    end

    context 'when the boundary and closure are nil' do
      let(:frequency_table) { { ['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']] } }
      let(:grapheme_count) { 5 }

      it 'returns a phrase with no boundary or closure' do
        expect(subject.generate(grapheme_count, options).length).to eq(5)
      end
    end

    context 'when called with a boundary' do
      let(:frequency_table) { { ['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']] } }
      let(:grapheme_count) { 5 }
      let(:options) { { boundary: ' ' } }

      it 'returns a phrase of graphemes separated by the boundary' do
        expect(subject.generate(grapheme_count, options).split(' ').length).to eq 5
      end
    end

    context 'when called with a closure' do
      let(:frequency_table) { { ['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']] } }
      let(:grapheme_count) { 5 }
      let(:options) { { closure: '.' } }

      it 'returns a phrase terminated with the closure' do
        expect(subject.generate(grapheme_count, options)[-1]).to eq('.')
      end
    end

    context 'when the generator cannot find a grapheme that follows the current grapheme' do
      let(:frequency_table) { { ['a'] => [['b']] } }
      let(:grapheme_count) { 5 }

      it 'returns before reaching the desired length' do
        expect(subject.generate(grapheme_count, options).length).to eq(2)
      end
    end

    context 'when called with a index size of 0' do
      let(:frequency_table) { { ['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']] } }
      let(:grapheme_count) { 5 }
      let(:options) { { index_size: 0 } }

      it 'blows up' do
        expect { subject.generate(grapheme_count, options) }.to raise_error(ZeroDivisionError)
      end
    end

    context 'when called with a index size of 1' do
      let(:frequency_table) { { ['a'] => [['b'], ['b']], ['b'] => [['a'], ['b'], ['a']] } }
      let(:grapheme_count) { 5 }
      let(:options) { { index_size: 1 } }

      it 'returns a phrase with 5 graphemes' do
        expect(subject.generate(grapheme_count, options).length).to eq(5)
      end
    end

    context 'when called with a index size of 2' do
      let(:frequency_table) { { ['a', 'b'] => [['b', 'a']], ['b', 'a'] => [['a', 'b']] } }
      let(:grapheme_count) { 6 }
      let(:options) { { index_size: 2 } }

      it 'returns a phrase with 5 graphemes' do
        expect(subject.generate(grapheme_count, options).length).to eq(6)
      end

      context 'when called with some starting graphemes' do
        let(:grapheme_count) { 6 }
        let(:options) { { index_size: 2, starting_graphemes: [['c', 'a']] } }

        it 'returns a phrase starting with those graphemes' do
          expect(subject.generate(grapheme_count, options)[0, 2]).to eq('ca')
        end
      end
    end

    context 'when called with a index size that has a remainder when divided by the grapheme count' do
      let(:frequency_table) { { ['a', 'b'] => [['b', 'a']], ['b', 'a'] => [['a', 'b']] } }
      let(:grapheme_count) { 5 }
      let(:options) { { index_size: 2 } }

      it 'returns a phrase with 4 graphemes' do
        expect(subject.generate(grapheme_count, options).length).to eq(4)
      end

      context 'when called with some starting graphemes' do
        let(:grapheme_count) { 5 }
        let(:options) { { index_size: 2, starting_graphemes: [['c', 'a']] } }

        it 'returns a phrase starting with those graphemes' do
          expect(subject.generate(grapheme_count, options)[0, 2]).to eq('ca')
        end
      end
    end
  end
end
