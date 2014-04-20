module Liquid
  module Filters
    module FormFilters
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::TagHelper
      def form_tag(value)
        tag(:input, name:'commit', type:'submit', value:value)
      end
    end
    ::Liquid::Template.register_filter(FormFilters)
  end
end
