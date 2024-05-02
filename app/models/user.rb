class User < ApplicationRecord
  Attributes = %i(name email password password_confirmation date_of_birth
gender)
  attr_accessor :remember_token, :activation_token

  before_save :downcase_email
  before_create :create_activation_digest

  scope :order_by_name, ->{order(:name)}

  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  validates :email, presence: true, length:
  {maximum: Settings.max_length_email}, uniqueness: true, format:
            {with: Regexp.new(Settings.valid_email_regex)}
  validates :password, presence: true,
    length: {minimum: Settings.min_length_password}, allow_nil: true
  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_column :remember_digest, nil
  end

  def send_mail_activate
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end
  private

  def downcase_email
    email.downcase!
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
