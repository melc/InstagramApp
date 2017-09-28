class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:instagram, :facebook, :twitter, :google_apps],
         :authentication_keys => [:login]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  has_one :photostreams

  validates :username,
            :presence => true,
            :uniqueness => {
                :case_sensitive => false
            }

  # Only allow letter, number, underscore and punctuation.
  validate :validate_username

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def twitter
    photostreams.where( :provider => "twitter" ).first
  end
  def twitter_client
    @twitter_client ||= Twitter.client( access_token: twitter.access_token )
  end
  def facebook
    photostreams.where( :provider => "facebook" ).first
  end
  def facebook_client
    @facebook_client ||= Facebook.client( access_token: facebook.access_token )
  end
  def instagram
    photostreams.where( :provider => "instagram" ).first
  end
  def instagram_client
    @instagram_client ||= Instagram.client( access_token: instagram.access_token )
  end
  def google_oauth2
    photostreams.where( :provider => "google_oauth2" ).first
  end
  def google_oauth2_client
    if !@google_oauth2_client
      @google_oauth2_client = Google::APIClient.new(:application_name => 'HappySeed App', :application_version => "1.0.0" )
      @google_oauth2_client.authorization.update_token!({:access_token => google_oauth2.access_token, :refresh_token => google_oauth2.refreshtoken})
    end
    @google_oauth2_client
  end
end
