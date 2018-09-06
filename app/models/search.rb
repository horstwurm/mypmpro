class Search < ActiveRecord::Base
    
    serialize :sql_string, Array
    
    validates :name, presence: true
    validate :upper?

    belongs_to :user

    #before_validation :update_geo_address
      
    #geocoded_by :geo_address
    #after_validation :geocode

    def update_geo_address
      self.geo_address = self.address1 + " " + address2 + " " + address3
    end

    def upper?
        if self.keywords
            self.keywords = self.keywords.upcase
        end
        return true
    end

    def build_sql(user)
        sql_string = []
        sql_string[0] ="active=?"
        sql_string << true
        case self.search_domain
        when "personen"
            sql_string[0] = sql_string[0] + " and anonymous=?"
            sql_string << false
            if self.org != ""
                sql_string[0] = sql_string[0] + " and org=?"
                sql_string << self.org
            end
            if self.costinfo != ""
                sql_string[0] = sql_string[0] + " and costinfo=?"
                sql_string << self.costinfo
            end
            sql_string = find_keywords(sql_string, self.search_domain, self.keywords)
            self.counter = User.where(sql_string).count
            self.sql_string = sql_string

        when "institutionen"
            if self.mcategory_id != "" and self.mcategory_id != nil and self.mcategory_id.to_s.length != 0
                sql_string[0] = sql_string[0] + " and mcategory_id=?"
                sql_string << self.mcategory_id
            end
            sql_string = find_keywords(sql_string, self.search_domain, self.keywords)
            self.counter = Company.where(sql_string).count
            self.sql_string = sql_string

        when "objekte"
            if self.freecat1 != ""
                sql_string[0] = sql_string[0] + " and freecat1=?"
                sql_string << self.freecat1
            end
            if self.freecat2 != ""
                sql_string[0] = sql_string[0] + " and freecat2=?"
                sql_string << self.freecat2
            end
            if self.freecat3 != ""
                sql_string[0] = sql_string[0] + " and freecat3=?"
                sql_string << self.freecat3
            end
            sql_string[0] = sql_string[0] + " and (online_pub=? or id IN (?))"
            sql_string << true
            mlist = []
            if user
                user.madvisors.where('role=?',"projekte").each do |a|
                    mlist << a.mobject_id
                end
                user.mobjects.each do |m|
                    if !mlist.include?(m.id)
                        mlist << m.id
                    end
                end
                user.companies.each do |c|
                    c.mobjects.each do |m|
                        if !mlist.include?(m.id)
                            mlist << m.id
                        end
                    end
                end
            end
            sql_string << mlist

            case self.mtype
                when "projekte"
                    if self.mcategory_id != "" and self.mcategory_id != nil and self.mcategory_id.to_s.length != 0
                        sql_string[0] = sql_string[0] + " and mcategory_id=?"
                        sql_string << self.mcategory_id
                    end

            end
            sql_string[0] = sql_string[0] + " and mtype=?"
            sql_string << self.mtype
            sql_string = find_keywords(sql_string, self.search_domain, self.keywords)
            self.counter = Mobject.where(sql_string).count
            self.sql_string = sql_string
            
        end
    end
end

def find_keywords(sql_string, domain, keywords)
if keywords != nil and keywords != ""
    sql_string[0] = sql_string[0] + " and ("
    case domain
        when "personen"
            sql_string[0] = sql_string[0] + like_token("lastname",keywords)
            keywords.split.each do |t| 
                sql_string << "%"+t+"%"
            end
            sql_string[0] = sql_string[0] + " OR "
            sql_string[0] = sql_string[0] + like_token("name",keywords)
            keywords.split.each do |t| 
                sql_string << "%"+t+"%"
            end
        when "objekte"
            sql_string[0] = sql_string[0] + like_token("name",keywords)
            keywords.split.each do |t| 
                sql_string << "%"+t+"%"
            end
            sql_string[0] = sql_string[0] + " OR "
            sql_string[0] = sql_string[0] + like_token("description",keywords)
            keywords.split.each do |t| 
                sql_string << "%"+t+"%"
            end
        #     sql_string[0] = sql_string[0] + " OR "
        #     sql_string[0] = sql_string[0] + like_token("stichworte",keywords)
        #     keywords.split.each do |t| 
        #         sql_string << "%"+t+"%"
        #     end
          when "institutionen"
            sql_string[0] = sql_string[0] + like_token("name",keywords)
            keywords.split.each do |t| 
                sql_string << "%"+t+"%"
            end
            # sql_string[0] = sql_string[0] + " OR "
            # sql_string[0] = sql_string[0] + like_token("stichworte",keywords)
            # keywords.split.each do |t| 
            #     sql_string << "%"+t+"%"
            # end
        else
            sql_string[0] = sql_string[0] + like_token("name",keywords)
            keywords.split.each do |t| 
                sql_string << "%"+t+"%"
            end
            sql_string[0] = sql_string[0] + " OR "
            sql_string[0] = sql_string[0] + like_token("description",keywords)
            keywords.split.each do |t| 
                sql_string << "%"+t+"%"
            end
    end
    sql_string[0] = sql_string[0] + ") "
end
return sql_string
end

def like_token(field, string)
    return_string = ""
    array = string.split
    if array.size > 0
        for i in 0..array.size-1
            return_string = return_string + "upper(" + field + ") LIKE ?"
            if i<array.size-1
                return_string = return_string + " OR "
            end
        end
    end
    return return_string
end