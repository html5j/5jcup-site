module Liquid
  module Filters
    module CurrencyFilters
      def currency(input, currency = '')
        if input.nil? then return end
        (currency == 'JPY') ? num_to_jpy(input.to_i) : input
      end
      private
      def num_to_jpy(input)
        if input > 10000
          (input / 10000).truncate.to_s + '万' + ((input % 10000 != 0) ? (input % 10000).to_s : "")
        else
          input.to_s
        end
      end
    end
    ::Liquid::Template.register_filter(CurrencyFilters)
  end
end
