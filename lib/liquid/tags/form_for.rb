module Liquid
  module Tags
    class FormFor < ::Locomotive::Liquid::Tags::Hybrid
      include ::Locomotive::Liquid::Tags::PathHelper
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::FormHelper
      Syntax = /([^\s]+)\s+/

      def render(context)
        p @handle
        p @options
        @model =  context[@handle]
        set_variables context
        render_form context
        #form_for (context[@handle], @options) do |f|

        #end
      end

      def render_form(context)
        result = get_form_header(context)
        result += get_form_body(context)
        result += get_form_footer
        result
      end

      private
      def get_form_header(context)
        result = '<form method="POST" accept-charset="UTF-8" ' + @class_string + @id_string + 'action="' + @form_action + '"' + @upload_info + '>'
        if @activity == "edit"
          result += '<input type="hidden" name="_method" value="PUT"/>'
        end


        if context.has_key? 'auth_token'
          result += '<input name="authenticity_token" type="hidden" value="' + context['auth_token'] + '"/>'
        end
        result
      end

      def get_form_body(context)
        p @nodelist
        context.stack do
          render_all(@nodelist, context)
        end
      end

      def get_form_footer
        "</form>"
      end

      def set_variables(context)
        set_controller_action
        set_form_action(context)
        set_class
        set_id
        set_upload
      end
      def set_controller_action
        silence_warnings {
          if @model.nil? || @model.source.nil? || @model.source.new_record? ||  @model.source.id.nil?
            @activity = "new"
          else
            @activity = "edit"
          end
        }
      end

      def set_form_action(context)
        if @activity == "edit"
          @form_action = object_url @model
        elsif @activity == "new"
          @form_action = "/" + @model.class.name.tableize.pluralize
        else
          syntax_error
        end
        if @options["parent"]
          @form_action = object_url(context[@options["parent"]]) + @form_action
        end
        unless @options["post_method"].nil?
          @form_action += '/' + @options["post_method"]
          @activity = @options["post_method"]
        end

      end
      def set_id
        if @options["id"].nil?
          @id_string = 'id="' + @activity + "_" + @model.class.name.tableize.singularize + '" '
        else
          @id_string += 'id="' + @options["id"] + '" '
        end
      end

      def set_class
        @class_string = 'class="' + @activity + "_" + @model.class.name.tableize.singularize
        unless @options["class"].nil?
          @class_string += ' ' + @options["class"]
        end
        @class_string += '" '
      end

      def set_upload
        if @options["uploading"] || @options["multipart"] == "true"
          @upload_info = ' enctype="multipart/form-data"'
        else
          @upload_info = ''
        end
      end

    end
    ::Liquid::Template.register_tag('form_for', FormFor)
  end
end
