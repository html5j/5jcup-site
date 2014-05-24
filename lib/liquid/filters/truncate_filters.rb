module Liquid
  module Filters
    module TruncateFilters
      def truncate(input, length = 50, truncate_string = "...".freeze)
        if input.nil? then return end
        l = length.to_i - truncate_string.length
        l = 0 if l < 0
        input.length > length.to_i ? input[0...l] + truncate_string : input
      end
    end
    ::Liquid::Template.register_filter(TruncateFilters)
  end
end
