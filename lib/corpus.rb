module ChainPunk
  class Corpus
    def train(text, seperator = nil, terminator = nil)
      text_phrases = split_text_phrases(text, terminator)
      grapheme_phrases = process_text_phrases(text_phrases, seperator)
      process_graphemes(grapheme_phrases)
    end

    private

    def split_text_phrases(text, terminator)
      return [text] if terminator.nil?

      text.split(terminator)
    end

    def process_text_phrases(phrases, seperator = nil)
      grapheme_phrases = []

      until phrases.empty?
        grapheme_phrase = seperator.nil? ? phrases[0].chars : phrases[0].split(seperator)
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
