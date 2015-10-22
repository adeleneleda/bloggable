require 'ohm'

class Post < Ohm::Model

  attribute :title
  attribute :image
  attribute :content
  attribute :date_created
  attribute :date_modified

  reference :user, :User
  collection :comments, :Comment

  index :title
end
