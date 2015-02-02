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

  buyer = Buyer.find_by({email: params[:email]})
  if buyer == nil
    shirt = Shirt.find_by({id: params[:id]})
    buyer_hash = {
      name: params[:name],
      email: params[:email],
      quantity: params[:quantity],
      color: shirt.color,
      shirt_id: params[:id]
    }
    buyer = Buyer.create(buyer_hash)
  else
    shirt = Shirt.find_by({id: params[:id]})
    binding.pry
    buyer_hash = {
      name: buyer[:name],
      email: buyer[:email],
      quantity: params[:quantity],
      color: shirt.color,
      shirt_id: params[:id]
    }
    buyer.update(buyer_hash)
  end
  
  erb :continue, locals: { buyers: buyer }
end

get ('/checkout') do


  erb :return
end

get ('/admin') do
	erb :admin
end
