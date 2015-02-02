require 'active_record'

class Shirt < ActiveRecord::Base
  has_many :purchases
  # def buyers
  #   Buyer.where({shirtID: self.id})
  # end
end
