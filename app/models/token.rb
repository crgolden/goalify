class Token < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :user, :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.from_omniauth(auth, user)
    user.tokens.create access_token: auth.credentials.token, image: auth.info.image,
                       refresh_token: auth.credentials.refresh_token, uid: auth.uid,
                       expires_at: auth.credentials.expires_at, provider: auth.provider
  end

  def self.exists_for_uid_and_provider?(auth)
    find_by uid: auth.uid, provider: auth.provider
  end

end
