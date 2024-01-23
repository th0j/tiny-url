class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :urls

  validates_uniqueness_of :email
  validates :email, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true
end
