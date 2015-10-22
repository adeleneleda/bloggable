require 'rubygems'
require 'sinatra'
require 'ohm'
require 'ohm-zset'

require 'tilt/haml'

# Set port
set :port, 2352

# Load models
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each {|file| require file }


before do
  @user = User[params[:user_id]] || User[1]
end

get '/' do
  redirect '/1'
  # haml :index
end


get '/admin_list' do
  @admin_mode = true
  @posts = Post.all

  haml :admin
end

get '/admin_list/sort/:order' do
  @admin_mode = true
  @posts = Post.all

  order = params[:order] == "desc" ? "DESC" : "ASC"
  
  @posts = @posts.sort_by(:created_at, order: order)

  haml :admin
end


get '/:user_id' do
  @user = User[params[:user_id]]
  @posts = @user.posts

  haml :'users/show'
end

get '/:user_id/sort/:order' do
  @user = User[params[:user_id]]

  order = params[:order] == "desc" ? "DESC" : "ASC"

  @posts = @user.posts.sort_by(:created_at, order: order)

  puts @posts.map(&:title)
  
  haml :'users/show'
end

post '/posts' do
  title, content = params[:title], params[:content]
  user_id = params[:user_id]

  post = Post.create(title: title, 
                     content: content, 
                     user: User[user_id],
                     date_created: Time.now)



  if params[:image]
    dir = "public/uploads/#{ post.id }/images"
    FileUtils.mkdir_p(dir) unless File.exist?(dir)

    filename = "#{ dir }/" + params[:image][:filename]
    File.open("#{ filename }", "w+") do |f|
      f.write(params[:image][:tempfile].read)
    end


    @fullpath = File.expand_path(filename)

    post.update(image: "/" + filename.sub('public/', ''))
  end

  redirect "/posts/#{ post.id }"
end

get '/posts/new' do
  @user = User[1]

  haml :'posts/new'
end

get '/posts/:post_id' do
  @post = Post[params[:post_id]]

  haml :'posts/show'
end

get '/posts/:post_id/edit' do
  @post = Post[params[:post_id]]

  haml :'posts/edit'
end

post '/posts/:post_id' do
  title, content = params[:title], params[:content]
  
  @post = Post[params[:post_id]]

  @post.update(title: title, 
              content: content, 
              date_modified: Time.now)

  redirect "/posts/#{ @post.id }"
end

post '/posts/:post_id/comments' do
  post = Post[params[:post_id]]
  name, email_address = params[:name], params[:email_address]
  comment = params[:comment]

  Comment.create(post: post,
                 name: name, 
                 email_address: email_address, 
                 comment: comment,
                 date_created: Time.now)

  redirect "/posts/#{ post.id }"
end

helpers do
  def date_format(time_str)
    Time.parse(time_str).strftime('%B %d, %Y %I:%M %P')
  end

  def simple_pluralize(count, word)
    if count == 1
      "#{ count } #{ word }"
    else
      "#{ count } #{ word }s"
    end
  end
end



def initialize_database!
  User.create(name: 'Adelen', email_address: 'festinadelen@gmail.com') unless User[1]
end


initialize_database!