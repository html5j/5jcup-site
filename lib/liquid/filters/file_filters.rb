module Liquid
  module Filters
    module FileFilters
      def basename(input, suffix="")
        if input.nil? then return "" end
        return File.basename(input, suffix)
      end
    end
    ::Liquid::Template.register_filter(FileFilters)
  end
end
