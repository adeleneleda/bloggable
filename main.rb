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

post '/posts' do
  title, content = params[:title], params[:content]
  user_id = params[:user_id]

  @post = Post.create(title: title, 
                      content: content, 
                      user: User[user_id],
                      date_created: Time.now)


  redirect "/posts/#{ @post.id }"
end

get '/posts/new' do
  @user = User[1]

  haml :'posts/new'
end

get '/posts/:post_id' do
  @post = Post[params[:post_id]]

  haml :'posts/show'
end

post '/posts/:post_id/comments' do
  post = Post[params[:post_id]]
  name, email_address = params[:name], params[:email_address]
  comment = params[:comment]

  Comment.create(post: post,
                 name: name, 
                 email_address: email_address, 
                 comment: comment)

  redirect "/posts/#{ post.id }"
end




def initialize_database!
  User.create(name: 'Adelen', email_address: 'festinadelen@gmail.com') unless User[1]
end


initialize_database!