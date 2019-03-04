module ChainPunk
  class Generator
    def initialize(frequency_table)
      @frequency_table = frequency_table
    end

    def create_phrase(grapheme_count, separator = nil, terminator = nil, starting_graphemes = [])
      grapheme = starting_grapheme(starting_graphemes)
      phrase = grapheme

      (2..grapheme_count).each do
        break if @frequency_table[[grapheme]].nil?

        next_grapheme = @frequency_table[[grapheme]].sample
        phrase = "#{phrase}#{separator}#{next_grapheme}"
        grapheme = next_grapheme
      end
      "#{phrase}#{terminator}"
    end

    private

    def starting_grapheme(starting_graphemes = [])
      return @frequency_table.keys.sample[0] if starting_graphemes.empty?

      starting_graphemes.sample
    end
  end
end
