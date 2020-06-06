class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 255 }
  validates :username, presence: true, uniqueness: true, length: { maximum: 255 }
  has_many :posts
  has_many :followers, class_name: 'Follow', foreign_key: 'follow_id'
  has_many :following, class_name: 'Follow', foreign_key: 'user_id'
end
