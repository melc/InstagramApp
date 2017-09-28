class Photostream < ActiveRecord::Base
  belongs_to :user, dependent: :destroy

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    photostream = find_by(provider: auth.provider, uid: auth.uid)
    photostream = create(uid: auth.uid, provider: auth.provider) if photostream.nil?
    photostream.access_token = auth.credentials.token
    photostream.username = auth.info.nickname
    photostream.fullname = auth.info.name
    photostream.save
    photostream
  end
end