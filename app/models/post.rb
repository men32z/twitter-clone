class Post < ApplicationRecord
  validates :user_id, presence: true
  validates :message, presence: true, length: { minimum: 1, maximum: 280 }
  belongs_to :user
  paginates_per 10
end
