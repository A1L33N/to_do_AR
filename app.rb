require('sinatra')
require('sinatra/reloader')
require('./lib/task')
require('./lib/list')
also_reload('lib/**/*.rb')
require("pg")

DB = PG.connect({:dbname => "to_do"})

get("/") do
  @lists = List.all()
  erb(:index)
end

# posting a new list
post("/lists") do
  name = params.fetch("name")
  list = List.new({:name => name, :id => nil})
  list.save()
  erb(:list_success)
end
# list of all lists
get('/lists') do
  @lists = List.all()
  erb(:lists)
end
# posting the new task form and is displayed on the individual list page
post("/tasks") do
  description = params.fetch("description")
  list_id = params.fetch("list_id").to_i()
  list = List.find(list_id)
  task = Task.new({:description => description, :list_id => list_id})
  task.save()
  redirect("/lists/#{list.id()}")
end
# individual list page with all tasks
get('/lists/:id') do
  @list = List.find(params.fetch("id").to_i())
  erb(:list)
end
