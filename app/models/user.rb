class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, authentication_keys: [:login]

  validates :nusp, presence: true, uniqueness: true
  validates :email, uniqueness: true, allow_nil: true

  # esses daqui tem que ser excludentes
  has_one :administrator
  has_one :student
  has_one :professor
  has_one :contact_info

  accepts_nested_attributes_for :student
  accepts_nested_attributes_for :professor
  accepts_nested_attributes_for :administrator
  accepts_nested_attributes_for :contact_info
  # Stackoverflow falou pra ter isso mas vai ficar comentado enquanto é só magia negra
  # attr_accessible :password, :password_confirmation

  validates :password, confirmation: true
  validates :name, presence: true, length: { minimum: 2, maximum: 800 }, if: :first_login?
  validates :email, uniqueness: { case_sensitive: false }, if: :first_login?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Endereço de email inválido!' },
                    if: :first_login?
  validates :email, format: { with: /\A[\w+\-.]+@(?:[\w-]+\.)?usp\.br\z/i, message: 'Por favor, use um email usp.' },
                    if: :first_login?
  def full_name
    "#{name} #{surname}"
  end

  def administrator?
    administrator.present?
  end

  def professor?
    professor.present?
  end

  def student?
    student.present?
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)

    where(conditions).where(
      ['nusp = :value OR email = :value', { value: login }]
    ).first
  end
end
