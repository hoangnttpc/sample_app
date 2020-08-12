class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation).freeze
  RESET_PASSWORD_USERS_PARAMS = %i(password password_confirmation).freeze

  has_many :microposts, dependent: :destroy

  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name, presence: true,
    length: {maximum: Settings.validations.name.max_length}

  validates :email, presence: true,
    length: {maximum: Settings.validations.email.max_length},
    format: {with: Settings.validations.email.regex},
    uniqueness: true

  validates :password, presence: true,
    length: {minimum: Settings.validations.password.min_length},
    allow_nil: true

  has_secure_password

  before_save :email_downcase
  before_create :create_activation_digest

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update :remember_digest, User.digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.password_reset_expired.hours.ago
  end

  def feed
    microposts
  end

  private

  def email_downcase
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
