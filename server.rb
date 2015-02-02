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

get ('/confirm') do
	erb :confirm
end

get ('/return') do
	erb :return
end

get ('/admin') do
	erb :admin
end
