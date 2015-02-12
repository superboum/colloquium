require 'sinatra'
require 'haml'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
 

class Task
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String, :required => true
  property :completed_at, DateTime
  belongs_to :list
end

class List
  include DataMapper::Resource
  property :id,           Serial
  property :name,         String, :required => true
  has n, :tasks, :constraint => :destroy 
end
DataMapper.finalize


get '/' do
  @lists = List.all(:order => [:name])
  haml :index
end
      
get '/:task' do
  @task = params[:task].split('-').join(' ').capitalize
  haml :task
end


post '/:id' do
  List.get(params[:id]).tasks.create params['task']
  redirect to('/')
end

delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect to('/')
end

put '/task/:id' do
  task = Task.get params[:id]
  task.completed_at = task.completed_at.nil? ? Time.now : nil
  task.save
  redirect to('/')
end

post '/new/list' do
  List.create params['list']
  redirect to('/')
end
 
delete '/list/:id' do
  List.get(params[:id]).destroy
  redirect to('/')
end
