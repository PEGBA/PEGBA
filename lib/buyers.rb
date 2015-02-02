require 'active_record'

class Buyer < ActiveRecord::Base
  def shirt
    Shirt.find_by({id: shirtID}) #find_by returns 1
  end
end


class Buyer
	belongs_to :shirts
end