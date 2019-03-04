module ChainPunk
  class Corpus
    attr_reader :frequency_table

    def initialize(text, seperators = [], terminators = [], exclusions = [])
      train(text, seperators, terminators, exclusions)
    end

    def train(text, seperators = [], terminators = [], exclusions = [])
      exclusion_text = remove_exclusions(text, exclusions)
      text_phrases = process_sets(exclusion_text, terminators)
      grapheme_phrases = process_phrases(text_phrases, seperators)
      @frequency_table = process_graphemes(grapheme_phrases)
    end

    private

    def remove_exclusions(text, exclusions)
      exclusions.each do |exclusion|
        text = text.gsub(exclusion, '')
      end

      text
    end

    def process_sets(text, terminators)
      return [text] if terminators.empty?

      text.split(Regexp.union(terminators)).reject(&:empty?)
    end

    def process_phrases(phrases, seperators = [])
      grapheme_phrases = []
      until phrases.empty?
        grapheme_phrases << split_phrase(phrases[0], seperators)
        phrases.shift
      end

      grapheme_phrases
    end

    def split_phrase(phrase, seperators = [])
      return phrase.chars if seperators.empty?

      phrase.split(Regexp.union(seperators)).reject(&:empty?)
    end

    def process_graphemes(grapheme_phrases)
      corpus = {}

      until grapheme_phrases.empty?
        graphemes = grapheme_phrases[0]

        while graphemes.size > 1
          (corpus[graphemes[0, 1]] ||= []) << graphemes[1]
          graphemes.shift
        end

        grapheme_phrases.shift
      end

      corpus
    end
  end
end
