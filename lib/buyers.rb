require 'active_record'

class Buyer < ActiveRecord::Base
  has_many :purchases
  has_many :shirts
end
