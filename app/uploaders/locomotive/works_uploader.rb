# encoding: utf-8
module Locomotive
  class WorksUploader < ::CarrierWave::Uploader::Base

    def store_dir
      self.build_store_dir('site', 'works', model.id)
    end

  end
end
