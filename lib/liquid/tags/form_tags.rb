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
        @model =  context[@options['model']]
        @context = context
        field = @options.delete 'field'
        self.send(@handle.to_sym, @model, field, @options)
      end

      def label(input, field, options)

        #"<label for=\"#{goodname(input)}_#{field}\">#{input.class.human_attribute_name(field)}</label>"
        content_tag(:label, input.class.human_attribute_name(field), for:field_id(input, field))
      end
      def input_field(input, field, options)
        value = input.send(field.to_sym)
        #"<input autofocus=\"autofocus\" id=\"#{modelname_single(input)}_#{field}\" keyev=\"true\" mouseev=\"true\" name=\"#{modelname_single(input)}[#{field}]\" type=\"text\" value=\"#{value}\" >"
        options_default = {id:field_id(input, field), keyenv:true, mouseev:true, name:field_name(input, field), type:"text", value:value }
        opts = options_default.merge(options)
        tag(:input, opts)
      end
      def email_field(input, field, options)
        self.input_field(input,field, options.merge({"type"=>"email"}))
      end
      def password_field(input, field, options)
        self.input_field(input,field, options.merge({"type"=>"password", value:""}))
      end
      def check_box(input, field, options)
        values = input.send(field.to_sym)
        sel_key = options.delete('select_list')
        select_list = @context[sel_key]

        options['type']='checkbox'
        options['name']=field_name(input, field) + '[]'
        options['class']=field_id(input, field)
        if (select_list.nil?)
          tag(:input, options)
        else
          # todo should remove this because this contains business logic
          select_list.map{|item|
            if values.nil?
              p '    values is nil'
              options['checked'] = false
            else
              p '    values is not nil'
              p values
              p item._id
              p values.include?(item._id.to_s)
              options['checked'] = values.include?(item._id.to_s)
            end
            options['id'] = item._id
            prizetext = item.prize ? content_tag(:span, '賞金あり', class:"prize") : ""
            subprizetext = item.supplementary_prize ? content_tag(:span, '副賞あり', class:"supplementary_prize") : ""
            title = item.title + prizetext +  subprizetext

            options['value']=item._id
            '<li id="award_' + item._id + '">' + tag(:input, options) + title + '</li>'
          }.join
        end
      end
      def text_area(input, field, options)
        value = input.send(field.to_sym)
        options_default = {id:field_id(input, field), name:field_name(input, field)}
        opts = options_default.merge(options)
        content_tag(:textarea, value, opts)
      end

      def submit(input, field, options)
        options.merge!({type:'submit'})
        tag(:input, options)
      end

      def drop_class_to_table_item(clazz)
        match = /_drops/.match clazz.name.tableize
        match.pre_match
      end

      private
      def field_id(model_instance, field_name)
        modelname_single(model_instance) + "_" + field_name
      end
      def field_name(model_instance, field_name)
        modelname_single(model_instance) + "[" + field_name + "]"
      end
      def modelname_single(model_instance)
        model_instance.class.name.tableize.singularize
      end

    end
    ::Liquid::Template.register_tag('form_tag', FormTags)
  end
end
