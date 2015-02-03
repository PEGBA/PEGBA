require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/connection'
require_relative './lib/shirts'
require_relative './lib/buyers'
require_relative './lib/purchases'
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
  shirt = Shirt.find_by({id: params[:id]})
  buyer_hash = {
    name: params[:name],
    email: params[:email],
    quantity: params[:quantity],
    color: shirt.color,
    shirt_id: params[:id]
    }

  buyer = Buyer.create(buyer_hash)
  erb :checkout, locals: { buyer: buyer }
end

put("/confirm/:id") do

  thank_buyer = Buyer.find_by({id: params[:id]})

  transaction_hash = {
    shirt_id: thank_buyer[:shirt_id],
    buyer_id: thank_buyer[:id],
    quantity: thank_buyer[:quantity]
  }

  transaction = Purchase.create(transaction_hash)

  shirt = Shirt.find_by({id: thank_buyer[:shirt_id]})
  shirt_hash = {
    color: shirt[:color],
    quantity: shirt[:quantity] - thank_buyer[:quantity],
    img_url: shirt[:img_url],
    price: shirt[:price]
  }

  shirt.update(shirt_hash)

  erb :thank, locals:{ buyer: thank_buyer, purchase: transaction }
end

get ('/admin') do

	erb :admin, locals:{ buyer: Buyer.all(), shirt: Shirt.all() }
end
