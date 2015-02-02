require 'active_record'

class Shirt < ActiveRecord::Base
  def buyers
    Buyer.where({shirt_id: self.id}) 
  end
end
