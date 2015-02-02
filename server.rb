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

get("/cart/:id") do
  shirt = Shirt.find_by({id: params[:id]})
  erb :cart, locals: { shirt: shirt }
end

post('/addToCart/:id') do
  shirt = Shirt.find_by({id: params[:id]})
	buyer_hash = {
    name: params[:name],
    email: params[:email],
    quantity: params[:quantity],
    color: shirt.color,
    shirt_id: params[:id]
  }

  blah = Buyer.find_by({email: params[:email]})

  if blah == nil 
      buyer = Buyer.create(buyer_hash)
  else
      buyer = Buyer.find_by({email: params[:email]})
  end


  erb :continue, locals: { buyers: buyer }
end

get ('/checkout') do
	erb :return
end

get ('/admin') do
	erb :admin
end
