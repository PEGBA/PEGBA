require 'active_record'

class Shirt < ActiveRecord::Base
  def buyers
    Buyer.where({shirtID: self.id}) 
  end
end
