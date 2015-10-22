require 'ohm'

class Comment < Ohm::Model
  attribute :name
  attribute :email_address
  attribute :comment
  attribute :date_created

  reference :post, :Post
  reference :user, :User
end