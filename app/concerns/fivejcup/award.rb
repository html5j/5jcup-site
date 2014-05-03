module Fivejcup
  module Award
    extend ActiveSupport::Concern

    def awards
      return @awards unless @awards.nil?
      award_content = current_site.content_types.where(slug: 'awards').first
      max = 9999999999999999
      awards = award_content.entries.sort{|a,b|
        a_o = nil_max(a['order'])
        b_o = nil_max(b['order'])
        if (a_o == b_o)
          a_p = nil_max(a['prize'].to_i)
          b_p = nil_max(b['prize'].to_i)
          if (a_p == b_p)
            a_t = nil_max(a['title'])
            b_t = nil_max(b['title'])
            a_t <=> b_t
          else
            a_p <=> b_p
          end
        else
          a_o <=> b_o
        end
      }
      @awards_tmp = {}
      awards.each{|award|
        if @awards_tmp[award.category].nil?
          @awards_tmp[award.category] = [award]
        else
          @awards_tmp[award.category] << award
        end
      }
      @awards = {}
      @awards['テーマ'] = @awards_tmp['テーマ']
      @awards['プラットフォーム'] = @awards_tmp['プラットフォーム']
      @awards['ライブラリ・API'] = @awards_tmp['ライブラリ・API']
      @awards['ノンジャンル'] = @awards_tmp['ノンジャンル']

      @awards
    end
    def nil_max(data)
      data.nil? ? 99999999999999 : data
    end
  end
end
