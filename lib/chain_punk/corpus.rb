# frozen_string_literal: true

module ChainPunk
  class Corpus
    attr_reader :frequency_table, :seeds

    def initialize(text, options = {})
      train(text, options)
    end

    def train(text, options = {})
      exclusion_text = remove_exclusions(text, options[:exclusions])
      text_phrases = process_sets(exclusion_text, options[:closures])
      grapheme_phrases = process_phrases(text_phrases, options[:boundaries])
      @frequency_table, @seeds = process_graphemes(grapheme_phrases, options[:index_size])
    end

    private

    def remove_exclusions(text, exclusions = nil)
      return text if exclusions.nil?

      exclusions.each do |exclusion|
        text = text.gsub(exclusion, '')
      end

      text
    end

    def process_sets(text, closures = nil)
      return [text] if closures.nil?

      text.split(Regexp.union(closures)).reject(&:empty?)
    end

    def process_phrases(phrases, boundaries = nil)
      grapheme_phrases = []
      until phrases.empty?
        grapheme_phrases << split_phrase(phrases[0], boundaries)
        phrases.shift
      end

      grapheme_phrases
    end

    def split_phrase(phrase, boundaries = nil)
      return phrase.to_s.chars if boundaries.nil?

      phrase.split(Regexp.union(boundaries)).reject(&:empty?)
    end

    def process_graphemes(grapheme_phrases, index_size = 1, frequency_table = {}, seeds = [])
      index_size ||= 1
      grapheme_phrases.each do |phrase|
        seeds << phrase[0, index_size]

        while phrase.size > index_size
          (frequency_table[phrase[0, index_size]] ||= []) << phrase[index_size, index_size]
          phrase.shift
        end
      end

      [frequency_table, seeds]
    end
  end
end
