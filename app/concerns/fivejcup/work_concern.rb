module Fivejcup
  module WorkConcern
    extend ActiveSupport::Concern

    def new_works
      return @new_works unless @new_works.nil?
      new_works = Work.order_by(:_id.desc).limit(5)
      @new_works = []
      award_content = current_site.content_types.where(slug: 'awards').first
      new_works.each do |work|
        work.awards = award_content.entries.in(_id: work.award_ids)
        @new_works << work
      end
      @new_works
    end
    
  end
end
