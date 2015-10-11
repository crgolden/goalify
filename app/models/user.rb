class User < ActiveRecord::Base
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable, :recoverable, :confirmable,
         :rememberable, :trackable, :validatable, :lockable, :timeoutable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many :tokens, dependent: :destroy
  has_many :goals
  has_many :comments

  validates :name, presence: true
  validates :email, presence: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i},
            uniqueness: {case_sensitive: false}
  enum role: [:regular, :admin]
  enum status: [:active, :inactive]

  # ensure user account is active
  def active_for_authentication?
    super && active?
  end

  def self.exists_for_email?(email)
    find_by email: email
  end

  def self.from_omniauth(info)
    create name: info.name, email: info.email, password: Devise.friendly_token[0, 20], confirmed_at: Time.now
  end

  # provide a custom message for a deleted account
  def inactive_message
    active? ? super : :deleted_account
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute :status, 1
  end
end
