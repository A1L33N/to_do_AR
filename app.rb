require('sinatra')
require('sinatra/reloader')
require('sinatra/activerecord')
require('./lib/task')
require('./lib/list')
also_reload('lib/**/*.rb')
require("pg")
require('pry')


get('/') do
  @lists = List.all
 erb(:index)
end


# posting a new list
post("/lists") do
  name = params.fetch("name")
  @list = List.new({:name => name, :id => nil})
  @list.save()
  erb(:list_success)
end
# list of all lists
get('/lists') do
  @lists = List.all()
  # list_id = params.fetch('list_id').to_i()
  # @list = List.find(list_id)
  erb(:lists)
end

get('/lists/:id') do
  @list = List.find(params.fetch('id').to_i)
  @tasks = Task.all
  erb(:lists)
end

post('/tasks') do
  description = params.fetch("description")
  list_id = params.fetch('list_id').to_i()
  @list = List.find(list_id)
  @task = Task.new({:description => description, :list_id => list_id})
  @task.save()
  @tasks = @list.tasks
  erb(:lists)
end

get('/tasks/:id/edit') do
  @task = Task.find(params.fetch("id").to_i())
  erb(:task_edit)
end

patch("/tasks/:id") do
  description = params.fetch("description")
  @task = Task.find(params.fetch("id").to_i())
  @task.update({:description => description})
  @tasks = Task.all()
  erb(:index)
end
