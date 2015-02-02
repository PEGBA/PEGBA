require 'active_record'

class Purchase < ActiveRecord::Base
  belongs_to :buyer
  belongs_to :shirt
end
