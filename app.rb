require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/task")
require("pg")

DB = PG.connect({:dbname => "to_do"})

get('/') do
  erb(:index)
end

# for final part of sorting by timestamp, we figured out that we needed to use SELECT FROM to get our thingy back
