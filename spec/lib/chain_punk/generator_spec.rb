# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ChainPunk::Generator do
  subject { ChainPunk::Generator.new(frequency_table) }

  let(:frequency_table) {}
  let(:grapheme_count) { 0 }
  let(:options) { {} }

  context '#phrase' do
    context 'when called with a grapheme count of zero' do
      let(:frequency_table) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:grapheme_count) { 0 }

      it 'returns a phrase with one grapheme' do
        expect(subject.create_phrase(grapheme_count).length).to eq(1)
      end
    end

    context 'when called with a grapheme count' do
      let(:frequency_table) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:grapheme_count) { 5 }

      it 'returns a phrase with 5 graphemes' do
        expect(subject.create_phrase(grapheme_count, options).length).to eq(5)
      end
    end

    context 'when called with some starting graphemes' do
      let(:frequency_table) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:grapheme_count) { 1 }
      let(:options) { { starting_graphemes: ['a'] } }

      it 'returns a phrase with 5 graphemes' do
        expect(subject.create_phrase(grapheme_count, options)).to eq('a')
      end
    end

    context 'when the seperator and terminator are nil' do
      let(:frequency_table) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:grapheme_count) { 5 }

      it 'returns a phrase with no seperator or terminator' do
        expect(subject.create_phrase(grapheme_count, options).length).to eq(5)
      end
    end

    context 'when called with a separator' do
      let(:frequency_table) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:grapheme_count) { 5 }
      let(:options) { { separator: ' ' } }

      it 'returns a phrase of graphemes separated by the separator' do
        expect(subject.create_phrase(grapheme_count, options).split(' ').length).to eq 5
      end
    end

    context 'when called with a terminator' do
      let(:frequency_table) { { ['a'] => %w[b b], ['b'] => %w[a b a] } }
      let(:grapheme_count) { 5 }
      let(:options) { { terminator: '.' } }

      it 'returns a phrase terminated with the terminator' do
        expect(subject.create_phrase(grapheme_count, options)[-1]).to eq('.')
      end
    end

    context 'when the generator hits a dead end' do
      let(:frequency_table) { { ['a'] => %w[b] } }
      let(:grapheme_count) { 5 }

      it 'returns before reaching the desired length' do
        expect(subject.create_phrase(grapheme_count, options).length).to eq(2)
      end
    end
  end
end
