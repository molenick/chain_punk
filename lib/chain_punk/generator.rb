module ChainPunk
  class Generator
    def initialize(frequency_table)
      @frequency_table = frequency_table
    end

    def generate(grapheme_count, options = {})
      boundary = options[:boundary] || ''
      index_size = options[:index_size] || 1
      starting_graphemes = options[:starting_graphemes]
      create_phrase(grapheme_count, starting_graphemes, index_size, boundary, options[:closure])
    end

    private

    def create_phrase(grapheme_count, starting_graphemes, index_size, boundary, closure)
      graphemes = starting_grapheme(starting_graphemes)
      phrase = []

      (1..grapheme_count / index_size).each do
        phrase << graphemes
        break if @frequency_table[graphemes].nil?

        @frequency_table[graphemes]
        graphemes = @frequency_table[graphemes].sample
      end

      "#{phrase.flatten.join(boundary)}#{closure}"
    end

    def starting_grapheme(starting_graphemes = nil)
      return @frequency_table.keys.sample if starting_graphemes.nil?

      starting_graphemes.sample
    end
  end
end
