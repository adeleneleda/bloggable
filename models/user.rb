require 'ohm'

class User < Ohm::Model

  attribute :name
  attribute :email_address
  attribute :description

  collection :posts, :Post
  collection :comments, :Comment
end
