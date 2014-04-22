module Carrierwave
  module Uploader
    module Work

      extend ActiveSupport::Concern

      included do |base|

        include ::CarrierWave::MimeTypes

        process :set_content_type_of_model

      end

      module ClassMethods

        def content_types
          {
            image:      ['image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg', 'image/x-icon'],
              media:      [/^video/, 'application/x-shockwave-flash', 'application/x-flash-video', 'application/x-swf', /^audio/, 'application/ogg', 'application/x-mp3'],
              pdf:        ['application/pdf', 'application/x-pdf'],
              stylesheet: ['text/css'],
              javascript: ['text/javascript', 'text/js', 'application/x-javascript', 'application/javascript', 'text/x-component'],
              font:       [/^application\/.*font/, 'application/x-font-ttf', 'application/vnd.ms-fontobject', 'image/svg+xml', 'application/x-woff', 'application/x-font-truetype', 'application/x-font-woff']
          }
        end

      end

      def set_content_type_of_model(*args)
        value         = :other
        content_type  = file.content_type

        if content_type.blank? || content_type == 'application/octet-stream'
          content_type = File.mime_type?(original_filename)
        end

        self.class.content_types.each_pair do |type, rules|
          rules.each do |rule|
            case rule
            when String then value = type if content_type == rule
            when Regexp then value = type if (content_type =~ rule) == 0
            end
          end
        end

      end

    end
  end
end
