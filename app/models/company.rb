class Company < ActiveRecord::Base
    
    before_validation :update_geo_address
      
    geocoded_by :geo_address
    after_validation :geocode

    has_many :company_params, dependent: :destroy 
    has_many :iots, as: :owner, dependent: :destroy 
    has_many :deputies, as: :owner, dependent: :destroy 
    has_many :charges, as: :owner, dependent: :destroy 
    has_many :mobjects, as: :owner, dependent: :destroy 
    has_many :mstats, as: :owner, dependent: :destroy 
    has_many :customers, as: :owner, dependent: :destroy 
    has_many :transactions, as: :owner, dependent: :destroy 

    has_many :partner_links, dependent: :destroy 
    has_many :msponsors, dependent: :destroy 
    belongs_to :user
    belongs_to :mcategory
    
    validates :name, presence: true
    validates :user_id, presence: true
    
    has_attached_file :avatar, default_url: "/images/:style/missing.png", :styles => {:medium => "250x250#", :small => "50x50#" }
    validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

      def update_geo_address
        self.geo_address = self.address1 + " " + address2 + " " + address3
      end
      
      def self.search(filter, search)
        if filter
            @search = Search.find(filter)
            where(@search.build_sql(nil))
        else
          if search
              where('status=? and active=? and (stichworte LIKE ? OR name LIKE ?)', "OK", true, "%#{search}%", "%#{search}%")
            else
                where('status=? and active=?', "OK", true)
          end
        end
      end

    def build_stats(array_s, records, label)
      if records != nil
        anz = records.count
        if anz > 0
          array_s = array_s + "['" + label + "'," + anz.to_s + "],"
          return array_s
        end
      end
      return array_s
    end
      
end
