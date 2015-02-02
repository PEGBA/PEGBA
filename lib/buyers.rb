require 'active_record'

class Buyer < ActiveRecord::Base
  def shirt
    Shirt.find_by({id: shirt_id}) #find_by returns 1
  end
end
