class Follow < ApplicationRecord
  belongs_to :user
  belongs_to :follow, class_name: 'User'
  validates :follow_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :follow_id, message: 'Already following!' }
  validate :cant_follow_me

  def cant_follow_me
    errors.add(:user, "I can't follow me") if user_id == follow_id
  end
end
