module ChainPunk
  class Corpus
    attr_reader :frequency_table

    def initialize(text, seperators = [], terminator = nil, exclusions = [])
      train(text, seperators, terminator, exclusions)
    end

    def train(text, seperators = [], terminator = nil, exclusions = [])
      exclusion_text = remove_exclusions(text, exclusions)
      text_phrases = split_text_phrases(exclusion_text, terminator)
      grapheme_phrases = process_text_phrases(text_phrases, seperators)
      @frequency_table = process_graphemes(grapheme_phrases)
    end

    private

    def remove_exclusions(text, exclusions)
      exclusions.each do |exclusion|
        text = text.gsub(exclusion, '')
      end

      text
    end

    def split_text_phrases(text, terminator)
      return [text] if terminator.nil?

      text.split(terminator)
    end

    def process_text_phrases(phrases, seperators = [])
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
