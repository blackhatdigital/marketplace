class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 	has_attached_file	:avatar, styles: { medium: "236x236#", thumb: "100x100#" }, default_url: "missing.png",
						:storage => :dropbox,
   						:dropbox_credentials => Rails.root.join("config/dropbox.yml")

   	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

 
  	devise	:database_authenticatable, :registerable,
        	:recoverable, :rememberable, :trackable, :validatable

	has_many :services
	has_many :sales, class_name: "Order", foreign_key: "seller_id"
	has_many :purchases, class_name: "Order", foreign_key: "buyer_id"
end
