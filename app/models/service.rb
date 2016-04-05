class Service < ActiveRecord::Base
	has_attached_file	:profile, styles: { medium: "236x236#", thumb: "100x100#" }, default_url: "missing.png",
						:storage => :dropbox,
   						:dropbox_credentials => Rails.root.join("config/dropbox.yml")
   						
	validates_attachment_content_type :profile, content_type: /\Aimage\/.*\Z/

	belongs_to :user
	has_many :orders
end
