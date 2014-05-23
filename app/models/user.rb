class User < ActiveRecord::Base
  EMAIL_REGEXP = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  #Scopes
  scope :confirmed, -> { where.not(confirmed_at: nil)}
  
  #Validations
  validates_presence_of :email, :full_name, :location
  #validates_confirmation_of :password
  validates_length_of :bio, minimum: 30, allow_blank: false
  validates_format_of :email, with: EMAIL_REGEXP
  validates_uniqueness_of :email
  # validates_format_of :email, with: EMAIL_REGEXP
  
  #validate :email_format

  has_secure_password

  before_create do |user|
    user.confirmation_token = SecureRandom.urlsafe_base64
  end

  def confirm!
    return if confirmed?

    self.confirmed_at = Time.current
    self.confirmation_token = ''
    save!
  end

  def confirmed?
    confirmed_at.present?
  end

  def self.authenticate(email, password)
    confirmed.find_by(email: email).try(:authenticate, password)
  end

  private

  def email_format
    errors.add(:email, :invalid) unless email.match(EMAIL_REGEXP)
=begin
  Error messages
    • accepted: must be accepted (precisa ser aceito)
    • blank: can’t be blank (não pode ficar em branco)
    • confirmation: doesn’t match confirmation (não é igual a confirmação)
    • empty: can’t be empty (não pode ficar vazio)
    • equal_to: must be equal to %{count} (precisa ser igual a count)
    • exclusion: is reserved (é reservado)
    • greater_than: must be greater than %{count} (precisa ser maior que
count)
    • greater_than_or_equal_to: must be greater than or equal to %{count}
(maior ou igual que count)
    • inclusion: is not included in the list (não está na lista)
    • invalid: is invalid (é invalido)
    • less_than: must be less than %{count} (precisa ser menor que count)
    • less_than_or_equal_to: must be less than or equal to %{count} (menor
ou igual que count)
    • not_a_number: is not a number (não é um número)
=end
  end

  
end
