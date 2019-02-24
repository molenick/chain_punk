module ChainPunk
  class Generator
    def phrase(corpus, length, separator = nil, terminator = nil)
      grapheme = corpus.keys.sample[0]
      phrase = grapheme

      (2..length).each do |_i|
        next_grapheme = corpus[[grapheme]].sample
        phrase = "#{phrase}#{separator}#{next_grapheme}"
        grapheme = next_grapheme
      end
      "#{phrase}#{terminator}"
    end
  end
end
