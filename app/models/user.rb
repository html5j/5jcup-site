class User < Clot::BaseDrop
  include Mongoid::Document
  validates_presence_of :name

  User::SOCIALS = {
    twitter: 'Twitter',
    github: 'Github',
    hatena: 'はてな'
  }

  has_many :user_accounts, :autosave => true, inverse_of: :user
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => User::SOCIALS.map{|s| s[0].to_sym}


  field :name,               :type => String
  field :handle_name,               :type => String
  field :twitter_id,               :type => String
  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time


  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable
  field :need_additional,      :type => Boolean

  has_many :works, :dependent => :delete

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  def self.from_omniauth(auth, current_user)
    authorization = UserAccount.where(:provider => auth.provider, :uid => auth.uid.to_s,
                                      :token => auth.credentials.token,
                                      :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where(email: auth['info']['email']).first : current_user
      if user.blank?
        user = User.new
        user.fetch_details(auth)
        user.password = Devise.friendly_token[0,20]
        user.need_additional = true
      end
      authorization.user = user
      authorization.save unless current_user.nil?
    end
    authorization.user
  end
  def fetch_details(auth)
    self.name = auth.info.name
    self.email = auth.info.email
    self.twitter_id = auth.info.nickname if auth.provider == 'twitter'
    self.handle_name = auth.info.nickname if auth.provider == 'github' || auth.provider == 'hatena'
  end
  def password_required?
    #need_additional ? false : super
    false
  end
  def add_provider(auth)
    self.user_accounts.create(:provider => auth.provider, :uid => auth.uid.to_s,
                              :token => auth.credentials.token,
                              :secret => auth.credentials.secret)
    self.save
  end
  def social_links
    User::SOCIALS.map do |s|
      s.push(self.user_accounts.select{|u| u[:provider] == s[0].to_s}.count > 0)
    end
  end

  def orig_class
    User
  end
end
