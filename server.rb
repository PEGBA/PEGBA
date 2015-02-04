require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/connection'
require_relative './lib/shirts'
require_relative './lib/buyers'
require_relative './lib/purchases'
require_relative './lib/admin'
require 'pry'
require 'bcrypt'

use Rack::Session::Pool, :cookie_only => false

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
  erb :checkout, locals: { buyer: buyer, shirt: shirt.quantity }
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

put ('/confirm_update/:id') do
  update_quantity = params[:quantity]
  thank_buyer = Buyer.find_by({id: params[:id]})

  transaction_hash = {
    shirt_id: thank_buyer[:shirt_id],
    buyer_id: thank_buyer[:id],
    quantity: update_quantity
  }

  transaction = Purchase.create(transaction_hash)

  shirt = Shirt.find_by({id: thank_buyer[:shirt_id]})
  shirt_hash = {
    color: shirt[:color],
    quantity: shirt[:quantity] - update_quantity.to_i,
    img_url: shirt[:img_url],
    price: shirt[:price]
  }

  shirt.update(shirt_hash)

  redirect("/confirmed/#{thank_buyer.id}")
end

get ("/confirmed/:id") do
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



get ('/login') do
  erb :adminLogin
end

get ('/admin') do
  erb :access
end

post ('/admin') do
  admin = Admin.find_by({username: "admin"})
  admin_password = BCrypt::Password.new(admin[:password])
  username = params[:username]
  password = params[:password]

  if admin[:username] == username && admin_password == password
    session[:valid_user] = true
    erb :admin, locals:{ buyer: Buyer.all(), shirt: Shirt.all() }
  else
    erb :broken
  end

end

put('/admin/:id') do
  shirt = Shirt.find_by({id: params[:id].to_i})
  shirt_amount = params[:quantity].to_i

  total_shirts = {
    quantity: shirt[:quantity] + shirt_amount,
  }

  shirt.update(total_shirts)
  puts total_shirts

  redirect('/admin')
end

get('/admin/login') do
  redirect('/login')
end

post('/admin/logout') do
  session[:valid_user] = false

  redirect('/login')
end
