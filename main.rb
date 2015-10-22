require 'rubygems'
require 'sinatra'
require 'ohm'

require 'tilt/haml'

set :port, 2352

class Post < Ohm::Model
  attribute :title
  attribute :image
  attribute :content
  attribute :date_created
  attribute :date_modified

  reference :user, :Author
  collection :comments, :Comment

  index :title
end


class Comment < Ohm::Model
  attribute :name
  attribute :email_address
  attribute :comment

  reference :post, :Post
  reference :user, :User
end


class User < Ohm::Model
  attribute :name
  attribute :email_address
  attribute :description

  collection :posts, :Post
  collection :comments, :Comment
end



get '/' do

  redirect '/1'
  # haml :index

end


get '/:user_id' do
  @user = User[params[:user_id]]
  puts params
  haml :'users/show'
end

get '/posts/new' do
  puts 'fffff'*100
  haml :'posts/new'
end

get '/posts/:post_id' do
  haml :'posts/show'
end



post '/posts' do

end



def initialize_database!
  User.create(name: 'Adelen', email_address: 'festinadelen@gmail.com') unless User[1]
end


initialize_database!