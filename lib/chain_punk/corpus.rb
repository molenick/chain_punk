module ChainPunk
  class Corpus
    attr_reader :frequency_table, :starting_graphemes

    def initialize(text, options = {})
      train(text, options)
    end

    def train(text, options = {})
      exclusion_text = remove_exclusions(text, options[:exclusions])
      text_phrases = process_sets(exclusion_text, options[:terminators])
      grapheme_phrases = process_phrases(text_phrases, options[:separators])
      @frequency_table, @starting_graphemes = process_graphemes(grapheme_phrases)
    end

    private

    def remove_exclusions(text, exclusions = nil)
      return text if exclusions.nil?

      exclusions.each do |exclusion|
        text = text.gsub(exclusion, '')
      end

      text
    end

    def process_sets(text, terminators = nil)
      return [text] if terminators.nil?

      text.split(Regexp.union(terminators)).reject(&:empty?)
    end

    def process_phrases(phrases, separators = nil)
      grapheme_phrases = []
      until phrases.empty?
        grapheme_phrases << split_phrase(phrases[0], separators)
        phrases.shift
      end

      grapheme_phrases
    end

    def split_phrase(phrase, separators = nil)
      return phrase.chars if separators.nil?

      phrase.split(Regexp.union(separators)).reject(&:empty?)
    end

    def process_graphemes(grapheme_phrases)
      frequency_table = {}
      starting_graphemes = []

      grapheme_phrases.each do |phrase|
        starting_graphemes << phrase[0]

        while phrase.size > 1
          (frequency_table[phrase[0, 1]] ||= []) << phrase[1]
          phrase.shift
        end
      end

      [frequency_table, starting_graphemes]
    end
  end
end
