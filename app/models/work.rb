class Work < Clot::BaseDrop
  include Mongoid::Document
  validates_presence_of :title
  validates_presence_of :handle_name
  validates :handle_name, :length => { :maximum => 20 }
  validates :twitter_id, :length => { :maximum => 20 }
  validates :title, :length => { :maximum => 40 }
  validates :url, :format => URI::regexp(%w(http https)), :allow_blank => true
  validates :description, :length => { :maximum => 500 }

  field :title, type: String
  field :description, type: String
  field :award_ids, type: Array
  field :members, type: Array
  field :tested_environment, type: String
  field :url, type: String
  field :technical_appeal_point, type: String
  field :plan_appeal_point, type: String
  field :remarks, type: String
  field :published, type: Boolean
  field :file, type: String
  field :file_cache, type: String
  field :image1, type: String
  field :image2, type: String
  field :image3, type: String
  field :image1_cache, type: String
  field :image2_cache, type: String
  field :image3_cache, type: String
  field :handle_name, type: String
  field :twitter_id, type:String
  belongs_to :user
  mount_uploader :file, Locomotive::WorksUploader
  mount_uploader :image1, Locomotive::ImageUploader
  mount_uploader :image2, Locomotive::ImageUploader
  mount_uploader :image3, Locomotive::ImageUploader

  def awards=(awards)
    @awards = awards
  end
  def awards
    @awards
  end

  validate do |work|
    WorkValidator.new(work).validate(@awards)
  end
end

class WorkValidator
  def initialize(work)
    @work = work
  end
  def validate(awards)
    @work.errors['url'] << 'かアプリケーションはどちらか必ず登録してください。' if @work.url.blank? && @work.file.blank?
    if @work.award_ids.nil?
      @work.errors["award_ids"] << ':テーマを1つ選択してください'
    else
      @work.errors["award_ids"] << ':テーマを1つ選択してください' unless count_by_theme(awards, @work.award_ids, 'テーマ')  == 1
      @work.errors["award_ids"] << ':ノンジャンル賞は3つまでしか選択できません' if count_by_theme(awards, @work.award_ids, 'ノンジャンル') > 3
    end
  end
  private
  def count_by_theme(awards, category_ids, theme)
    return 0 if awards.nil?
    theme_id = nil
    p awards
    awards[0]['custom_fields_recipe']['rules'].select{|rule|
      if rule['name'] == 'category'
        rule['select_options'].select{|opt|
          theme_id = opt['_id'] if opt['name']['ja'] == theme
        }
      end
    }
    target_awards = awards.select{|a|
      a.category_id == theme_id
    }
    target_award_ids = target_awards.map{|a| a._id.to_s}
    category_ids.select{|id|
      target_award_ids.include?(id.to_s)
    }.length
  end
end
