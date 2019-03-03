module ChainPunk
  class Corpus
    attr_reader :frequency_table

    def initialize(text, separator = nil, terminator = nil, exclusions = [])
      train(text, separator, terminator, exclusions)
    end

    def train(text, separator = nil, terminator = nil, exclusions = [])
      exclusion_text = remove_exclusions(text, exclusions)
      text_phrases = split_text_phrases(exclusion_text, terminator)
      grapheme_phrases = process_text_phrases(text_phrases, separator)
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

    def process_text_phrases(phrases, separator = nil)
      grapheme_phrases = []

      until phrases.empty?
        grapheme_phrase = separator.nil? ? phrases[0].chars : phrases[0].split(separator)
        grapheme_phrases << grapheme_phrase
        phrases.shift
      end

      grapheme_phrases
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
