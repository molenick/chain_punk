module ChainPunk
  class Generator
    def initialize(frequency_table)
      @frequency_table = frequency_table
    end

    def create_phrase(grapheme_count, options = {})
      grapheme = starting_grapheme(options[:starting_graphemes])
      phrase = grapheme

      (2..grapheme_count).each do
        break if @frequency_table[[grapheme]].nil?

        next_grapheme = @frequency_table[[grapheme]].sample
        phrase = "#{phrase}#{options[:boundary]}#{next_grapheme}"
        grapheme = next_grapheme
      end
      "#{phrase}#{options[:closure]}"
    end

    private

    def starting_grapheme(starting_graphemes = nil)
      return @frequency_table.keys.sample[0] if starting_graphemes.nil?

      starting_graphemes.sample
    end
  end
end
