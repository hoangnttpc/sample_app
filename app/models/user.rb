class User < ApplicationRecord
  validates :name, presence: true,
    length: {maximum: Settings.validations.name.max_length}

  validates :email, presence: true,
    length: {maximum: Settings.validations.email.max_length},
    format: {with: Settings.validations.email.regex},
    uniqueness: {case_sensitive: false}

  validates :password, presence: true,
    length: {minimum: Settings.validations.password.min_length}

  has_secure_password

  before_save :email_downcase

  private

  def email_downcase
    email.downcase!
  end
end
