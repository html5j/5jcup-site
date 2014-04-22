# encoding: utf-8
require 'carrierwave/processing/rmagick'

module Locomotive
  class ImageUploader < ::CarrierWave::Uploader::Base
    include ::CarrierWave::RMagick

    process resize_to_limit: [1200, 800]

    def store_dir
      self.build_store_dir('works', model.id, 'image')
    end
    def extension_white_list
      %w(jpg jpeg gif png)
    end

  end
end
