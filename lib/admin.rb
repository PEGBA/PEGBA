require 'active_record'

class Admin < ActiveRecord::Base
  has_many :shirts
  has_many :purchases
end
