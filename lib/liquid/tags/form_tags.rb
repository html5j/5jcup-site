module Liquid
  module Tags
    class FormTags < ::Locomotive::Liquid::Tags::Hybrid
      include ::Locomotive::Liquid::Tags::PathHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::FormHelper
      include ActionView::Helpers::TagHelper
      Syntax = /([^\s]+)\s+/

      # how to call this tag
      #
      # {% form_tag label_type, model:model_name, field:field_name %}
      # * the model should be included in the locomotive context
      # example:
      # {% form_tag label, model:user, field:name %}<br />
      #
      def render(context)
        p @handle
        p @options
        @model =  context[@options['model']]
        field = @options.delete 'field'
        p @model
        self.send(@handle.to_sym, @model, field, @options)
      end

      def label(input, field, options)

        #"<label for=\"#{goodname(input)}_#{field}\">#{input.class.human_attribute_name(field)}</label>"
        content_tag(:label, input.class.human_attribute_name(field), for:field_id(input, field))
      end
      def input_field(input, field, options)
        value = input.send(field.to_sym)
        "<input autofocus=\"autofocus\" id=\"#{modelname_single(input)}_#{field}\" keyev=\"true\" mouseev=\"true\" name=\"#{goodname(input)}[#{field}]\" type=\"text\" value=\"#{value}\" >"
      end
      def email_field(input, field, options)
        self.input_field(input,field, options.merge({"type"=>"email"}))
      end
      def drop_class_to_table_item(clazz)
        match = /_drops/.match clazz.name.tableize
        match.pre_match
      end
      private
      def field_id(model_instance, field_name)
        modelname_single(model_instance) + "_" + field_name
      end
      def modelname_single(model_instance)
        model_instance.class.name.tableize.singularize
      end

    end
    ::Liquid::Template.register_tag('form_tag', FormTags)
  end
end
