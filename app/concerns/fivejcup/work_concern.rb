module Fivejcup
  module WorkConcern
    extend ActiveSupport::Concern

    def new_works
      return @new_works unless @new_works.nil?
      new_works = Work.where({:published => true}).order_by(:_id.desc).limit(5)
      @new_works = []
      award_content = current_site.content_types.where(slug: 'awards').first
      new_works.each do |work|
        work.awards = award_content.entries.in(_id: work.award_ids)
        @new_works << work
      end
      @new_works
    end

    def random_works
      return @random_works unless @random_works.nil?
      random_work_ids = Work.where({:published => true}).all.pluck(:_id).shuffle[0..5]
      random_works = Work.in(_id: random_work_ids)
      @random_works = []
      award_content = current_site.content_types.where(slug: 'awards').first
      random_works.each do |work|
        work.awards = award_content.entries.in(_id: work.award_ids)
        @random_works << work
      end
      @random_works
    end
    
  end
end
