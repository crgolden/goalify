class User < ActiveRecord::Base

  include PgSearch

  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable, :recoverable, :confirmable,
         :rememberable, :trackable, :validatable, :lockable, :timeoutable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  has_many :tokens, dependent: :destroy
  has_many :goals
  has_many :comments
  has_many :scores, through: :goals

  has_and_belongs_to_many :subscriptions, class_name: 'Goal', touch: true

  validates :name, presence: true
  validates :authentication_token, uniqueness: true

  paginates_per 10
  pg_search_scope :search_name, against: :name

  enum role: [:regular, :admin]
  enum status: [:active, :inactive]

  # ensure user account is active
  def active_for_authentication?
    super && active?
  end

  def comments?
    self.comments.any?
  end

  def self.demo_user
    User.includes(:goals).find_by email: Rails.application.secrets.admin_email
  end

  def self.exists_for_email?(email)
    find_by email: email
  end

  def self.from_omniauth(info)
    create name: info.name, email: info.email, password: Devise.friendly_token[0, 20], confirmed_at: Time.now
  end

  def goals?
    self.goals.any?
  end

  # provide a custom message for a deleted account
  def inactive_message
    active? ? super : :deleted_account
  end

  def is_subscribed_to?(goal)
    self.subscriptions.include? goal
  end

  def scores?
    self.scores.any?
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute :status, :inactive
  end

  def subscriptions?
    self.subscriptions.any?
  end

  def tokens?
    self.tokens.any?
  end

  def self.with_highest_score
    find_by score: maximum(:score)
  end

end
