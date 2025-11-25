class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # esses daqui tem que ser excludentes
  has_one :administrator
  has_one :student
  has_one :professor
  has_one :contact_info

  accepts_nested_attributes_for :student
  accepts_nested_attributes_for :contact_info
  # Stackoverflow falou pra ter isso mas vai ficar comentado enquanto é só magia negra
  # attr_accessible :password, :password_confirmation

  validates :password, confirmation: true
  validates :name, presence: true, length: { minimum: 2, maximum: 800 }
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, message: 'Endereço de email inválido!'
  validates :email, inclusion: { in: %w[@usp.br] }, message: 'Por favor, use um email usp.'
end
