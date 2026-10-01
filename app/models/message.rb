class Message < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 1000 }

  # Broadcast new messages to everyone on the "chat_room" stream
  after_create_commit { broadcast_append_to "chat_room" }
end