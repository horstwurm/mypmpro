class Mdetail < ActiveRecord::Base
    
belongs_to :mobject
has_attached_file :document
validates_attachment :document, :content_type => { :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}

has_attached_file :avatar, default_url: "/images/:style/missing.png", :styles => {:medium => "250x250#", :small => "50x50#", :native => "640x480" }
validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

has_attached_file :video
validates_attachment :video, content_type: { content_type: ["video/mp4"] }
end
