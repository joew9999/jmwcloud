class Image < ActiveRecord::Base
  has_attached_file :image, :styles => { :large => "300x300>", :medium => "200x200>", :thumb => "100x100>" }, :default_url => "/images/missing.png"
end