module Locomotive
  module Public
    class PagesController < ApplicationController

      include Locomotive::Routing::SiteDispatcher
      include Locomotive::Render
      include Locomotive::ActionController::LocaleHelpers
      include Auth::AuthPage
      include Fivejcup::Award

      before_filter :require_site

      before_filter :authenticate_locomotive_account!, only: [:show_toolbar]

      before_filter :validate_site_membership, only: [:show_toolbar]

      before_filter :set_toolbar_locale, only: :show_toolbar

      before_filter :set_locale, only: [:show, :edit]

      helper Locomotive::BaseHelper

      def show_toolbar
        render layout: false
      end

      def show
        if (current_user)
          render_locomotive_page(nil, {'username' => current_user.name, 'awards' => awards, 'userid' => current_user.id.to_s})
        else
          render_locomotive_page(nil, {'awards'=> awards })
        end
      end

      def edit
        @editing = true
        render_locomotive_page
      end

      protected

      def set_toolbar_locale
        ::I18n.locale = current_locomotive_account.locale rescue Locomotive.config.default_locale
        ::Mongoid::Fields::I18n.locale = params[:locale] || current_site.default_locale
      end

      def set_locale
        ::Mongoid::Fields::I18n.locale = params[:locale] || current_site.default_locale
        ::I18n.locale = ::Mongoid::Fields::I18n.locale

        self.setup_i18n_fallbacks
      end

      # override lib/locomotive/render.rb
      def prepare_and_set_response(output)
        flash.discard

        response.headers['Content-Type']  = "#{@page.response_type}; charset=utf-8"
        response.headers['Editable']      = 'true' unless self.editing_page? || current_locomotive_account.nil?

        if @page.with_cache?
          fresh_when etag: @page, last_modified: @page.updated_at.utc, public: true

          if @page.cache_strategy != 'simple' # varnish
            response.headers['Editable']      = ''
            response.cache_control[:max_age]  = @page.cache_strategy
          end
        end

        render text: output.gsub('{{userid}}', user_signed_in? ? current_user.id.to_s : ""), layout: false, status: page_status unless performed?
      end

    end
  end
end



