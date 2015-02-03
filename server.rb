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
  erb :index, locals: { shirts: Shirt.all() }
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

    # transaction_hash = {
    #   shirt_id: params[:id],
    #   buyer_id: ,
    # }
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

    # transaction_hash = {
    #   shirt_id: params[:id],
    #   buyer_id: ,
    # }
  end

  buyer = Buyer.create(buyer_hash)
  erb :continue, locals: { buyers: buyer }
end

get('/checkout/:id') do
  current_buyer = Buyer.find_by({id: params[:id]})

	erb :checkout, locals: { buyer: current_buyer }
end

put("/confirm/:id") do
  thank_buyer = Buyer.find_by({id: params[:id]})

  erb :thank, locals:{ buyer: thank_buyer }
end

get ('/admin') do

	erb :admin, locals:{ buyer: Buyer.all(), shirt: Shirt.all() }
end
