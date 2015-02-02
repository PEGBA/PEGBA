require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/connection'
require_relative './lib/shirts'
require_relative './lib/buyers'
require 'pry'

after do
  ActiveRecord::Base.connection.close
end

get ('/') do
  erb :index, locals: { shirts: Shirt.all(),}
end

get("/confirm/:id") do
  shirt = Shirt.find_by({id: params[:id]})
  erb(:confirm, { locals: { shirt: shirt } })
end

post('/confirm/:id') do
	buyer_hash = {
    name: params["name"],
    email: params["email"],
    quantity: params["quantity"],
    color: params["color"],
    shirtID: params[:id]
  }

  new_buyer = Buyer.create(buyer_hash)

  erb(:return, { locals: { buyer: new_buyer } })

end

get ('/return') do
	erb :return
end

get ('/admin') do
	erb :admin
end
