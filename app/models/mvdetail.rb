class Mvdetail < ApplicationRecord
    belongs_to :mobject
    
has_attached_file :video
end
