module Liquid
  module Filters
    module FormFilters
      include ActionView::Helpers::FormHelper
      def label(input, field)
        "<label for=\"#{goodname(input)}_#{field}\">#{input.class.human_attribute_name(field)}</label>"
      end
      def input_field(input, field)
        value = input.send(field.to_sym)
        "<input autofocus=\"autofocus\" id=\"#{goodname(input)}_#{field}\" keyev=\"true\" mouseev=\"true\" name=\"#{goodname(input)}[#{field}]\" type=\"text\" value=\"#{value}\" required=\"\" >"
      end
      def drop_class_to_table_item(clazz)
        match = /_drops/.match clazz.name.tableize
        match.pre_match
      end
      private
      def goodname(model_instance)
        model_instance.class.name.tableize.singularize
      end
    end
    ::Liquid::Template.register_filter(FormFilters)
  end
end
