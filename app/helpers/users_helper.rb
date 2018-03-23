module UsersHelper

def qrcodeimg(mobject, size)

  mtype = mobject.class.table_name
  mid = mobject.id
  
  content = "https://mytgcloud.herokuapp.com"+url_for(mobject)

  @qr = Qrcode.where('mobject_type=? and mobject_id=?', mobject.class.table_name, mobject.id).first

  if !@qr
    qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
    qr_img = qr.to_img
    qr_img.resize(200, 200).save("app_qrcode.png")
    @qr = Qrcode.new
    @qr.mobject_type= mtype
    @qr.mobject_id = mid
    @qr.avatar = File.open("app_qrcode.png")
    @qr.save
  end

  hash = Hash.new
  hash = {"qr_text" => content, "qr_code" => image_tag(@qr.avatar(:small)) }
  return hash

end

def small_carousel(company, size)

    html = ""
    html = html +  '<div class="owl-show2">'
    mobjects = company.mobjects
    mobjects.where('mtype!=? and mtype!=?',"kampagnen", "standorte").each do |m|

      #m.mdetails.each do |s|
        #if s.avatar_file_name
          html = html + "<div align=center>"+ (showFirstImage2(:medium, m, m.mdetails)) + "<h4>" + m.mtype + ": " + m.name + "</h4><p>" + "</p></div>"
        #end
        
      #end
      
      m.mratings.last(1).each do |r|
        if r.user.avatar_file_name
          html = html + "<div align=center>"+ (showImage2(:medium, r.user, true)) + "<h4>" + r.comment + "</h4><p>" + r.user.name + " " + r.user.lastname + "</p></div>"
        end
      end
    end
    
    html = html +  "</div>"
    return html.html_safe
end

def carousel(signages, size, text)
    html = ""
    html = html +  '<div class="owl-show">'
    signages.each do |s|
      if s.avatar_file_name == nil
        html = html + "<div>" + image_tag(image_def("Signage", "", ""), :size => size, class:"card-img-top img-responsive" ) + "</div>"
      else
        html = html + "<div align=center>"+ (image_tag s.avatar(:native), class:"img-rounded img-rounded") + "<h2>" + s.name + "</h2>" + s.description + "</div>"
      end
    end
    html = html +  "</div>"
    return html.html_safe
end

def carousel2(mobject, size)
    html = ""
    if mobject.mdetails == nil
      html = html + image_tag(mobject.mtype + ".png", :size => size, class:"card-img-top img-responsive" )
    else
      if mobject.mdetails.count == 0
        html = html + image_tag(mobject.mtype + ".png", :size => size, class:"card-img-top img-responsive" )
      else
        html = html +  '<div class="owl-show">'
        mobject.mdetails.each do |p|
          
          html = html + "<div class='row'>"

            html = html + "<div class='col-xs=12'>"
              if p.avatar_file_name == nil
                html = html + "<div>" + image_tag(image_def("objekte", mobject.mtype, mobject.msubtype), :size => size, class:"card-img-top img-responsive" ) + "</div>"
              else
                html = html + "<div>"+ (image_tag p.avatar(size), class:"img-rounded") + "</div>"
              end
            html = html + "</div>"
              
            html = html + "<div class='col-xs=12 mdetailalign'>"
              if p.name 
                html = html + "<b>"+p.name + "</b><br>"
              end
              if p.description
                html = html + p.description + "<br>"
              end
            html = html + "</div>"

            html = html + "<div class='col-xs=12'>"
              if p.document_file_name
                html = html + link_to(p.document.url, target: "_blank") do 
                  content_tag(:i, nil, class:"btn btn-primary fa fa-cloud-download")
                end
              end
            html = html + "</div>"

          html = html + "</div>"
              
        end
        html = html +  "</div>"
      end
    end
    return html.html_safe
end

def sigcar(mobject)
    html = ""
    if mobject.signages == nil
    else
      if mobject.signages.count == 0
      else
        html = html +  '<div class="owl-show">'
        mobject.signages.each do |p|
          if p.avatar_file_name == nil
          else
            html = html + "<div>"+ (image_tag p.avatar(:medium), class:"img-rounded") + "</div>"
          end
        end
        html = html +  "</div>"
      end
    end
    return html.html_safe
end

def align_text(txt)
    len = 30
    if txt == nil
        text = ""
    else
        if txt.length >= len
          text = txt[0,len]
        else
          text = txt
        end
    end
    return text + "..."
end


def build_medialistNew(items, cname, par)

  priceAnz = 0
  sensorAnz = 0

  html_string = ""
  html_string = html_string + '<div class="container">'
    html_string = html_string + '<div class="row">'
      html_string = html_string + '<div class="col-md-12 text-center">'
        html_string = html_string + '<h2 class="service-title pad-bt15">übersicht</h2>'
        #html_string = html_string + '<p class="sub-title pad-bt15">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod<br>tempor incididunt ut labore et dolore magna aliqua.</p>'
        html_string = html_string + '<hr class="bottom-line">'
      html_string = html_string + '</div>'

  items.each do |item|
    
    show = true
    if cname == "nopartners"
      if par[:user_id]
        @customer = Customer.where('owner_type=? and owner_id=? and partner_id=?', "User", par[:user_id], item.id).first
      end
      if par[:company_id]
        @customer = Customer.where('owner_type=? and owner_id=? and partner_id=?', "Company", par[:company_id], item.id).first
      end
      if @customer
        show = false
      end
    end
    
    if item and show
      
        html_string = html_string + '<div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 col-xs-12">'
          html_string = html_string + '<div class="blog-sec">'
          
            #**************************************************************************************************************
            #IMAGE BLOCK
            #**************************************************************************************************************
            html_string = html_string + '<div class="blog-img">'
            case items.table_name
              when "questions"
                  html_string = html_string + image_tag("fragen.jpg", :size => "250x250")
              when "deputies"
                  html_string = html_string + showImage2(:medium, User.find(item.userid), true)
               when "appparams"
                  html_string = html_string + image_tag(item.right+".png", :size => "250x250")
              when "prices"
                  html_string = html_string + showImage2(:medium, item, false)
              when "crits"
                  html_string = html_string + image_tag("kriterien.png", :size => "250x250")
                  html_string = html_string + "<br><br>"
                  if !par
                    html_string = html_string + "<idea_rating>" + item.rating.to_s + "</idea_rating>" 
                  end
              when "ideas"
                if par == "user"
                  if item.avatar_file_name
                    html_string = html_string + showImage2(:medium, item, true)
                  else
                    html_string = html_string + showImage2(:medium, item.user, true)
                  end
                end
                if par == "idee"
                  if item.avatar_file_name
                    html_string = html_string + showImage2(:medium, item, true)
                  else
                    html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                  end
                end
              when "edition_arcticles"
                html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
              when "editions"
                html_string = html_string + showImage2(:medium, item, true)
              when "tickets"
                html_string = html_string + showFirstImage2(:medium, item, item.owner.mdetails)
              when "signage_camps"
                html_string = html_string + showFirstImage2(:medium, item, item.signages)
              when "comments", "idea_crowdratings"
                html_string = html_string + showImage2(:medium, item.user, true)
              when "users", "companies", "signages", "signage_locs", "articles"
                html_string = html_string + showImage2(:medium, item, true)
              when "mdetails"
                html_string = html_string + showImage2(:medium, item, false)
              when "msponsors"
                if par == "company"
                  html_string = html_string + showImage2(:medium, item.company, true)
                end
                if par == "objekte"
                  html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                end
              when "mobjects"
                html_string = html_string + showFirstImage2(:medium, item, item.mdetails)
              when "mstats"
                if par == "cf"
                  html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                end
                if par == "owner"
                  html_string = html_string + showImage2(:medium, item.owner, true)
                end
              when "madvisors", "mratings"
                if par == "objekte"
                  html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                end
                if par == "user"
                  html_string = html_string + showImage2(:medium, item.user, true)
                end
              when "favourits"
                @item = Object.const_get(item.object_name).find(item.object_id)
                if @item
                  html_string = html_string + showImage2(:medium, @item, true)
                end
              when "customers"
                  if @comp
                    html_string = html_string + showImage2(:medium, @comp, true)
                  end
              when "searches"
                  if par != nil and par != ""
                    html_string = html_string + link_to(showcal_index_path(:filter_id => item.id, :dom => par)) do
                      content_tag(:i, nil, class:"fa fa-" + getinfo(item.mtype.to_sym)["info"], style:"font-size:8em") 
                    end
                  else
                    html_string = html_string + "<soft_padding>"
                    case item.search_domain
                      when "personen"
                        html_string = html_string + link_to(users_path(:filter_id => item.id)) do
                          #content_tag(:i, nil, class:"fa fa-question-sign", style:"font-size:8em") 
                          image_tag("abfragen.jpg", :size => :medium)
                        end
                      when "objekte"
                        html_string = html_string + link_to(mobjects_path(:filter_id => item.id)) do
                          #content_tag(:i, nil, class:"fa fa-question-sign", style:"font-size:8em") 
                          image_tag("abfragen.jpg", :size => :medium)
                        end
                      when "tickets"
                          content_tag(:i, nil, class:"fa fa-question-sign", style:"font-size:8em") 
                          html_string = html_string + image_tag(image_def("personen", item.mtype, item.msubtype))
                      when "institutionen"
                        html_string = html_string + link_to(companies_path(:filter_id => item.id)) do
                          #content_tag(:i, nil, class:"fa fa-question-sign", style:"font-size:8em") 
                          image_tag("abfragen.jpg", :size => :medium)
                        end
                    end
                    html_string = html_string + "</soft_padding>"
                  end
              when "transactions"
                html_string = html_string + showImage2(:medium, @ac_ver.customer.owner, true)
              when "partner_links"
                html_string = html_string + showImage2(:medium, item, false)
            end
          html_string = html_string + '</div>'

          html_string = html_string + '<div class="blog-info">'
            #**************************************************************************************************************
            #IMAGE NAME
            #**************************************************************************************************************
          html_string = html_string + '<h4>'
            case items.table_name
              when "deputies"
                html_string = html_string + User.find(item.userid).name + " " + User.find(item.userid).lastname
              when "appparams"
                html_string = html_string + (I18n.t item.right.to_sym)
              when "charges"
                html_string = html_string + (I18n.t item.appparam.right.to_sym)
              when "prices"
                html_string = html_string + item.sequence.to_s + (I18n.t :nterpreis)
              when "crits"
                html_string = html_string + item.name
              when "ideas"
                priceAnz = priceAnz + 1
                if priceAnz <= item.mobject.prices.count
                  html_string = html_string + '<fire><i class="fa fa-fire"></fire></i> '
                end
                html_string = html_string + item.header
              when "questions"
                html_string = html_string + item.name
              when "edition_arcticles"
                html_string = html_string + item.mobject.name
              when "editions"
                html_string = html_string + item.name
              when "comments", "idea_crowdratings"
                html_string = html_string + item.user.name + " " + item.user.lastname + " am " + item.created_at.strftime("%d.%m.%Y um %k:%M Uhr")
              when "tickets"
                html_string = html_string + " " + item.name.to_s
              when "users"
                html_string = html_string + item.name + " " + item.lastname
              when "companies", "mdetails"
                html_string = html_string + item.name
              when "mobjects"
                if item.online_pub
                  html_string = html_string + '<i class="fa fa-road"></i>'
                else
                  html_string = html_string + '<i class="fa fa-lock"></i>'
                end
                html_string = html_string + " " + item.name
              when "searches"
                html_string = html_string + item.name
              when "customers"
                @comp = Company.find(item.partner_id)
                html_string = html_string + @comp.name
              when "madvisors", "mratings"
                if par == "user"
                  html_string = html_string + item.user.name + " " + item.user.lastname
                end
                if par == "objekte"
                  html_string = html_string + item.mobject.name
                end
              when "msponsors"
                if par == "company"
                  html_string = html_string + item.company.name
                end
                if par == "objekte"
                  html_string = html_string + item.mobject.name
                end
              when "favourits"
                @item = Object.const_get(item.object_name).find(item.object_id)
                if Object.const_get(item.object_name).to_s == "User"
                    html_string = html_string + @item.name + " " + @item.lastname 
                end
                if Object.const_get(item.object_name).to_s == "Company"
                    html_string = html_string + @item.name 
                end
              when "partner_links"
                if item.name
                    html_string = html_string + item.name + "<br>"
                end
                if item.link
                    html_string = html_string + item.link 
                end
              when "transactions"
                @ac_ver = Account.find(item.account_ver)
                @customer = @ac_ver.customer
                if @ac_ver.customer.owner_type == "User"
                    html_string = html_string + @customer.owner.name + " " + @customer.owner.lastname 
                end
                if @ac_ver.customer.owner_type == "Company"
                    html_string = html_string + @customer.owner.name 
                end
              when "mstats"
                if par == "cf"
                      html_string = html_string + item.mobject.name 
                end
                if par == "owner"
                  if item.owner_type == "User"
                      html_string = html_string + item.owner.name + " " + item.owner.lastname 
                  end
                  if item.owner_type == "Company"
                      html_string = html_string + item.owner.name 
                  end
                end
            end
          html_string = html_string + '</h3>'

            #**************************************************************************************************************
            #DETAILS BLOCK
            #**************************************************************************************************************
          html_string = html_string + '<div class="blog-comment">'
          case items.table_name
              when "appparams"
                html_string = html_string + "<trans>"

                html_string = html_string + '<i class="fa fa-pencil"></i>'+ (I18n.t :abo) + '<br><br>'

                if user_signed_in?
                  if par == "user"
                    @charges = item.charges.where('owner_id=? and owner_type=?', current_user.id, "User").order(created_at: :desc)
                  else
                    @charges = item.charges.where('owner_id=? and owner_type=?', current_user.id, "Company").order(created_at: :desc)
                  end
                  startdatum = Date.today
                  @charges.each do |c|
  
                    html_string = html_string + '<i class="fa fa-calendar"></i> '
                    html_string = html_string + c.date_from.strftime("%d-%m-%Y") + "-" + c.date_to.strftime("%d-%m-%Y")
                    
                    if c.date_to > startdatum
                      startdatum = c.date_to
                    end
                    if c.date_to < Date.today
                      proc = 0
                    end  
                    if c.date_from > Date.today
                      proc = 100
                    end
                    if c.date_from <= Date.today and c.date_to >= Date.today
                      days = c.date_to - c.date_from
                      days_used = c.date_to - Date.today
                      proc = (days_used/days*100).to_i
                    end
                    if proc > 0
                      if proc >= 30
                        progresscolor = "success"
                      end
                      if proc > 10 and proc < 30
                        progresscolor = "warning"
                      end
                      if proc <= 10 
                        progresscolor = "danger"
                      end
                      html_string = html_string + '<div class="progress">'
                      html_string = html_string + '<div class="progress-bar progress-bar-' + progresscolor + ' progress-bar-striped" role="progressbar2" aria-valuenow="' + proc.to_s + '" aria-valuemin="0" aria-valuemax="100" style="width:' + proc.to_s + '%">'
                      html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                      html_string = html_string + '</div>'
                      html_string = html_string + '</div>'
                    end
                  end
                
                  if item.fee
                    html_string = html_string + link_to(new_charge_path(:user_id => current_user.id, :appparam_id => item.id, :datum => startdatum, :plan => "monthly")) do
                      content_tag(:i, content_tag(:div,sprintf("%05.2f CHF/m",item.fee/100)), class:"btn btn-submit")
                    end
                    #html_string = html_string + " " + sprintf("%05.2f CHF/Monat",item.fee/100) 
                    #html_string = html_string + "<br><br>"
                    html_string = html_string + link_to(new_charge_path(:user_id => current_user.id, :appparam_id => item.id, :datum => startdatum, :plan => "yearly")) do
                      content_tag(:i, content_tag(:div,sprintf("%05.2f CHF/y",item.fee/10)), class:"btn btn-submit")
                    end
                    #html_string = html_string + " " + sprintf("%05.2f CHF/y",item.fee/10) 
                  end
                else
                      html_string = html_string + content_tag(:i, content_tag(:div,sprintf("%05.2f CHF/m",item.fee/100)), class:"btn btn-submit")
                      html_string = html_string + content_tag(:i, content_tag(:div,sprintf("%05.2f CHF/y",item.fee/10)), class:"btn btn-submit")
                end
                html_string = html_string + "</trans>"

              when "deputies"
                html_string = html_string + '<i class="fa fa-calendar"></i> '
                if item.date_from and item.date_to
                  html_string = html_string + item.date_from.strftime("%d-%m-%Y") + "-" + item.date_to.strftime("%d-%m-%Y")
                else
                  html_string = html_string + (I18n.t :unlimited)
                end

              when "charges"
                html_string = html_string + '<i class="fa fa-pencil"></i> '
                html_string = html_string + item.plan + "<br>"
                html_string = html_string + '<i class="fa fa-calendar"></i> '
                html_string = html_string + item.created_at.strftime("%d-%m-%Y") + "-"
                if item.plan == "yearly"
                  offset = 365
                else
                  offset = 30
                end
                html_string = html_string + (item.created_at.to_date + offset).strftime("%d-%m-%Y") + "<br>"
                html_string = html_string + '<i class="fa fa-euro"></i> '
                html_string = html_string + sprintf("%05.2f CHF",item.amount)  + "<br>"
                proc = (item.created_at.to_date.jd+offset - Date.today.jd)*100/offset
                html_string = html_string + proc.to_s  + "%<br>"
                if proc > 0
                  if proc >= 30
                    progresscolor = "success"
                  end
                  if proc > 10 and proc < 30
                    progresscolor = "warning"
                  end
                  if proc <= 10 
                    progresscolor = "danger"
                  end
                  html_string = html_string + '<div class="progress">'
                  html_string = html_string + '<div class="progress-bar progress-bar-' + progresscolor + ' progress-bar-striped" role="progressbar2" aria-valuenow="' + proc.to_s + '" aria-valuemin="0" aria-valuemax="100" style="width:' + proc.to_s + '%">'
                  html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                  html_string = html_string + '</div>'
                  html_string = html_string + '</div>'
                end

              when "idea_crowdratings"
                if item.rating and item.rating > 0
                  item.rating.round.times do
                    html_string = html_string + '<i class="fa fa-star"></i> '
                  end
                  html_string = html_string + ' (' + sprintf("%.1f",item.rating) + ')<br>'
                end
                html_string = html_string + '<i class="fa fa-pencil"></i> '
                html_string = html_string + "<b>" + item.rating_text + "</b><br>"

              when "prices"
                html_string = html_string + '<preis><i class="fa fa-gift"></i> '
                html_string = html_string +  item.name + "</preis><br><br>"
                #html_string = html_string + '<i class="fa fa-pencil"></i>
                if item.description.length > 300
                  html_string = html_string + "<b>" + item.description[0..300] + "</b><br>"
                else
                  html_string = html_string + "<b>" + item.description + "</b><br>"
                end

              when "crits"
                if item.rating and item.rating > 0
                  html_string = html_string + '<div class="progress">'
                  html_string = html_string + '<div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar2" aria-valuenow="' + item.rating.to_s + '" aria-valuemin="0" aria-valuemax="100" style="width:' + item.rating.to_s + '%">'
                  html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                  html_string = html_string + '</div>'
                  html_string = html_string + '</div>'
                end
                if par #Idea_id
                  @idearating = IdeaRating.where('user_id=? and idea_id=? and crit_id=?', current_user.id, par, item.id).first
                  if !@idearating
                    @idearating = IdeaRating.new
                    @idearating.idea_id = par
                    @idearating.crit_id = item.id
                    @idearating.user_id = current_user.id
                    @idearating.rating = 0
                    @idearating.rating_text = "..."
                    @idearating.save
                  end
                  if @idearating and @idearating.rating > 0
                    #html_string = html_string + '<i class="fa fa-pencil"></i> '
                    html_string = html_string + '<div class="progress">'
                    html_string = html_string + '<div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar2" aria-valuenow="' + @idearating.rating.to_s + '" aria-valuemin="0" aria-valuemax="100" style="width:' + @idearating.rating.to_s + '%">'
                    html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                    html_string = html_string + '</div>'
                    html_string = html_string + '</div>'
                  end
                  html_string = html_string + "<idea_rating>" + (item.rating * @idearating.rating).to_s + "</idea_rating>"
                end
                #html_string = html_string + '<i class="fa fa-pencil"></i> '
                html_string = html_string + "<br><b>" + item.description + "</b><br>"

              when "ideas"
                if item.crowdrating and item.crowdrating > 0
                  html_string = html_string + '<i class="fa fa-certificate"></i> '
                  html_string = html_string + "<idea_rating>" 
                  item.crowdrating.round.times do
                    html_string = html_string + '<i class="fa fa-certificate"></i> '
                  end
                  html_string = html_string + "</idea_rating>" 
                  html_string = html_string + sprintf("(%3.1f)",item.crowdrating) + "<br>" 
                end
                if item.rating
                  #html_string = html_string + '<i class="fa fa-certificate"></i> '
                  html_string = html_string + "<idea_rating>" + sprintf("%3.1f",item.rating) + "</idea_rating><br>" 
                end
                
                html_string = html_string + '<i class="fa fa-user"></i> '
                html_string = html_string + item.user.name + " " + item.user.lastname + "<br><br>"
                if item.description.length > 200
                  html_string = html_string + "<b>" + item.description[0..200] + "...</b><br>"
                else
                  html_string = html_string + "<b>" + item.description + "</b><br>"
                end
                # html_string = html_string + showImage2(:small, item, false)
                if false
                  if item.avatar_file_name
                    #html_string = html_string + "Weitere Informationen: "
                    html_string = html_string + link_to(item.avatar.url, target: "_blank") do 
                      content_tag(:i, nil, class:"btn btn-primary fa fa-picture")
                    end
                  end
                  if item.document_file_name
                    #html_string = html_string + "Weitere Informationen: "
                    html_string = html_string + link_to(item.document.url, target: "_blank") do 
                      content_tag(:i, nil, class:"btn btn-primary fa fa-book")
                    end
                  end
                end

              when "edition_arcticles"
                html_string = html_string + '<i class="fa fa-pencil"></i> '
                html_string = html_string + item.mobject.owner.name + " " + item.mobject.owner.lastname

              when "editions"
                html_string = html_string + '<i class="fa fa-calendar"></i> '
                if item.release_date 
                  html_string = html_string +  item.release_date.strftime("%d.%m.%Y") + '<br><br>'
                end 
                html_string = html_string + " <fire>" + item.edition_arcticles.count.to_s + " " + (I18n.t :artikel)
                html_string = html_string + '</fire><br><br>'

                #html_string = html_string + '<i class="fa fa-pencil"></i> '
                #html_string = html_string + item.description + "<br><br>"
                item.edition_arcticles.order(:sequence).last(5).each do |ea|
                  #html_string = html_string + link_to(mobject_path(:id => ea.mobject.id)) do 
                  #  content_tag(:i, nil, class:"fa fa-text-background")
                  #end
                  html_string = html_string + " " + ea.mobject.name + " (" + ea.mobject.owner.name + " " + ea.mobject.owner.lastname + ")<br>"
                  #html_string = html_string + "<div class='row'>"
                    #html_string = html_string + '<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 col-xl-4">'
                      #html_string = html_string + showFirstImage2(:small, ea.mobject, ea.mobject.mdetails)
                    #html_string = html_string + "</div>"
                    #html_string = html_string + '<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">'
                      #html_string = html_string + " " + ea.mobject.name + "<br>"
                    #html_string = html_string + "</div>"
                  #html_string = html_string + "</div>"
                end
                
              when "comments"
                html_string = html_string + "<blog>'" + item.description + "'</blog>"

              when "questions"
                html_string = html_string + '<i class="fa fa-folder-open"></i> '
                html_string = html_string + item.mcategory.name + '<br><br>'
                
                if item.mcategory.name == "single".downcase or item.mcategory.name == "multiple".downcase 

    	            html_string = html_string + link_to(new_answer_path(:question_id => item.id)) do 
                    content_tag(:i, nil, class:"btn btn-primary btn-xs fa fa-plus")
                  end
                  html_string = html_string + (I18n.t :antwortoptionen) + '<br><br>'
                  item.answers.each do |a|

                    html_string = html_string + "<div class='row'>"
                    html_string = html_string + '<div class="col-xs-8 col-sm-8 col-md-8 col-lg-8 col-xl-8">'
                    case item.mcategory.name
                      when "text"
                        html_string = html_string + a.name
                      when "numerisch"
                        html_string = html_string + a.name 
                      when "multiple"
                        html_string = html_string + a.name 
                      when "single"
                        html_string = html_string + a.name 
                      end
                      html_string = html_string + "</div>"
                      html_string = html_string + '<div class="col-xs-4 col-sm-4 col-md-4 col-lg-4 col-xl-4">'
        	            html_string = html_string + link_to(a, method: :delete, data: { confirm: 'Are you sure?' }) do 
                        content_tag(:i, nil, class:"btn btn-danger btn-xs fa fa-trash pull-right")
                      end
        	            html_string = html_string + link_to(edit_answer_path(:id => a)) do 
                        content_tag(:i, nil, class:"btn btn-primary btn-xs fa fa-wrench pull-right")
                      end
                      html_string = html_string + "</div>"
                      html_string = html_string + "</div>"
                    
                  end

                end
                
              when "articles"
                html_string = html_string + '<i class="fa fa-folder-open"></i> '
                html_string = html_string + item.mcategory.name + '<br>'
                html_string = html_string + '<i class="fa fa-exclamation-sign"></i> '
                html_string = html_string + item.status.to_s + '<br>'

              when "tickets"
                html_string = html_string + '<i class="fa fa-folder-open"></i> '
                html_string = html_string + item.mcategory.name + '<br>'
                html_string = html_string + '<i class="fa fa-euro"></i> '
                html_string = html_string + item.amount.to_s+ '<br>'
                html_string = html_string + '<i class="fa fa-exclamation-sign"></i> '
                html_string = html_string + item.contingent.to_s + ' verfügbar <br>'
                html_string = html_string + '<i class="fa fa-warning-sign"></i> '
                html_string = html_string + item.user_tickets.count.to_s + ' verkauft <br>'

              when "mdetails"
                html_string = html_string + '<i class="fa fa-pencil"></i> '
                html_string = html_string + item.description + '<br>' if item.description

              when "users"
                html_string = html_string +  item.email

              when "companies"
                html_string = html_string + '<i class="fa fa-folder-open"></i>'
                html_string = html_string + " " + item.mcategory.name
                html_string = html_string + '<br><br>'
                html_string = html_string + contactChip(item.user)

              when "customers"
                html_string = html_string + '<i class="fa fa-folder-open"></i> '
                html_string = html_string + @comp.mcategory.name + '<br>'
                html_string = html_string + '<i class="fa fa-home"></i> '
                html_string = html_string + @comp.geo_address + '<br>'
                html_string = html_string + '<i class="fa fa-envelope"></i> '
                html_string = html_string + @comp.user.email + '<br>'

              when "mobjects"

                if item.sum_rating and item.sum_rating > 0
                  item.sum_rating.round.times do
                    html_string = html_string + '<i class="fa fa-star"></i> '
                  end
                  html_string = html_string + ' (' + sprintf("%.1f",item.sum_rating) + ')<br>'
                end
                
                html_string = html_string + '<i class="fa fa-folder-open"></i> '
                html_string = html_string + " " + item.mcategory.name + "<br><br>"

                case item.mtype
                  when "sensoren"
                    if item.mcategory.name == "Wert"
                      if item.sensors.last
                        html_string = html_string + '<br>'
                        html_string = html_string + "<sensorwert>" + item.sensors.last.value.to_s + "</sensorwert>"
                        html_string = html_string + '<br><br>'
                      end
                    end
                    if item.mcategory.name == "Schalter"
                      if item.sensors.last
                        html_string = html_string + '<br>'
                        if item.sensors.last.value > 0
                          html_string = html_string + "<sensorwert>An</sensorwert>"
                        else
                          html_string = html_string + "<sensorwert>Aus</sensorwert>"
                        end
                        html_string = html_string + '<br><br>'
                      end
                    end
                  when "kampagnen" 

                  when "standorte" 

                  when "veranstaltungen" 
                    if item.eventpart
                      html_string = html_string + '<i class="fa fa-info"></i> '+(I18n.t :anmeldungerforderlich) + "<br>"
                    else
                      html_string = html_string + '<i class="fa fa-info"></i> ' + (I18n.t :keineanmeldungerforderlich) + "<br>"
                    end
                    @angemeldet = nil
                    if user_signed_in?
                      @angemeldet = current_user.madvisors.where('mobject_id=? and role=?', item.id, "eventteilnehmer").first
                      if @angemeldet
                        html_string = html_string + '<i class="fa fa-pencil"></i> '+(I18n.t :angemeldet)+ "<br>"
                      end
                    end
                    html_string = html_string + '<i class="fa fa-calendar"></i> '
                    html_string = html_string +  item.date_from.strftime("%d.%m.%Y") + " - " + item.date_to.strftime("%d.%m.%Y") + '<br>'
                    soll = (item.date_to.to_date - item.date_from.to_date).to_i
                    ist = (DateTime.now.to_date - item.date_from.to_date).to_i
                    if soll > 0 and ist > 0
                      html_string = html_string + '<div class="progress">'
                      html_string = html_string + '<div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                      html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                      html_string = html_string + '</div>'
                      html_string = html_string + '</div>'
                    end

                  when "publikationen"
                    @a = PublicationArticle.where('publication=?',item.id).order(sequence: :asc)
                    html_string = html_string + " <fire>" + @a.count.to_s + " " + (I18n.t :articles)
                    html_string = html_string + '</fire><br><br>'
                    html_string = html_string + "<fire>"                    
                       @a.each do |a|
                          html_string = html_string + link_to(mobject_path(:id => a.article, :topic => "objekte_info")) do
                            #content_tag(:div, showImage2(:small, e, false)) + content_tag(:div, e.name)
                            @mo = Mobject.find(a.article)
                            if @mo
                              content_tag(:div, @mo.name, class:"mediabuttonred")
                            end
                          end
                          #html_string = html_string + "<br>"
                        end
                    html_string = html_string + "</fire>"                    
                    html_string = html_string + '<br>'
                    
                  when "projekte"
                    if !item.date_from
                      item.date_from = Date.today
                    end
                    if !item.date_to
                      item.date_to = Date.today
                    end
                    if !item.risk
                      item.risk = "tief"
                    end
                    if !item.quality
                      item.quality = "hoch"
                    end

                    html_string = html_string + "<div class='row' style='padding-right:20px'>"
                      html_string = html_string + "<div class='col-xs-4'>"
                        html_string = html_string + item.date_to.strftime("%d.%m.%Y")
                      html_string = html_string + "</div>"
                      html_string = html_string + "<div class='col-xs-8'>"
                        soll = (item.date_to.to_date - item.date_from.to_date).to_i
                        ist = (DateTime.now.to_date - item.date_from.to_date).to_i
                        if soll > 0 and ist > 0
                          html_string = html_string + '<div class="progress">'
                          html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                          html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                          html_string = html_string + '</div>'
                          html_string = html_string + '</div>'
                        end
                      html_string = html_string + "</div>"
                    html_string = html_string + "</div>"

                    if !item.sum_pkosten_plan
                      item.sum_pkosten_plan = 0.0
                    end
                    if !item.sum_paufwand_plan
                      item.sum_paufwand_plan = 0.0
                    end
                    if !item.sum_pkosten_ist
                      item.sum_pkosten_ist = 0.0
                    end
                    if !item.sum_paufwand_ist
                      item.sum_paufwand_ist = 0.0
                    end

                    html_string = html_string + "<div class='row' style='padding-right:20px'>"
                      html_string = html_string + "<div class='col-xs-4'>"
                        html_string = html_string + sprintf("%5.0f K"+(I18n.t :waehrung),item.sum_pkosten_plan/1000)
                      html_string = html_string + "</div>"
                      html_string = html_string + "<div class='col-xs-8'>"
                        if item.sum_pkosten_plan and item.sum_pkosten_ist
                          html_string = html_string + '<div class="progress">'
                          html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + item.sum_pkosten_ist.to_s + '" aria-valuemin="0" aria-valuemax="' + item.sum_pkosten_plan.to_s + '" style="width:' + (item.sum_pkosten_ist*100/item.sum_pkosten_plan).to_s + '%">'
                          html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                          html_string = html_string + '</div>'
                          html_string = html_string + '</div>'
                        end
                      html_string = html_string + "</div>"
                    html_string = html_string + "</div>"

                    html_string = html_string + "<div class='row' style='padding-right:20px'>"
                      html_string = html_string + "<div class='col-xs-4'>"
                        html_string = html_string + sprintf("%5.0f "+(I18n.t :personentage),item.sum_paufwand_plan)
                      html_string = html_string + "</div>"
                      html_string = html_string + "<div class='col-xs-8'>"
                        if item.sum_paufwand_plan and item.sum_paufwand_ist
                          html_string = html_string + '<div class="progress">'
                          html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + item.sum_paufwand_ist.to_s + '" aria-valuemin="0" aria-valuemax="' + item.sum_paufwand_plan.to_s + '" style="width:' + (item.sum_paufwand_ist*100/item.sum_paufwand_plan).to_s + '%">'
                          html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                          html_string = html_string + '</div>'
                          html_string = html_string + '</div>'
                        end
                      html_string = html_string + "</div>"
                    html_string = html_string + "</div>"

                    if false
                    html_string = html_string + "<div class='row'>"
                      html_string = html_string + "<div class='col-xs-4'>"
                      html_string = html_string + "</div>"
                      html_string = html_string + "<div class='col-xs-8'>"
                        html_string = html_string + "<div class='col-xs-6' align='center' >"
                          html_string = html_string + "Qualität"
                        html_string = html_string + "</div>"
                        html_string = html_string + "<div class='col-xs-6' align='center' >"
                          html_string = html_string + "Risiko"
                        html_string = html_string + "</div>"
                      html_string = html_string + "</div>"
                    html_string = html_string + "</div>"

                    html_string = html_string + "<div class='row'>"
                      html_string = html_string + "<div class='col-xs-4'>"
                      html_string = html_string + "</div>"
                      html_string = html_string + "<div class='col-xs-8'>"
                        html_string = html_string + "<div class='col-xs-6' align='center' style='font-size:4em'>"
                          html_string = html_string + "<div class='quality"+ item.quality + "'>"
                            html_string = html_string + '<i class="fa fa-stop"></i>'
                          html_string = html_string + "</div>"
                        html_string = html_string + "</div>"
                        html_string = html_string + "<div class='col-xs-6' align='center' style='font-size:4em'>"
                          html_string = html_string + "<div class='risk"+ item.risk + "'>"
                            html_string = html_string + '<i class="fa fa-stop"></i>'
                          html_string = html_string + "</div>"
                        html_string = html_string + "</div>"
                      html_string = html_string + "</div>"
                    html_string = html_string + "</div>"
                    end
                    
                    html_string = html_string + "<br>"
                    
                  when "ausschreibungen", "kleinanzeigen", "stellenanzeigen", "crowdfunding", "innovationswettbewerbe", "umfragen"
                    html_string = html_string + '<i class="fa fa-calendar"></i> '
                    html_string = html_string +  item.date_from.strftime("%d.%m.%Y") + " - " + item.date_to.strftime("%d.%m.%Y") + '<br>'
                    soll = (item.date_to.to_date - item.date_from.to_date).to_i
                    ist = (DateTime.now.to_date - item.date_from.to_date).to_i
                    if soll > 0 and ist > 0
                      html_string = html_string + '<div class="row" style="padding:10%">'
                        html_string = html_string + '<div class="progress">'
                          html_string = html_string + '<div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                            html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                          html_string = html_string + '</div>'
                        html_string = html_string + '</div>'
                      html_string = html_string + '</div>'
                    end
                    
                    if item.mtype == "innovationswettbewerbe"
                      #html_string = html_string + link_to(mobject_path(:id => item.id, :topic => "objekte_ideen")) do
                        #content_tag(:i, nil, class:"fa fa-certificate")
                      #end
                      html_string = html_string + " <fire>" + item.ideas.count.to_s + " " + (I18n.t :ideen)
                      html_string = html_string + '</fire><br><br>'
                    end

                    if item.mtype == "umfragen"
                      html_string = html_string + " <fire>" + item.questions.count.to_s + " " + (I18n.t :fragen)
                      html_string = html_string + '</fire><br><br>'
                    end

                    if item.mtype == "crowdfunding"

                      #if item.msubtype == "belohnungen"
                      #  html_string = html_string + '<i class="fa fa-gift"></i> '
                      #  html_string = html_string + item.reward + '<br>'
                      #end
                      #if item.msubtype == "zinsen"
                        #html_string = html_string + '<i class="fa fa-signal"></i> '
                        #html_string = html_string + sprintf("%3.1f %",item.interest_rate)  + '<br>'
                      #end
                      #html_string = html_string + '<br><br>'

                      if item.sum_amount and item.sum_amount > 0 and item.amount and item.amount > 0
                        html_string = html_string + '<i class="fa fa-euro"></i> '+ sprintf("%05.2f CHF", item.sum_amount) + " / " + sprintf("%05.2f CHF", item.amount) + "<br>"
                        html_string = html_string + '<div class="progress">'
                        html_string = html_string + '<div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow="' + item.sum_amount.to_s + '" aria-valuemin="0" aria-valuemax="' + item.amount.to_s + '" style="width:' + (item.sum_amount/item.amount*100).to_s + '%">'
                        html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                        html_string = html_string + '</div>'
                        html_string = html_string + '</div>'
                      end
                    end

                 when "angebote"
                    html_string = html_string + '<i class="fa fa-folder"></i> '
                    html_string = html_string +  item.msubtype + "<br>" 
                    if item.msubtype == "standard"
                      if item.price_reg
                        html_string = html_string + '<i class="fa fa-euro"></i> '
                        html_string = html_string +  sprintf("%05.2f CHF",item.price_reg) 
                      end
                    end
                    if item.msubtype == "aktion"
                      if item.price_new
                        html_string = html_string + '<i class="fa fa-euro"></i> '
                        html_string = html_string +  sprintf("%05.2f CHF",item.price_new) 
                      end
                      if item.price_reg
                        html_string = html_string + " statt " + sprintf("%05.2f CHF",item.price_reg) + '<br>'
                      end

                      html_string = html_string + '<i class="fa fa-calendar"></i> '
                      html_string = html_string +  item.date_from.strftime("%d.%m.%Y") + " - " + item.date_to.strftime("%d.%m.%Y") + '<br>'
                      soll = (item.date_to.to_date - item.date_from.to_date).to_i
                      ist = (DateTime.now.to_date - item.date_from.to_date).to_i
                      if soll > 0 and ist > 0
                        html_string = html_string + '<div class="progress">'
                        html_string = html_string + '<div class="progress-bar progress-bar-warning progress-bar-striped" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                        html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                        html_string = html_string + '</div>'
                        html_string = html_string + '</div>'
                      end

                    end
                end
                html_string = html_string + contactChip(item.owner)

                when "madvisors"
                    html_string = html_string + '<i class="fa fa-folder-open"></i> '
                    html_string = html_string + item.grade + "<br>"
                    if item.mobject.mtype == "projekte"
                      html_string = html_string + '<i class="fa fa-euro"></i> '
                      if !item.rate
                        item.rate = 0
                      end
                      html_string = html_string + sprintf("%5.2f",item.rate) + "<br>"
                    end
                    if item.mobject.mtype == "veranstaltungen"
                      html_string = html_string + '<i class="fa fa-safari"></i> '
                      html_string = html_string + item.created_at.strftime("%d.%m.%Y") 
                    end

                when "mstats"
                  if item.owner_type == "Company"
                      html_string = html_string + '<i class="fa fa-copyright-mark"></i> '
                      html_string = html_string + item.owner.name + "<br>"
                  end
                  if item.owner_type == "User"
                      html_string = html_string + '<i class="fa fa-user"></i> '
                      html_string = html_string + item.owner.name + " "+ item.owner.lastname + "<br>"
                  end
                  html_string = html_string + '<i class="fa fa-euro"></i> '
                  html_string = html_string + sprintf("%05.2f CHF",item.amount) + '<br>'
                  html_string = html_string + '<i class="fa fa-calendar"></i> '
                  html_string = html_string +  item.created_at.strftime("%d.%m.%Y") + '<br>'

              when "msponsors"
                  if items.table_name == "msponsors"
                    case item.slevel
                      when "1"
                        html_string = html_string + image_tag("Sponsor_gold.jpg", :size => "100x100", class:"img-rounded")
        				      when "2"
                        html_string = html_string + image_tag("Sponsor_silver.jpg", :size => "100x100", class:"img-rounded")
        				      when "3"
                        html_string = html_string + image_tag("Sponsor_bronze.jpg", :size => "100x100", class:"img-rounded")
                    end
                  end
                  
              when "favourits"
                html_string = html_string + @item.geo_address + '<br>'

              when "searches"
                #html_string = html_string + "<anzeigetext>" + item.name + "</anzeigetext><br>"
                if item.search_domain == "object"
                  html_string = html_string + '<i class="fa fa-folder-open"></i> '
                  html_string = html_string + item.mtype + "<br>" 
                  html_string = html_string + item.msubtype.to_s + '<br>'
                end
                html_string = html_string + '<i class="fa fa-question-sign"></i> '
                html_string = html_string + 'Anzahl ' + item.counter.to_s + '<br>'
                
              when "transactions"
                html_string = html_string + '<i class="fa fa-euro"></i> '
                html_string = html_string + sprintf("%05.2f CHF",item.amount) + '<br>'
                html_string = html_string + '<i class="fa fa-pencil"></i> '
                html_string = html_string +  item.ref + '<br>'
                html_string = html_string + '<i class="fa fa-calendar"></i> '
                html_string = html_string +  item.trx_date.strftime("%d.%m.%Y") + '<br>'
                html_string = html_string + '<i class="fa fa-inbox"></i> '
                html_string = html_string +  item.status + '<br>'

              when "mratings"
                item.rating.times do
                  html_string = html_string + '<i class="fa fa-star"></i>'
                end
                html_string = html_string + "<br>"
                html_string = html_string + '<i class="fa fa-pencil"></i> '
                html_string = html_string +  item.comment + '<br>'
                html_string = html_string + '<i class="fa fa-safari"></i> '
                html_string = html_string + item.created_at.strftime("%d.%m.%Y") 
          end
          html_string = html_string + '<br><br>'
          
          html_string = html_string + '<mediabutton>'

          html_string = html_string + '<div class="mediabuttonpanel">'
          #if (Date.today - item.created_at.to_date).to_i < 5
          #    html_string = html_string + '<i class="fa fa-calendar mediabutton"></i> '
          #end 

          #check credentials
          access = false
          if user_signed_in?
            case cname
              when "partner_links"
                if current_user.id = item.company.user_id or isdeputy(item.company.user_id)
                  access = true
                end
              when "prices"
                if isowner(item.mobject)
                  access = true
                end
              when "crits"
                if par
                  array = []
                  item.mobject.madvisors.each do |m|
                    array << m.user_id
                  end
                  if array.include?(current_user.id)
                    access = true
                  end
                else
                  if isowner(item.mobject)
                    access = true
                  end
                end

              when "ideas"
    	          #html_string = html_string + link_to(idea_crowdratings_path(:idea_id => item)) do 
                #    content_tag(:i, nil, class:"btn btn-primary fa fa-star")
                #end
                array = []
                item.mobject.madvisors.where('grade=? or grade=?',"Jury-Mitglied", "Jury-Vorsitz").each do |m|
                  array << m.user_id
                end
                if array.include?(current_user.id)
    	            html_string = html_string + link_to(idea_ratings_path(:idea_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-certificate")
                  end
                end
                if (item.user_id == current_user.id) or isdeputy(item.user)
                  access = true
                end
                if false
                if item.avatar_file_name
                  #html_string = html_string + "Weitere Informationen: "
                  html_string = html_string + link_to(item.avatar.url, target: "_blank") do 
                    content_tag(:i, nil, class:"fa fa-picture mediabutton")
                  end
                end
                if item.document_file_name
                  #html_string = html_string + "Weitere Informationen: "
                  html_string = html_string + link_to(item.document.url, target: "_blank") do 
                    content_tag(:i, nil, class:"fa fa-book mediabutton")
                  end
                end
                end

              when "idea_crowdratings"
                if (item.user_id == current_user.id) or isdeputy(item.user)
                  access = true
                end

              when "questions"
                if isowner(item.mobject)
                  access = true
                end

              when "edition_arcticles"
                #if isowner(item.mobject)
                  access = true
                #end

              when "editions"
  	            html_string = html_string + link_to(edition_arcticles_path(:edition_id => item)) do 
                  content_tag(:i, nil, class:"fa fa-text-background mediabutton")
                end
                if isowner(item.mobject)
                  access = true
                end

              when "tickets"
                if item.owner_type == "Mobject"
                  if isowner(item.owner) or isdeputy(item.owner)
                  #if isowner(item.mobject)
                    access = true
                  end
                  if item.user_tickets and item.contingent
                    if item.user_tickets.count < item.contingent
        	            html_string = html_string + link_to(new_user_ticket_path(:ticket_id => item.id, :user_id => current_user.id)) do 
                        content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-shopping-cart")
                      end
                    end
                  end
                end

              when "users"
  	            html_string = html_string + link_to(new_email_path(:m_to_id => item.id, :m_from_id => current_user.id, :back_url => request.original_url)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-envelope mediabutton")
                end
                if item.id == current_user.id or isdeputy(item)
                  access=true
                end 

              when "companies"
                if item.user_id == current_user.id or isdeputy(item.user)
                  access=true
                end 

              when "favourits", "searches", "mratings", "comments"
                if item.user_id == current_user.id or isdeputy(item.user)
                  access=true
                end 

              when "mobjects", "partners", "mstats", "transactions"
                #if cname == "signage_locs"
    	          #   html_string = html_string + link_to(home_index11_path(:loc_id => item.id)) do 
                #    content_tag(:i, nil, class:"btn btn-primary fa fa-blackboard")
                #  end
                # end
                if cname == "mobjects"
                    # if item.mtype == "projekte" and item.madvisors.where('role=? and user_id=?',item.mtype, current_user.id).count > 0
                    #   html_string = html_string + link_to(timetracks_path(:mobject_id => item.id)) do 
                    #     content_tag(:i, nil, class:"btn btn-primary fa fa-pencil")
                    #   end
                    # end
                    if isowner(item) or isdeputy(item.owner)
                      access = true
                    end
                  if item.mtype == "veranstaltungen" 
                    if item.eventpart
                      if @angemeldet
          	            html_string = html_string + link_to(mobjects_path(:del_part_id => item.id, :topic => :veranstaltung)) do 
                          content_tag(:i, nil, class:"fa fa-pencil mediabutton")
                        end
                      else
          	            html_string = html_string + link_to(mobjects_path(:set_part_id => item.id, :topic => :veranstaltung)) do 
                          content_tag(:i, nil, class:"fa fa-pencilmediabutton")
                        end
                      end
                    end
                  end
                  if item.mtype == "artikel"
                    if par #Artikelauswahl für Edition
                      html_string = html_string + link_to(new_edition_arcticle_path(:edition_id => par, :article_id => item.id)) do
                        content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-pencil mediabutton")
                      end
                    end
                  end
                  if item.mtype == "umfragen"
                    html_string = html_string + link_to(user_answers_path(:mobject_id => item.id, :user_id => current_user.id)) do
                      content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-pencil mediabutton")
                    end
                    #html_string = html_string + link_to(home_index17_path(:mobject_id => item.id)) do
                    #  content_tag(:i, nil, class:"btn btn-primary fa fa-stats")
                    #end
                  end

                  if item.mtype == "kampagnen"
                    html_string = html_string + link_to(signage_cals_path(:kam_id => item.id)) do
                      content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-calendar")
                    end
                     html_string = html_string + link_to(home_index18_path(:kam_id => item.id), title: (I18n.t :kampagnenshow), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
                      content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-film ")
                     end
                  end
                  if item.mtype == "standorte"
                    html_string = html_string + link_to(signage_cals_path(:loc_id => item.id)) do
                      content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-calendar mediabutton")
                    end
                     html_string = html_string + link_to(home_index18_path(:standort => item.id), title: (I18n.t :standortshow), 'data-toggle' => 'tooltip', 'data-placement' => 'top', 'class' => 'new-tooltip') do
                      content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-film ")
                     end
                   end
                end
                
              when "nopartners"
                access = true
                
              when "deputies"
                if isowner(item)
                  access = true
                end
               when "madvisors"
                if item.user_id == current_user.id or isdeputy(item.mobject.owner) or current_user.id = item.mobject.owner_id
                  access = true
                end

              when "mdetails"
                if item.document_file_name
    	            html_string = html_string + link_to(item.document.url, target: "_blank") do 
                    content_tag(:i, nil, class:"fa fa-cloud-download mediabutton")
                  end
                end
                if isowner(item.mobject) or isdeputy(item.mobject.owner)
                  access = true
                end

              when "msponsors"
                if item.company.user_id == current_user.id or isdeputy(item.company)
                  access = true
                end
               
             end
          end

          #kein Info button wenn kein weiterer drill down
          if cname != "prices" and cname != "crits" and cname != "mdetails" and cname != "madvisors" and cname != "tickets" and cname != "questions" and cname != "comments" and cname != "partner_links" and cname != "appparams"
            html_string = html_string + link_to(item, :topic => "info") do 
              content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-info")
            end
          end
 
          if access
            case cname 
              when "partner_links"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_partner_link_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "companies"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_company_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "users"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_user_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "prices"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_price_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "crits"
                if par 
    	            html_string = html_string + link_to(edit_idea_rating_path(:id => @idearating.id)) do 
                    content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-pencil")
                  end
                else
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_crit_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                  end
                end
              when "ideas"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_idea_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "idea_crowdratings"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_idea_crowdrating_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "edition_arcticles"
  	            html_string = html_string + link_to(edition_arcticles_path(:edition_id => item.edition_id, :dir => "left", :d_id => item.id)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-chevron-left")
                end
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_edition_arcticle_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench mediabutton")
                end
              when "editions"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_edition_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
  	            #html_string = html_string + link_to(edition_arcticles_path(:edition_id => item)) do 
                #  content_tag(:i, nil, class:"btn btn-primary fa fa-book")
                #end
              when "comments"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_comment_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-wrench")
                end
              when "tickets"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_ticket_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
               when "favourits"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
               when "madvisors"
                # if par == "User"
    	           # html_string = html_string + link_to(user_path(:id => item.user_id, :topic => "Kalendereintraege")) do 
                #     content_tag(:i, nil, class:"btn btn-primary fa fa-calendar")
                #   end
    	           # html_string = html_string + link_to(new_email_path(:m_from_id => current_user.id, :m_to_id => item.user_id)) do 
                #     content_tag(:i, nil, class:"btn btn-primary fa fa-envelope")
                #   end
                # end
                if item.mobject.mtype == "projekte"
    	            html_string = html_string + link_to(edit_madvisor_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                  end
                end
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
                html_string = html_string + "<br><br>"

              when "deputies"
  	            html_string = html_string + link_to(edit_deputy_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default fa fa-wrench")
                end
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger fa fa-trash pull-right")
                end

              when "partners"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_customer_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
  	            html_string = html_string + link_to(accounts_path(:customer_id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-list")
                end
              when "mstats"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_mstat_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
  	            html_string = html_string + link_to(accounts_path(:customer_id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-euro")
                end
              when "nopartners"
                if par[:user_id]
    	            html_string = html_string + link_to(new_customer_path(:user_id => par[:user_id], :partner_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-pencil")
                  end
                end
                if par[:company_id]
    	            html_string = html_string + link_to(new_customer_path(:company_id => par[:company_id], :partner_id => item)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-pencil")
                  end
                end
              when "searches"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_search_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "msponsors"
  	            html_string = html_string + link_to(tickets_path :msponsor_id => item.id) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-barcode")
                end
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_msponsor_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "mdetails"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
                if item.mobject.mtype == "artikel"
    	            html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => "objekte_details", :dir => "left", :d_id => item.id)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-chevron-left")
                  end
                end
  	            html_string = html_string + link_to(edit_mdetail_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "questions"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => "objekte_fragen", :dir => "left", :q_id => item.id)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-chevron-left mediabutton")
                end
  	            html_string = html_string + link_to(edit_question_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench mediabutton")
                end
                if item.mcategory.name == "multiple" or item.mcategory.name == "single"  
                  html_string = html_string + link_to(home_index16_path(:question_id => item.id)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-signal")
                  end
                end

              when "mratings"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_mrating_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
              when "transactions"
                if item.status == "erfasst"
                  #if @customer.owner_type == "User"
                  #  html_string = html_string + link_to(user_path(:id => @customer.owner_id, :trx_status_ok_id => t.id, :topic => "Transaktionen")) do
                  #    content_tag(:i, nil, class:"btn btn-primary fa fa-ok")
                  #  end
                  #end
                  #if @customer.owner_type == "Company"
                  #  html_string = html_string + link_to(company_path(:id => @customer.owner_id, :trx_status_ok_id => t.id, :topic => "Transaktionen")) do
                  #    content_tag(:i, nil, class:"btn btn-primary fa fa-ok")
                  #  end
                  #end
    	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                    content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                  end
    	            html_string = html_string + link_to(edit_transaction_path(:id => item)) do 
                    content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                  end
                end
                if item.status == "freigegeben"
                  #if @customer.owner_type == "User"
                  #  html_string = html_string + link_to(user_path(:id => @customer.owner_id, :trx_status_ausgefuehrt_id => t.id, :topic => "Transaktionen")) do
                  #    content_tag(:i, nil, class:"btn btn-primary fa fa-ok")
                  #  end
                  #end
                  #if @customer.owner_type == "Company"
                  #  html_string = html_string + link_to(company_path(:id => @customer.owner_id, :trx_status_ausgefuehrt_id => t.id, :topic => "Transaktionen")) do
                  #    content_tag(:i, nil, class:"btn btn-primary fa fa-ok")
                  #  end
                  #end
                end
              when "mobjects"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_mobject_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
                 #if item.mtype == "artikel"
                 #    html_string = html_string + link_to(user_path(:id => item.owner_id, :topic => "Artikel", :article_id => item.id)) do
                 #     content_tag(:i, nil, class:"btn btn-primary fa fa-copy")
                 #  end
                 #end

            end

          end
              html_string = html_string + '</div>' #blog-comment
            html_string = html_string + '</div>' #blog-info
          html_string = html_string + '</div>'
        html_string = html_string + '</div>'
      html_string = html_string + '</div>'

    end #item show
  end # loop item
  html_string = html_string + '</div>'
  if par == "panel"
    html_string = html_string + '</div>'
  end
  return html_string.html_safe
end

def showFirstImage2(size, item, details)
    case size
      when :medium
        ssize = "250x250"
      when :small
        ssize = "50x50"
    end
    html_string = link_to item do
      if details.count > 0
        pic = details.first
        if pic.avatar_file_name
          image_tag pic.avatar(size), class:"img-rounded img-responsive"
        else
          image_tag(item.mtype + ".png", :size => ssize, class:"card-img-top img-responsive")
        end
      else
        image_tag(item.mtype + ".png", :size => ssize, class:"card-img-top img-responsive")
      end
    end
    return html_string.html_safe
end

def showImage2(size, item, linkit)
    case size
      when :medium
        ssize = "250x250"
      when :small
        ssize = "50x50"
    end
    if linkit
      html_string = link_to(item) do
        if item.avatar_file_name
            image_tag(item.avatar(size), class:"img-responsive")
        else
          case item.class.name
            when "User"
              image_tag("personen.png", :size => ssize, class:"card-img-top img-responsive" )
            when "Company"
              image_tag("institutionen.png", :size => ssize, class:"card-img-top img-responsive" )
            when "Edition"
              image_tag("ausgaben.jpg", :size => ssize, class:"card-img-top img-responsive" )
            else
              image_tag("no_pic.jpg", :size => ssize, class:"card-img-top img-responsive" )
          end
        end
      end
    else
      if item.avatar_file_name
          html_string = image_tag(item.avatar(size), class:"img-responsive")
      else
        case item.class.name
          when "User"
            html_string = image_tag("person.png", :size => "50x50", class:"card-img-top img-responsive" )
          when "Company"
            html_string = image_tag("company.png", :size => "50x50", class:"card-img-top img-responsive" )
          when "Edition"
            html_string = image_tag("ausgaben.jpg", :size => "50x50", class:"card-img-top img-responsive" )
          else
            html_string = image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive" )
        end
      end
    end
    return html_string.html_safe
end

def header(header)
    html_string = ""
    #html_string = html_string + '<div class="container">'
      html_string = html_string + '<div class="panel-body ueberschrift">'
        html_string = html_string + header
      html_string = html_string + "</div>"
    #html_string = html_string + "</div>"

    return html_string.html_safe
end

def header3(objekt, item, topic, format)

    pos = topic.to_s.index("_")
    if pos > 0
      infosymbol = (topic[pos+1..topic.length-1]).to_sym
    else
      infosymbol = topic
    end
    
  if format
    html_string = "<div class='col-xs-12'><div class='panel-heading header'><li_header>" + (I18n.t infosymbol) + "</li_header></div></div>"
  else
    html_string = "<div class='panel-heading header'><li_header>" + (I18n.t infosymbol) + "</li_header></div>"
  end
  
  html_string = html_string + action_buttons2(objekt, item, topic)

  return html_string.html_safe
end

def getTopicName(topic)
  pos = topic.to_s.index("_")
  if pos > 0
    infosymbol = (topic[pos+1..topic.length-1]).to_sym
  else
    infosymbol = topic
  end
  return (I18n.t infosymbol)
end

def navigate2(object, item, topic)

  html_string = ""
  
  html_string = html_string + '<ul class="nav nav-tabs">'
  html_string = html_string + '<li class="nav-item dropdown">'
    html_string = html_string + '<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Info</a>'
    html_string = html_string + '<div class="dropdown-menu">'

  case object
    when "edition_artikeln"
      html_string = html_string + build_nav2("edition_artikeln",item,"artikel_ausgaben",1)

    when "editionen"
      html_string = html_string + build_nav2("editionen",item,"editionen_ausgaben",item.edition_arcticles.count)
      html_string = html_string + build_nav2("edition_artikel",item,"edition_artikel",item.edition_arcticles.count)
      
    when "tabellen"
      html_string = html_string + build_nav2("tabellen",item,"tabellen_kategorien",1)
      
    when "ideenbewertung"
      html_string = html_string + build_nav2("ideenbewertung",item,"ideenbewertung",1)
      
    when "personen"
      html_string = html_string + build_nav2("personen",item,"personen_info",1)
      html_string = html_string + build_nav2("personen",item,"personen_notizen", item.notes.count)
      html_string = html_string + build_nav2("personen",item,"personen_mappositionen", item.user_positions.count)
      html_string = html_string + build_nav2("personen",item,"personen_angebote",item.mobjects.where('mtype=?',"angebote").count)
      html_string = html_string + build_nav2("personen",item,"personen_projekte", item.mobjects.where('mtype=? and parent=?',"projekte",0).count)
      html_string = html_string + build_nav2("personen",item,"personen_zeiterfassung", item.timetracks.count)
      html_string = html_string + build_nav2("personen",item,"personen_ressourcenplanung", item.plannings.count)
      html_string = html_string + build_nav2("personen",item,"personen_gruppen", item.mobjects.where('mtype=?',"gruppen").count)
      html_string = html_string + build_nav2("personen",item,"personen_institutionen",item.companies.count)
      html_string = html_string + build_nav2("personen",item,"personen_umfragen", item.mobjects.where('mtype=?',"umfragen").count)
      html_string = html_string + build_nav2("personen",item,"personen_innovationswettbewerbe",item.mobjects.where('mtype=?',"innovationswettbewerbe").count)
      html_string = html_string + build_nav2("personen",item,"personen_ideen",item.ideas.count)
      html_string = html_string + build_nav2("personen",item,"personen_publikationen", item.mobjects.where('mtype=?',"publikationen").count)
      html_string = html_string + build_nav2("personen",item,"personen_artikel", item.mobjects.where('mtype=?',"artikel").count)
      html_string = html_string + build_nav2("personen",item,"personen_veranstaltungen",item.mobjects.where('mtype=?',"veranstaltungen").count)
      html_string = html_string + build_nav2("personen",item,"personen_anmeldungen",item.madvisors.where('role=?',"eventteilnehmer").count)
      html_string = html_string + build_nav2("personen",item,"personen_tickets",item.user_tickets.count)
      html_string = html_string + build_nav2("personen",item,"personen_sensoren",item.mobjects.where('mtype=?',"sensoren").count)
      html_string = html_string + build_nav2("personen",item,"personen_ausflugsziele",item.mobjects.where('mtype=?',"ausflugsziele").count)
      html_string = html_string + build_nav2("personen",item,"personen_kleinanzeigen",item.mobjects.where('mtype=?',"kleinanzeigen").count)
      html_string = html_string + build_nav2("personen",item,"personen_stellenanzeigen",item.mobjects.where('mtype=?',"stellenanzeigen").count)
      html_string = html_string + build_nav2("personen",item,"personen_vermietungen",item.mobjects.where('mtype=?',"vermietungen").count)
      html_string = html_string + build_nav2("personen",item,"personen_ausschreibungen",item.mobjects.where('mtype=?',"ausschreibungen").count)
      html_string = html_string + build_nav2("personen",item,"personen_crowdfunding", item.mobjects.where('mtype=? ',"crowdfunding").count)
      html_string = html_string + build_nav2("personen",item,"personen_crowdfundingbeitraege", item.mstats.count)
      html_string = html_string + build_nav2("personen",item,"personen_bewertungen", item.mratings.count)
      html_string = html_string + build_nav2("personen",item,"personen_favoriten",item.favourits.count)
      html_string = html_string + build_nav2("personen",item,"personen_zugriffsberechtigungen", item.credentials.count)
      html_string = html_string + build_nav2("personen",item,"personen_stellvertretungen", item.deputies.count)
      if user_signed_in?
        html_string = html_string + build_nav2("personen",item,"personen_charges", item.charges.count)
      end

        ########################################################################################################################
        # inactive code
        ########################################################################################################################
        if false
        html_string = html_string + build_nav2("personen",item,"personen_kalendereintraege", Appointment.where('user_id1=? or user_id2=?',item,item).count)
        html_string = html_string + build_nav2("personen",item,"personen_ansprechpartner",item.madvisors.count)
        html_string = html_string + build_nav2("personen",item,"personen_kundenbeziehungen", item.customers.count)
        html_string = html_string + build_nav2("personen",item,"personen_transaktionen", item.transactions.where('ttype=?', "payment").count)
        html_string = html_string + build_nav2("personen",item,"personen_emails", Email.where('m_to=? or m_from=?', item.id, item.id).count)
        end

      when "institutionen"
        html_string = html_string + build_nav2("institutionen",item,"institutionen_info",1)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_projekte", item.mobjects.where('mtype=? and parent=?',"projekte",0).count)
        if item.partner
          html_string = html_string + build_nav2("institutionen",item,"institutionen_partnerlinks", item.partner_links.count)
        end
        html_string = html_string + build_nav2("institutionen",item,"institutionen_angebote",item.mobjects.where('mtype=? ',"angebote").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_kampagnen", item.mobjects.where('mtype=?',"kampagnen").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_standorte", item.mobjects.where('mtype=?',"standorte").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_umfragen", item.mobjects.where('mtype=?',"umfragen").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_innovationswettbewerbe",item.mobjects.where('mtype=?',"innovationswettbewerbe").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_publikationen", item.mobjects.where('mtype=?',"publikationen").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_veranstaltungen",item.mobjects.where('mtype=?',"veranstaltungen").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_sponsorenengagements",item.msponsors.count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_sensoren",item.mobjects.where('mtype=?',"sensoren").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_ausflugsziele",item.mobjects.where('mtype=?',"ausflugsziele").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_kleinanzeigen",item.mobjects.where('mtype=?',"kleinanzeigen").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_stellenanzeigen",item.mobjects.where('mtype=?',"stellenanzeigen").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_vermietungen",item.mobjects.where('mtype=?',"vermietungen").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_ausschreibungen",item.mobjects.where('mtype=?',"ausschreibungen").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_crowdfunding", item.mobjects.where('mtype=?',"crowdfunding").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_crowdfundingbeitraege", item.mstats.count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_stellvertretungen", item.deputies.count)
        if user_signed_in?
          html_string = html_string + build_nav2("institutionen",item,"institutionen_charges", item.charges.count)
        end

        ########################################################################################################################
        # inactive code
        ########################################################################################################################
        if false
        html_string = html_string + build_nav2("institutionen",item,"institutionen_kundenbeziehungen", item.customers.count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_transaktionen",item.transactions.where('ttype=?', "payment").count)
        html_string = html_string + build_nav2("institutionen",item,"institutionen_emails", Email.where('m_to=? or m_from=?', item.user.id, item.user.id).count)
        end

      when "objekte"
        if item.owner_type == "User"
          html_string = html_string + build_nav2("personen",item.owner,"personen_"+item.mtype,1)
        end
        if item.owner_type == "Company"
          html_string = html_string + build_nav2("institutionen",item.owner,"institutionen_"+item.mtype,1)
        end
        html_string = html_string + build_nav2("objekte",item,"objekte_info",1)
        if user_signed_in?
          if isowner(item) or isdeputy(item.owner)
            html_string = html_string + build_nav2("objekte",item,"objekte_details",item.mdetails.where('mtype=?',"details").count)
          end
        end 
        if item.mtype == "projekte"
          if user_signed_in?
            if isowner(item) or isdeputy(item.owner)
              html_string = html_string + build_nav2("objekte",item,"objekte_substruktur", Mobject.where('parent=?',item.id).count)
              #html_string = html_string + build_nav2("objekte",item,"objekte_projektberechtigungen", item.madvisors.where('role=?',item.mtype).count)
            end
          end
          html_string = html_string + build_nav2("objekte",item,"objekte_auftragscontrolling", item.timetracks.count)
          html_string = html_string + build_nav2("objekte",item,"objekte_projektdashboard", item.timetracks.count)
        end
        if item.mtype == "gruppen"
          html_string = html_string + build_nav2("objekte",item,"objekte_gruppenmitglieder", item.madvisors.where('role=?',item.mtype).count)
          html_string = html_string + build_nav2("objekte",item,"objekte_ressourcenplanung", item.madvisors.where('role=?',item.mtype).count)
        end
        if item.mtype == "kampagnen"
          html_string = html_string + build_nav2("objekte",item,"objekte_signcal", SignageCal.where('mkampagne=?', item.id).count)
          html_string = html_string + build_nav2("objekte",item,"objekte_signkamshow", SignageCal.where('mkampagne=?', item.id).count)
          html_string = html_string + build_nav2("objekte",item,"objekte_signstat", SignageCal.where('mkampagne=?', item.id).count)
        end
        if item.mtype == "standorte"
          html_string = html_string + build_nav2("objekte",item,"objekte_signcal", SignageCal.where('mstandort=?', item.id).count)
          html_string = html_string + build_nav2("objekte",item,"objekte_signlocshow", SignageCal.where('mstandort=?', item.id).count)
          html_string = html_string + build_nav2("objekte",item,"objekte_signstat", SignageCal.where('mstandort=?', item.id).count)
        end
        if item.mtype == "umfragen"
          if user_signed_in?
            if isowner(item)
              html_string = html_string + build_nav2("objekte",item,"objekte_fragen",item.questions.count)
              #html_string = html_string + build_nav2("objekte",item,"objekte_umfrageteilnehmer",User.count)
            end
          end
        end
        if item.mtype == "innovationswettbewerbe"
          html_string = html_string + build_nav2("objekte",item,"objekte_preise", item.prices.count)
          html_string = html_string + build_nav2("objekte",item,"objekte_bewertungskriterien", item.crits.count)
          #html_string = html_string + build_nav2("objekte",item,"objekte_jury", item.madvisors.count)
          html_string = html_string + build_nav2("objekte",item,"objekte_ideen",item.ideas.count)
        end
        if item.mtype == "publikationen"
          html_string = html_string + build_nav2("objekte",item,"objekte_artikel", PublicationArticle.where('publication=?',item.id).count)
        end
        if item.mtype == "artikel" and @edition_id
          html_string = html_string + build_nav2("edition",Edition.find(@edition_id),"objekte_ausgabe",1)
        end
        if item.mtype == "sensoren"
          html_string = html_string + build_nav2("objekte",item,"objekte_sensordaten",item.sensors.count)
        end
        if item.mtype == "veranstaltungen"
          html_string = html_string + build_nav2("objekte",item,"objekte_eintrittskarten",item.tickets.count)
          html_string = html_string + build_nav2("objekte",item,"objekte_sponsorenengagements",item.msponsors.count)
          html_string = html_string + build_nav2("objekte",item,"objekte_teilnehmerveranstaltung",item.madvisors.where('role=?',"eventteilnehmer").count)
        end
        if item.mtype == "vermietungen"
          html_string = html_string + build_nav2("objekte",item,"objekte_kalendervermietungen",item.mcalendars.count)
        end
        if item.mtype == "ausschreibungen"
          html_string = html_string + build_nav2("objekte",item,"objekte_ausschreibungsangebote",item.mdetails.where('mtype=?',"ausschreibungsangebote").count)
        end
        if item.mtype == "crowdfunding"
          html_string = html_string + build_nav2("objekte",item, "objekte_cfstatistik",item.mstats.count)
          html_string = html_string + build_nav2("objekte",item, "objekte_cftransaktionen",item.mstats.count)
        end

        case item.mtype 
          when "angebote", "ausflugsziele", "veranstaltungen"
            html_string = html_string + build_nav2("objekte",item, "objekte_bewertungen" ,item.mratings.count)
        end
        
        ########################################################################################################################
        # inactive code
        ########################################################################################################################
        if false
        if item.mtype == "angebote" or item.mtype == "stellenanzeigen"
          html_string = html_string + build_nav2("objekte",item,"objekte_ansprechpartner",item.madvisors.count)
        end
        end
        if user_signed_in?
          if isowner(item) or isdeputy(item.owner)
            html_string = html_string + build_nav2("objekte",item,"objekte_projektberechtigungen", item.madvisors.where('role=?',item.mtype).count)
          end
        end

    end
    html_string = html_string + '</div></li>'
    
    html_string = html_string + action_buttons4(object, item, topic)

    html_string = html_string + '</ul>'

    if false
    html_string = html_string + '<div class="panel-body">'
      html_string = html_string + '<div class="col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">'
        case object
          when "personen"
            header = item.name + " " + item.lastname
          else
            header = item.name
        end
        html_string = html_string + '<h1>'+header+'</h1>'
      html_string = html_string + '</div>'
    html_string = html_string + '</div>'
    end
    
    return html_string.html_safe
    
end

def build_nav2(domain, item, domain2, anz)
  
  html_string=""

  if (!user_signed_in? and $activeapps.include?(domain2)) or (user_signed_in? and getUserCreds.include?(domain2)) or (user_signed_in? and current_user.superuser)
    if anz > 0 
      btn = "menu-active"
    else
      btn = "menu-inactive"
    end

    pos = domain2.index("_")
    infosymbol = (domain2[pos+1..domain2.length-1]).to_sym
    
    case domain
      when "personen"
        html_string = '<class="dropdown-item">'
        html_string=""
        html_string = html_string + link_to(user_path(:id => item.id, :topic => domain2)) do
          content_tag(:i, " " + getinfo2(infosymbol)["infotext"], class:"fa fa-" + getinfo2(infosymbol)["info"]+" "+btn) 
        end
      when "institutionen"
        html_string = '<class="dropdown-item">'
        html_string = link_to(company_path(:id => item.id, :topic => domain2)) do
          content_tag(:i, " " + getinfo2(infosymbol)["infotext"], class:" fa fa-" + getinfo2(infosymbol)["info"]+" "+btn) 
        end
      when "objekte"
        html_string = '<class="dropdown-item">'
        html_string = link_to(mobject_path(:id => item.id, :topic => domain2)) do
          content_tag(:i, " " + getinfo2(infosymbol)["infotext"], class:" fa fa-" + getinfo2(infosymbol)["info"]+" "+btn) 
        end
      when "tabellen"
        html_string = '<class="dropdown-item">'
        html_string = link_to home_index9_path do
          content_tag(:i, " " + getinfo2(infosymbol)["infotext"], class:" fa fa-" + getinfo2(infosymbol)["info"]+" "+btn) 
        end
      when "editionen"
        html_string = '<class="dropdown-item">'
        html_string = link_to(mobject_path(:id => item.mobject_id, :topic => "objekte_ausgaben")) do
          content_tag(:i, " " + getinfo2(infosymbol)["infotext"], class:" fa fa-" + getinfo2(infosymbol)["info"]+" "+btn) 
        end
      when "edition"
        html_string = '<class="dropdown-item">'
        html_string = link_to(edition_path(:id => item.id)) do
          content_tag(:i, " " + getinfo2(infosymbol)["infotext"], class:" fa fa-" + getinfo2(infosymbol)["info"]+" "+btn) 
        end
      when "edition_artikel"
        html_string = '<class="dropdown-item">'
        html_string = link_to(edition_arcticles_path(:edition_id => item.id)) do
          content_tag(:i, " " + getinfo2(infosymbol)["infotext"], class:" fa fa-" + getinfo2(infosymbol)["info"]+" "+btn) 
        end
      when "edition_artikeln"
        html_string = '<class="dropdown-item">'
        html_string = link_to(edition_path(:id => item.id)) do
          content_tag(:i, " " + getinfo2(infosymbol)["infotext"], class:" fa fa-" + getinfo2(infosymbol)["info"]+" "+btn) 
        end
    end
  end
  #html_string = html_string + "<br><br>"
  return html_string.html_safe
end

def action_buttons4(object_type, item, topic)
  
  html_string = ''

  case object_type 
    when "kategorien"
      html_string = html_string + link_to(home_index9_path) do
        content_tag(:i, " " + (I18n.t :uebersicht), class: "btn btn-default fa fa-list")
      end
      html_string = html_string + link_to(new_mcategory_path(:ctype => item)) do
        content_tag(:i, " " + (I18n.t :kategorie) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus")
      end

    when "personen"
      case topic
        when "personen_info"
          #html_string = html_string + '<li class="nav-item">'
            html_string = html_string + link_to(users_path) do
              content_tag(:i, " " + (I18n.t :suchen), class:"btn btn-default fa fa-search") 
            end
          #html_string = html_string + '</li>'
          if user_signed_in? 
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
                #html_string = html_string + '<li class="nav-item">'
                  html_string = html_string + link_to(edit_user_path(item)) do
                    content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench")
                  end
                #html_string = html_string + '</li>'
                #html_string = html_string + '<li class="nav-item">'
                  html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher)})  do
                      content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red")
                  end
                #html_string = html_string + '</li>'
            end
            #html_string = html_string + '<li class="nav-item">'
              html_string = html_string + link_to(new_webmaster_path(:object_name => "User", :object_id => item.id, :user_id => current_user.id)) do
                content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange")
              end
            #html_string = html_string + '</li>'
            if false 
            if $activeapps.include?("personen_transaktionen") or isdeputy(item) or current_user.superuser
              #html_string = html_string + '<li class="nav-item">'
                html_string = html_string + link_to(listaccount_index_path(:user_id => current_user.id, :user_id_ver => item.id, :company_id_ver => nil, :ref => (I18n.t :verguetungan)+item.name + " " + item.lastname, :object_name => "User", :object_id => item.id, :amount => nil)) do
                  content_tag(:i, " " + (I18n.t :trx), class: "btn btn-default fa fa-euro")
                end
              #html_string = html_string + '</li>'
            end
            end
            if $activeapps.include?("personen_mappositionen") or isdeputy(item) or current_user.superuser
              #html_string = html_string + '<li class="nav-item">'
                html_string = html_string + link_to(new_user_position_path(:user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :pos), class: "btn btn-default fa fa-map-marker")
                end
              #html_string = html_string + '</li>'
            end
            if $activeapps.include?("personen_mappositionenfavoriten") or isdeputy(item) or current_user.superuser
              #html_string = html_string + '<li class="nav-item">'
                html_string = html_string + link_to(new_favourit_path(:object_name => "User", :object_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :fav), class: "btn btn-default fa fa-user")
                end
              #html_string = html_string + '</li>'
            end
          end

        when "personen_notizen"
          if user_signed_in?
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              #html_string = html_string + '<li class="nav-item">'
                html_string = html_string + link_to(new_note_path(:user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange") 
                end
              #html_string = html_string + '</li>'
              #html_string = html_string + '<li class="nav-item">'
                html_string = html_string + link_to(user_path(:user_id => current_user.id, :topic => @topic, :delusernotes => true),data: { confirm: 'Are you sure?' }) do
                  content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash orange") 
                end
              #html_string = html_string + '</li>'
            end
          end

        when "personen_institutionen"
          html_string = html_string + link_to(companies_path) do
            content_tag(:i, " " + (I18n.t :institutionenuebersicht), class: "btn btn-default fa fa-copyright-mark")
          end
          if user_signed_in?
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_company_path(:user_id => current_user.id)) do
                content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange") 
              end
            end
          end

        when "personen_kalendereintraege"
          if user_signed_in?
            html_string = html_string + link_to(new_appointment_path(:user_id1 => item.id, :user_id2 => current_user.id))  do
              content_tag(:i, " " + (I18n.t subtopic(@topic) + " " + (I18n.t :hinzufuegen)), class: "btn btn-primary fa fa-plus orange")
            end
          end

        when "personen_angebote", "personen_vermietungen", "personen_veranstaltungen", "personen_ausflugsziele", "personen_ausschreibungen", "personen_publikationen", "personen_artikel", "personen_umfragen", "personen_projekte", "personen_gruppen", "personen_innovationswettbewerbe", "personen_sensoren","personen_kleinanzeigen", "personen_stellenanzeigen", "personen_crowdfunding"
          html_string = html_string + link_to(mobjects_path :mtype => getTopicName(topic)) do
            content_tag(:i, " " + (I18n.t subtopic(topic).to_sym) + " " + (I18n.t :suchen), class: "btn btn-default fa fa-search")
          end
          if user_signed_in?
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_mobject_path(:user_id => current_user.id, :mtype => subtopic(topic), :msubtype => nil)) do
                content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange")
              end
            end
            if topic == "personen_projekte"
              if current_user.id == item.id or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(user_path(:id => @user.id, :topic => "personen_export")) do
                  content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :exportieren), class: "btn btn-default fa fa-download")
                end
              end
            end
          end

        when "personen_export"
          if user_signed_in?
            html_string = html_string + link_to(user_path(:id => @user.id, :topic => topic, :year => @c_year, :month => @c_month, :mode => @c_mode, :topic => topic, :writeexcel => true)) do
              content_tag(:i, " " + (I18n.t :excel), class: "btn btn-default fa fa-th")
            end
          end

        when "personen_emails"
          if user_signed_in?
            html_string = html_string + link_to(new_email_path(:m_from_id => current_user.id, :m_to_id => item.id, :back_url => request.original_url)) do
              content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange")
            end
          end

        when "personen_tickets"
          if user_signed_in?
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(ticketuserview_index2_path(:user_id => item.id)) do
                content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange")
              end
            end
          end

        when "personen_stellvertretungen"
             if user_signed_in?
              if (item.id == current_user.id) or current_user.superuser
                html_string = html_string + link_to(deputies_path(:user_id => item.id)) do
                  content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange")
                end
              end
             end

        when "personen_zeiterfassung"
             if user_signed_in?
              if (item.id == current_user.id) or current_user.superuser
                html_string = html_string + link_to(new_timetrack_path(:user_id => @user.id, :scope => "aufwand", :datum => @c_datum)) do
                  content_tag(:i, " " + (I18n.t :aufwand) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange")
                end
                html_string = html_string + link_to(new_timetrack_path(:user_id => @user.id, :scope => "kosten", :datum => @c_datum)) do
                  content_tag(:i, " " + (I18n.t :kosten) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange")
                end
              end
             end

      end

    when "institutionen"
      case topic
        when "institutionen_info"
          html_string = html_string + link_to(companies_path(:page => session[:page]), title: (I18n.t :institutionen)) do
            content_tag(:i, " " + (I18n.t :suchen), class:"btn btn-default fa fa-search") 
          end
          if user_signed_in?
            if current_user.id == item.user_id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(edit_company_path(item), title: (I18n.t :bearbeiten)) do
                content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench")
              end
              html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher) }) do
                  content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red")
              end
            end
            html_string = html_string + link_to(new_webmaster_path(:object_name => "Company", :object_id => item.id, :user_id => current_user.id)) do
              content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange")
            end
            if $activeapps.include?("institutionen_favoriten") or current_user.superuser
              if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(new_favourit_path(:object_name => "Company", :object_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :fav), class: "btn btn-default fa fa-heart")
                end
              end
            end
            if false
            if $activeapps.include?("institutionen_transaktionen") or current_user.superuser
              if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(listaccount_index_path :user_id => current_user.id, :user_id_ver => nil, :company_id_ver => item.id, :ref => (I18n.t :verguetungan)+item.name, :object_name => "Company", :object_id => item.id, :amount => nil) do
                  content_tag(:i, " " + (I18n.t :trx), class: "btn btn-default fa fa-euro")
                end
              end
            end
            end
          end

        when "institutionen_angebote", "institutionen_kampagnen", "institutionen_standorte", "institutionen_vermietungen", "institutionen_veranstaltungen", "institutionen_ausflugsziele", "institutionen_ausschreibungen", "institutionen_publikationen", "institutionen_umfragen", "institutionen_projekte", "institutionen_innovationswettbewerbe", "institutionen_sensoren", "institutionen_kleinanzeigen", "institutionen_stellenanzeigen", "institutionen_crowdfunding"
          html_string = html_string + link_to(mobjects_path :mtype => getTopicName(topic)) do
            content_tag(:i, " " + (I18n.t subtopic(topic).to_sym) + " " + (I18n.t :suchen), class: "btn btn-default fa fa-search")
          end
          if user_signed_in?
            if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_mobject_path :company_id => item.id, :mtype => subtopic(topic), :msubtype => nil) do
                content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange")
              end
            end
            if topic == "institutionen_projekte"
              if current_user.id == item.id or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(company_path(:id => @company.id, :topic => "institutionen_export")) do
                  content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :exportieren), class: "btn btn-default fa fa-download")
                end
              end
            end
          end
          
        when "institutionen_partnerlinks"
          if user_signed_in?
            if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_partner_link_path :company_id => item.id) do
                content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-default fa fa-plus orange")
              end
            end
          end

        when "institutionen_stellvertretungen"
             if user_signed_in?
              if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(deputies_path(:company_id => item.id)) do
                  content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class:"btn btn-default fa fa-plus orange")
                end
              end
             end

        when "institutionen_export"
          if user_signed_in?
            html_string = html_string + link_to(company_path(:id => @company.id, :year => @c_year, :month => @c_month, :mode => @c_mode, :topic => topic, :writeexcel => true)) do
              content_tag(:i, " " + (I18n.t :excel), class: "btn btn-default fa fa-th")
            end
          end

            
      end

    when "objekte"
       case topic
          when "objekte_info"
             html_string = html_string + link_to(mobjects_path(:mtype =>item.mtype)) do
              content_tag(:i, " "+ (I18n.t :suchen), class:"btn btn-default fa fa-search") 
             end

            if false 
             if session[:edition_id]
               html_string = html_string + link_to(edition_path(:id => session[:edition_id], :topic => "objekte_info")) do
                content_tag(:i, " " + (I18n.t :edition), class:"btn btn-default fa fa-book") 
               end
             end 
             end
             
             if item.parent and item.parent > 0 
                html_string = html_string + link_to(mobject_path(:id => item.parent, :mtype => "projekte", :msubtype => nil, :topic => "objekte_info")) do
                  content_tag(:i, " " + (I18n.t :edition), class:"btn btn-default fa fa-level-up") 
                end
             end 

             if item.mtype == "innovationswettbewerbe"
              if user_signed_in?
                html_string = html_string + link_to(new_idea_path(:mobject_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :ideen), class:"btn btn-primary fa fa-plus orange") 
                end
              end
             end

             if user_signed_in?
               if isowner(item) or isdeputy(item.owner)
         	        html_string = html_string + link_to(edit_mobject_path(item), title: (I18n.t :bearbeiten)) do
                    content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench")
                  end
               end
               if isowner(item)
         	        html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher) } ) do
                    content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red")
                   end
               end
               html_string = html_string + link_to(new_webmaster_path(:object_name => "Mobject", :object_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange")
               end
             end

          when "objekte_details"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(new_mdetail_path(:mobject_id => item.id, :mtype => "details")) do
                    content_tag(:i, " " + (I18n.t :details) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus") 
                  end
               end
              end

          when "objekte_substruktur"
             if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  if item.owner_type == "User"
                    html_string = html_string + link_to(new_mobject_path :user_id => item.owner_id, :mtype => "projekte", :msubtype => nil, :parent => item.id) do
                      content_tag(:i, " " + (I18n.t :substruktur)+ " " + (I18n.t :hinzufuegen), class:"btn btn-default fa fa-plus orange") 
                    end
                  end
                  if item.owner_type == "Company"
                    html_string = html_string + link_to(new_mobject_path :company_id => item.owner_id, :mtype => "projekte", :msubtype => nil, :parent => item.id) do
                      content_tag(:i, " " + (I18n.t :substruktur) + " " + (I18n.t :hinzufuegen), class:"btn btn-default fa fa-plus orange") 
                    end
                  end
               end
              end

          when "objekte_signcal"
            if user_signed_in?
              if isowner(item) or isdeputy(item.owner)
                if @mobject.mtype == "kampagnen"
                  html_string = html_string + link_to(new_signage_cal_path(:kam_id => @mobject.id)) do
                      content_tag(:i, " " + (I18n.t :standorte), class:"btn btn-primary fa fa-plus orange") 
                  end
                end
                if @mobject.mtype == "standorte"
                  html_string = html_string + link_to(new_signage_cal_path(:loc_id => @mobject.id)) do
                      content_tag(:i, " " + (I18n.t :kampagnen), class:"btn btn-primary fa fa-plus orange") 
                  end
                end
              end
            end

          when "objekte_ideen"
              if user_signed_in?
                html_string = html_string + link_to(new_idea_path(:mobject_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :ideen) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                end
              end

          when "objekte_preise"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(new_price_path(:mobject_id => item.id)) do
                      content_tag(:i, " " + (I18n.t :preise) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                  end
               end
              end

          when "objekte_bewertungskriterien"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(new_crit_path(:mobject_id => item.id)) do
                      content_tag(:i, " " + (I18n.t :bewertungskriterien) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                  end
                end
              end

          when "objekte_projektberechtigungen", "objekte_gruppenmitglieder", "objekte_jury", "objekte_ansprechpartner"
             if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(madvisors_path :user_id => item.owner_id, :mobject_id => item.id, :role => item.mtype) do
                      content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                  end
               end
              end

          when "objekte_ausschreibungsangebote"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(new_mdetail_path(:mobject_id => item.id, :mtype => "objekte_ausschreibungsangebote")) do
                      content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                  end
               end
              end

          when "objekte_sensordaten"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(mobject_path(:mobject_id => item.id, :topic => "objekte_sensordaten", :delsensordata => true), data: { confirm: (I18n.t :sindsiesicher) }) do
                      content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :loeschen), class:"btn btn-danger fa fa-trash red") 
                  end
                  html_string = html_string + link_to(new_sensor_path(:mobject_id => item.id)) do
                      content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                  end
               end
              end

          when "objekte_eintrittskarten"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(new_ticket_path(:mobject_id => item.id)) do
                    content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"fa fa-plus orange") 
                end
               end
              end

          when "objekte_fragen"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(new_question_path(:mobject_id => item.id)) do
                      content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                  end
               end
              end
              
          when "objekte_ausgaben"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(new_edition_path(:mobject_id => item.id)) do
                      content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
                  end
               end
              end

          when "objekte_sponsorenengagements"
            if user_signed_in?
              html_string = html_string + link_to(new_msponsor_path(:mobject_id => item.id)) do
                content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
              end
            end
            
          when "objekte_blog"
            if user_signed_in?
    	        html_string = html_string + link_to(new_comment_path :mobject_id => item.id, :user_id => current_user.id) do
                content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
              end
            end
            
          when "objekte_bewertungen"
            if user_signed_in?
    	        html_string = html_string + link_to(new_mrating_path :mobject_id => item.id, :user_id => current_user.id) do
                content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
              end
            end
            
          when "objekte_kalendervermietungen"
            if user_signed_in?
              html_string = html_string + link_to(new_mcalendar_path(:user_id => current_user.id, :mobject_id => item.id)) do
                content_tag(:i, " " + (I18n.t getTopicName(topic).to_sym) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
              end
            end
            
          when "objekte_cftransaktionen"
              html_string = html_string + link_to(new_mstat_path(:mobject_id => item.id, :dontype => "user")) do
                content_tag(:i, " " + (I18n.t :persoenlich) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-user orange") 
              end
              html_string = html_string + link_to(new_mstat_path(:mobject_id => item.id, :dontype => "company")) do
                content_tag(:i, " " + (I18n.t :firmen) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-copyright-mark orange") 
              end

          when "objekte_auftragscontrolling"
            if user_signed_in?
              html_string = html_string + link_to(mobject_path(:id => @mobject.id, :topic => "objekte_auftragscontrolling", :year => @c_year, :month => @c_month, :mode => @c_mode, :scope => @c_scope, :export => true)) do
                content_tag(:i, " " + (I18n.t :excel), class:"btn btn-default fa fa-book") 
              end
              if @export and @filename
    	          html_string = html_string +link_to(@filename.remove("public")) do
                  content_tag(:i, " " + (I18n.t :download) , class:"btn btn-default fa fa-download") 
                end
              end

            end

      end

      when "editionen"
         #html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => "objekte_ausgaben"), title: (I18n.t :editionen)) do
          #  content_tag(:i, " " + (I18n.t :editionen) + " " + (I18n.t :hinzufuegen), class:"fa fa-list") 
         #end

      when "edition"
         html_string = html_string + link_to(edition_path(:id => item.id, :topic => "edition")) do
            content_tag(:i, " " + (I18n.t :editionen) + " " + (I18n.t :aendern), class:"btn btn-primary fa fa-wrench") 
         end

      when "ideenbewertung"
         html_string = html_string + link_to(mobject_path(:id => item.mobject.id, :topic => "objekte_ideen")) do
            content_tag(:i, " " + (I18n.t :ideen) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-list") 
         end

      when "crowdideenbewertung"
         html_string = html_string + link_to(mobject_path(:id => item.mobject.id, :topic => "objekte_ideen")) do
            content_tag(:i, " " + (I18n.t :ideenbewertung) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-list") 
         end
         if user_signed_in?
          html_string = html_string + link_to(new_idea_crowdrating_path(:idea_id => item.id, :user_id => current_user.id)) do
            content_tag(:i, " " + (I18n.t :editionen) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
          end
        end

      when "artikeledition"
         html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => "objekte_ausgaben")) do
            content_tag(:i, " " + (I18n.t :zurueckzurausgabe), class:"btn btn-default fa fa-list") 
         end
         if user_signed_in?
          if isowner(item) or isdeputy(item.owner)
            html_string = html_string + link_to(mobjects_path(:mtype => "artikel", :edition_id => item.id)) do
              content_tag(:i, " " + (I18n.t :artikel) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
            end
          end
         end

      when "edition_artikeln"
         if user_signed_in?
          if isowner(item.mobject) or isdeputy(item.mobject.owner)
            html_string = html_string + link_to(mobjects_path(:mtype => "artikel", :edition_id => item.id)) do
              content_tag(:i, " " + (I18n.t :artikel) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange") 
            end
          end
         end
        
  end
  return html_string.html_safe
end

def getinfo2(topic)
  
  info = "question_mark"
  if I18n.t topic
    infotext = (I18n.t topic)
  else
    infotext = "unbekannt"
  end

  case topic
    when :notizen
      info = "paperclip"
    when :stellvertretungen
      info = "share"
    when :signstat
      info = "signal"
    when :signlocshow, :signkamshow
      info = "film"
    when :signcal
      info = "calendar"
    when :projekte
      info = "tasks"
    when :institutionen
      info = "industry"
    when :zeiterfassung
      info = "safari"
    when :ressourcenplanung
      info = "first-order"
    when :gruppen
      info = "th"
    when :zugriffsberechtigungen, :projektberechtigungen
      info = "lock"
     when :news
      info = "alert"
    when :personen, :geburtstage, :ansprechpartner, :anmeldungen, :gruppenmitglieder, :umfrageteilnehmer, :teilnehmerveranstaltung, :kalendergeburtstage
      info = "user"
    when :vermietungen
      info = "retweet"
    when :sensoren, :sensordaten
      info = "thermometer"
    when :ausschreibungen, :kalenderausschreibungen
      info = "pencil"
    when :publikationen, :kalenderpublikationen, :ausgaben, :ausgabe
      info = "book"
    when :artikel
      info = "font"
    when :umfragen, :fragen, :meineabfragen
      info = "question-circle"
    when :innovationswettbewerbe
      info = "cog"
    when :veranstaltungen, :kalenderveranstaltungen
      info = "glass"
    when :ausflugsziele
      info = "camera"
    when :werbeflaechen
      info = "blackboard"
    when :angebote
      info = "shopping-cart"
    when :angebotestandard
      info = "ban"
    when :angeboteaktion, :aktionen, :kalenderaktionen
      info = "exclamation-sign"
    when :stellenanzeigen, :kalenderstellenanzeigen
      info = "briefcase"
    when :kleinanzeigen
      info = "clipboard"
    when :stellenanzeigensuchen, :kleinanzeigensuchen, :details
      info = "search"
    when :stellenanzeigenanbieten, :kleinanzeigenanbieten
      info = "filter"
    when :crowdfunding, :kalendercrowdfunding
      info = "share"
    when :crowdfundingspenden
      info = "gift"
    when :crowdfundingbelohnungen, :tickets
      info = "qrcode"
    when :crowdfundingzinsen
      info = "signal"
    when :kalender, :kalendereintraege, :kalender, :kalendervermietungen
      info = "calendar"
    when :ideen, :einstellungen
      info = "cog"
    when :crowdfundingbeitraege, :transaktionen, :cftransaktionen, :charges
      info = "euro"
    when :bewertungen
      info = "star"
    when :favoriten, :sponsorenengagements
      info = "heart"
    when :kundenbeziehungen
      info = "check"
    when :emails
      info = "envelope"
    when :zugriffsberechtigungen, :projektberechtigungen
      info = "lock"
    when :kampagnen, :dskampagnen
      info = "bullhorn"
    when :dsstandorte
      info = "blackboard"
    when :jury
      info = "education"
    when :preise
      info = "gift"
    when :bewertungskriterien
      info = "pencil"
    when :projektdashboard, :aktivitaeten, :cfstatistik
      info = "dashboard"
    when :auftragscontrolling
      info = "cube"
    when :substruktur
      info = "cog"
    when :fragen
      info = "question-sign"
    when :ausgaben
      info = "dublicate"
    when :blog
      info = "comment"
    when :tickets, :eintrittskarten
      info = "barcode"
    when :show
      info = "film"
    when :kontobeziehungen
      info = "film"
    when :mappositionen, :mappositionenfavoriten, :standorte
      info = "map-marker"
    when :partnerlinks
      info = "globe"
    when :ausschreibungsangebote
      info = "book"
    when :berechtigungen
      info = "lock"
    when :kategorien
      info = "folder-open"
    when :info
      info = "bookmark"
  end
  ret = Hash.new
  ret = {"info" => info, "infotext" => infotext}
  return ret
end

def build_services

    html_string = ""
    html_string = html_string + '<div class="container"><div class="row">'
    html_string = html_string + '<div class="col-md-12 text-center">'
    html_string = html_string + '<h2 class="service-title pad-bt15">Unser Serviceportfolio</h2>'
    html_string = html_string + '<p class="sub-title pad-bt15">folgende Services sind aktuell verfügbar.</p>'
    html_string = html_string + '<hr class="bottom-line">'
    html_string = html_string + '</div>'

    if user_signed_in?  
      init_apps
      creds = getUserCreds
    else
      creds = init_apps
    end

    domain = "zeiterfassung"
    if user_signed_in? and creds.include?("personen_zeiterfassung")
        path = user_path(:id => current_user.id, :topic => "personen_zeiterfassung")
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "personen"
    if creds.include?("hauptmenue_"+domain)
        path = users_path(:mtype => nil, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end
    
    domain = "institutionen"
    if creds.include?("hauptmenue_"+domain)
        path = companies_path(:mtype => nil, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "angebote"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "projekte"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => "root", :parent => 0)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "umfragen"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "innovationswettbewerbe"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "publikationen"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "artikel"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => "artikel", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "standorte"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => "standorte", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "kampagnen"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => "kampagnen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "veranstaltungen"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "sensoren"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "ausflugsziele"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "kleinanzeigen"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "stellenanzeigen"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "vermietungen"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => "vermietungen", :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "ausschreibungen"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "crowdfunding"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => nil)
        html_string = html_string + simple_menue(domain, path)
    end

    html_string = html_string + '</div></div>'

    return html_string.html_safe
    
end

def build_myservices

    html_string = ""

    creds = init_apps
    if user_signed_in?  
      creds = getUserCreds
    end
    
    domains = []
    domains << "zeiterfassung"
    domains << "personen"
    domains << "institutionen"
    domains << "angebote"
    domains << "projekte"
    domains << "umfragen"
    domains << "innovationswettbewerbe"
    domains << "publikationen"
    domains << "artikel"
    domains << "standorte"
    domains << "kampagnen"
    domains << "veranstaltungen"
    domains << "sensoren"
    domains << "ausflugsziele"
    domains << "kleinanzeigen"
    domains << "stellenanzeigen"
    domains << "vermietungen"
    domains << "ausschreibungen"
    domains << "crowdfunding"
    
    html_string = html_string + '<div class="container"><div class="row">'

    html_string = html_string + '<h2 class="service-title pad-bt15">myServices</h2>'
    html_string = html_string + '<hr class="bottom-line">'
    html_string = html_string + '</div>'

    for i in 0..domains.count-1 do
      if user_signed_in? and creds.include?("hauptmenue_"+domains[i])
          path = user_path(:id => current_user.id, :topic => "personen_"+domains[i])

          html_string = html_string + '<div class="col-md-4 col-sm-6 col-xs-12">'
            html_string = html_string + '<div class="service-item">'
              html_string = html_string + '<h3><span>'
              html_string = html_string + link_to(path) do
                content_tag(:i, nil, class:"fa fa-" + getinfo2(domains[i].to_sym)["info"]) 
              end
              html_string = html_string + '</span>'+domains[i]+'</h3>'
              html_string = html_string + '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>'
            html_string = html_string + '</div>'
            
          html_string = html_string + '</div>'

      end
    end

    html_string = html_string + '</div></div>'
    
    return html_string.html_safe
    
end

def simple_menue (domain, path)
  html_string= ""
  html_string = html_string + '<div class="col-md-4 col-sm-6 col-xs-12">'
    html_string = html_string + '<div class="service-item">'
      html_string = html_string + link_to(path) do
        content_tag(:i, nil, class:"fa fa-" + getinfo2(domain.to_sym)["info"], style:"font-size:2em") 
      end
      html_string = html_string + " " + domain.upcase
      #html_string = html_string + '<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>'
    html_string = html_string + '</div>'
  html_string = html_string + '</div>'
  return html_string.html_safe
end

def build_kachel_access(topic, mode, user)

  html_string = ""
  
  html_string = html_string + '<table class="table table-striped>"'
  
  appparams = Appparam.where('domain=?',topic)
  appparams.each do |a|
  
    if mode == "system"
      if a.access
          thumbnail_state = 'fa fa-check ac'
        else
          thumbnail_state = 'fa fa-ban noac'
      end
      cpath = appparams_path(:id => a.id)
    end

    if mode == "user"
      @credential = user.credentials.where('appparam_id=?',a.id).first
      if !@credential
          @cred = Credential.new
          @cred.appparam_id = a.id
          @cred.user_id = user.id
          @cred.access = a.access
          @cred.save
          @credential = user.credentials.where('appparam_id=?',a.id).first
      end
      if @credential.access
          thumbnail_state = 'fa fa-check ac'
        else
          thumbnail_state = 'fa fa-ban noac'
      end
      cpath = user_path(:id => @credential.user_id, :credential_id => @credential.id, :topic => "personen_zugriffsberechtigungen")
    end
    
    html_string = html_string + "<tr>"
      
        if false
        html_string = html_string + link_to(cpath) do
          content_tag(:div, nil, class:"col-xs-4 col-sm-4 col-md-3 col-lg-2") do 
            content_tag(:div, nil, class:"thumbnail " + thumbnail_state, align:"center") do
              content_tag(:span, nil) do
                info_size = "4"
                content_tag(:i, nil, class:"fa fa-" + getinfo2(a.right.to_sym)["info"], style:"font-size:" + info_size + "em") + content_tag(:small_cal, "<br>".html_safe + (I18n.t a.right))
              end
            end
          end
        end
        end

      html_string = html_string + "<td>"
        html_string = html_string + link_to(cpath) do
          content_tag(:i, nil, class: thumbnail_state)
        end
      html_string = html_string + "</td>"
      html_string = html_string + "<td>"
          info_size = "1"
          html_string = html_string + content_tag(:i, nil, class: "fa fa-" + getinfo2(a.right.to_sym)["info"], style:"font-size:" + info_size + "em") + " " + content_tag(:small_cal, (I18n.t a.right))
      html_string = html_string + "</td>"
      
    html_string = html_string + "</tr>"

  end    
  html_string = html_string + "</table>"
  return html_string.html_safe
end

def image_def (objekt, mtype, msubtype)
    case objekt
      when $app_name
        pic = "connect.jpg"
      when "personen"
        pic = "user.jpg"
      when "institutionen"
        pic = "company.jpg"
      when "objekte"
        pic = "no_pic.jpg"
    end
end

def url_with_protocol(url)
    /^http/i.match(url) ? url : "http://#{url}"
end

def avg_rating2(mobject)
    rat = Mrating.where("mobject_id=?", mobject).average(:rating)
    if rat != nil
        return rat.round
    else
        return 0
    end
end

def AktionDatum2(datum, mobject)
    if datum >= mobject.date_from and datum <= mobject.date_to
        return true
    else
        return false
    end
end

def init_apps

  apps = Appparam.all
  if !apps or apps.count==0
  
    @array = []

    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "news", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "personen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "institutionen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "angebote", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "vermietungen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "ausschreibungen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "stellenanzeigen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "veranstaltungen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "ausflugsziele", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "kleinanzeigen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "publikationen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "artikel", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "innovationswettbewerbe", "access" => false, "info" => "payable", "fee" => 500}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "umfragen", "access" => false, "info" => "payable", "fee" => 300}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "projekte", "access" => true, "info" => "payable", "fee" => 700}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "sensoren", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "crowdfunding", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "standorte", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "kampagnen", "access" => false, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "kalender", "access" => false, "info" => "news", "fee" => 0}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "personen", "right" => "info", "access" => true, "info" => "news"}
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "notizen", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "kalendereintraege", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "angebote", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "ansprechpartner", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "institutionen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "stellenanzeigen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "kleinanzeigen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "vermietungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "veranstaltungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "sensoren", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "anmeldungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "tickets", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "ausflugsziele", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "ausschreibungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "innovationswettbewerbe", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "ideen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "crowdfunding", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "crowdfundingbeitraege", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "bewertungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "favoriten", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "gruppen", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "publikationen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "artikel", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "umfragen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "projekte", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "zeiterfassung", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "ressourcenplanung", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "kundenbeziehungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "kontobeziehungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "transaktionen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "emails", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "mappositionen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "mappositionenfavoriten", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "aktivitaeten", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "charges", "access" => true, "info" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "info", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "angebote", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "stellenanzeigen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "kleinanzeigen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "vermietungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "veranstaltungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "sponsorenengagements", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "ausflugsziele", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "ausschreibungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "innovationswettbewerbe", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "crowdfunding", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "crowdfundingbeitraege", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "publikationen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "umfragen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "sensoren", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "projekte", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "kundenbeziehungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "kontobeziehungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "transaktionen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "emails", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "favoriten", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "partnerlinks", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "aktivitaeten", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "standorte", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "kampagnen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "charges", "access" => true, "info" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "info", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "details", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "eintrittskarten", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "sponsorenengagements", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "ansprechpartner", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "projektberechtigungen", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "auftragscontrolling", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "ressourcenplanung", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "projektdashboard", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "kalender", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "teilnehmerveranstaltung", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "ausschreibungsangebote", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "bewertungen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "blog", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "fragen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "umfrageteilnehmer", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "jury", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "preise", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "ideen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "bewertungskriterien", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "gruppenmitglieder", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "substruktur", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "ausgaben", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "cfstatistik", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "cftransaktionen", "access" => false, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "sensordaten", "access" => true, "info" => "news"}
    @array << hash
    
    for i in 0..@array.length-1
      c = Appparam.new
      c.domain = @array[i]["domain"]
      if @array[i]["parent_domain"]
        c.parent_domain = @array[i]["parent_domain"]
      else
        c.parent_domain = "root"
      end
      c.right = @array[i]["right"]
      c.info = @array[i]["info"]
      c.access = @array[i]["access"]
      if @array[i]["domain"] == "hauptmenue"
        c.fee = @array[i]["fee"]
      else
        c.fee = 0
      end
      c.save
    end
    apps = Appparam.all
  end

  $activeapps = []
  apps.each do |a|
    $activeapps << a.domain+"_"+a.right if a.access
  end
  
  return $activeapps

end

def init_credentials
  @appparams = Appparam.all
  @appparams.each do |a|
    if a.access
      c = Credential.new
      c.user_id = current_user.id
      c.appparam_id = a.id
      c.access = a.access
      c.save
    end
  end
end

def getUserCreds
  credapps = []
  if current_user.superuser
    appparams = Appparam.all
    appparams.each do |a|
      credapps << a.domain+"_"+a.right
    end
  else  
    creds = current_user.credentials
    if !creds or creds.count==0
      init_credentials
    end
    creds.each do |c|
      if $activeapps.include?(c.appparam.domain+"_"+c.appparam.right)
        credapps << c.appparam.domain+"_"+c.appparam.right if c.access
      end
    end
  end
  return credapps
end

def buildQRCode(content)
  qr = RQRCode::QRCode.new(content, size: 12, :level => :h)
  qr_img = qr.to_img
  qr_img.resize(200, 200).save("ticketqrcode.png")
  img = File.open("ticketqrcode.png")
end

def build_article(article)
  
  if !article.mdetails or article.mdetails.count == 0
    return
  end
  
  html_string = ""
  html_string = html_string + "<div class='row'>"

    article.mdetails.where('textoptions !=? and textoptions !=?', "blog", "bewertung").order(:sequence).each do |d|
        html_string = html_string + "<div class='col-xs-12 col-sm-6 col-md-6 col-lg-4 xl-4'>"
          html_string = html_string + "<div class='row'>"
          if d.avatar_file_name
            html_string = html_string + "<div class='col-xs-6 col-sm-6 col-md-6 col-lg-6'>"
              html_string = html_string + showImage2(:medium, d, false)
            html_string = html_string + "</div>"
            html_string = html_string + "<div class='col-xs-6 col-sm-6 col-md-6 col-lg-6'>"
              if d.name 
                html_string = html_string + "<h2>" + d.name + "</h2><br><br>"
              end
            html_string = html_string + "</div>"
          else
            html_string = html_string + "<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12'>"
              if d.name 
                html_string = html_string + "<h2>"+d.name + "</h2><br><br>"
              end 
            html_string = html_string + "</div>"
          end
          html_string = html_string + "<br>"
          
          case d.textoptions
            when "zitat"
              html_string = html_string + '<zitat>"' + d.description + '"</zitat>'
            when "link"
              html_string = html_string + link_to(url_with_protocol(d.description), target: "_blank") do
                content_tag(:div, d.description)
              end

            when "abstimmung"
                html_string = html_string + "<div class='panel'>"
                  if user_signed_in?
                    @url = url_for(action: action_name, controller: controller_name)
                    html_string = html_string + link_to(new_mlike_path :mobject_id => article.id, :user_id => current_user.id, :like => true, :return_url => @url) do
                      content_tag(:span, content_tag(:b, "Ja")+content_tag(:span, article.mlikes.where('likeit=?',true).count.to_s, class:"badge"), class:"btn btn-primary fa fa-thumbs-up")
                    end
                    html_string = html_string + link_to(new_mlike_path :mobject_id => article.id, :user_id => current_user.id, :like => false, :return_url => @url) do
                      content_tag(:span, content_tag(:b, "Nein")+content_tag(:span, article.mlikes.where('likeit=?',false).count.to_s, class:"badge"), class:"btn btn-primary fa fa-thumbs-down")
                    end
                  else
                      html_string = html_string + content_tag(:i, nil, class:"fa fa-thumbs-up") + content_tag(:span, article.mlikes.where('likeit=?',true).count.to_s, class:"badge")
                      html_string = html_string + content_tag(:i, nil, class:"fa fa-thumbs-down") + content_tag(:span, article.mlikes.where('likeit=?',false).count.to_s, class:"badge")
                  end
                html_string = html_string + "</div>"
              
            when "text"
              html_string = html_string + d.description
          end
          
          if d.document_file_name
            html_string = html_string + "<br>Download Link "
            html_string = html_string + link_to(d.document.url, target: "_blank") do
              content_tag(:i, nil, class:'btn btn-primary btn-xs fa fa-cloud-download')
            end
          end
          html_string = html_string + "</div><br>"
      html_string = html_string + "</div>"
  end
  html_string = html_string + "</div>"

#return html_string.html_safe

  html_string = html_string + "<div class='row'>"
    article.mdetails.where('textoptions=? or textoptions=?', "blog", "bewertung").order(:sequence).each do |d|
        case d.textoptions
          when "bewertung"
                html_string = html_string + "<div class='panel' id='accordionB"+article.id.to_s+"' role='tablist' aria-multiselectable='true'>"
                  html_string = html_string + "<a role='button' data-toggle='collapse' data-parent='#accordionB"+article.id.to_s+"' href='#collapseTwoB"+article.id.to_s+"' aria-expanded='true' aria-controls='collapseOne'>"
                    html_string = html_string + "<i class='fa fa-chevron-down'> </i>"+ d.name
                    if user_signed_in?
                      html_string = html_string + link_to(new_mrating_path(:mobject_id => article.id, :user_id => current_user.id)) do
                        content_tag(:i, content_tag(:i," bewerten"), class:"btn btn-primary fa fa-star")
                      end
                    end
                  html_string = html_string + "</a>"
                  html_string = html_string + "<div id='collapseTwoB"+article.id.to_s+"' class='panel-collapse collapse' role='tabpanel' aria-labelledby='headingOne'>"
                    html_string = html_string + build_medialistNew(article.mratings.order(created_at: :desc), "mratings", "user")
                  html_string = html_string + "</div>"
                html_string = html_string + "</div>"

          when "blog"
                html_string = html_string + "<div class='panel' id='accordionG"+article.id.to_s+"' role='tablist' aria-multiselectable='true'>"
                  html_string = html_string + "<a role='button' data-toggle='collapse' data-parent='#accordionG"+article.id.to_s+"' href='#collapseTwoG"+article.id.to_s+"' aria-expanded='true' aria-controls='collapseOne'>"
                    html_string = html_string + "<i class='fa fa-chevron-down'> </i>" + d.name                      
                    if user_signed_in?
                      html_string = html_string + link_to(new_comment_path(:mobject_id => article.id, :user_id => current_user.id)) do
                        content_tag(:i, content_tag(:i," kommentieren"), class:"btn btn-primary fa fa-comment")
                      end
                    end
                  html_string = html_string + "</a>"
                    html_string = html_string + "<div id='collapseTwoG"+article.id.to_s+"' class='panel-collapse collapse' role='tabpanel' aria-labelledby='headingOne'>"
                      html_string = html_string + build_medialistNew(article.comments.order(created_at: :desc), "comments", "user")
                    html_string = html_string + "</div>"
                html_string = html_string + "</div>"
        end
    end

  html_string = html_string + "</div>"
  return html_string.html_safe
end 


def build_questionaire(questionaire)
  html_string = "<div class=panel-body>"
  
    html_string = html_string + "<div class='row'>"
      html_string = html_string + "<div class='col-xs-3 col-sm-3 col-md-3 col-lg-3 xl-3'>"
        html_string = html_string + showFirstImage2(:medium, questionaire, questionaire.mdetails)
      html_string = html_string + "</div>"
      
      html_string = html_string + "<div class='col-xs-9 col-sm-9 col-md-9 col-lg-9 xl-9'>"

        html_string = html_string + "<div class='row'>"
          html_string = html_string + contactChip(questionaire.owner)
        html_string = html_string + "</div>"
        html_string = html_string + "<br><br>"
          
        html_string = html_string + "<div class='row'>"
          html_string = html_string + "<inhalt>Inhalt</inhalt>"
          html_string = html_string + "<br><br>"
        html_string = html_string + "</div>"
        questionaire.questions.order(:sequence).each do |q|
          html_string = html_string + "<div class='row'>"

            #html_string = html_string + "<div class='col-xs-3 col-sm-3 col-md-3 col-lg-3 xl-3'>"
            # if current_user.user_answers.answers.where('question_id=?',q.id).count > 0
            #   html_string = html_string + '<i class="fa fa-check"></i>'              
            # else
            #   html_string = html_string + '<i class="fa fa-edit"></i>'
            # end
            #html_string = html_string + "</div>"
            #html_string = html_string + "<div class='col-xs-9 col-sm-9 col-md-9 col-lg-9 xl-9'>"
              html_string = html_string + link_to(home_index15_path(:question_id => q.id)) do
                content_tag(:div, q.name)
              end
            #html_string = html_string + "</div>"

          html_string = html_string + "</div>"
        end

      html_string = html_string + "</div>"
    html_string = html_string + "</div>"
    
  html_string = html_string + "</div>"
  return html_string.html_safe
end

def current_period(p, item)
  case p
  when "Jahr"
      if Date.today.strftime("%m").to_i == item
          return true
      end
  when "Monat"
      if Date.today.strftime("%W").to_i == item
          return true
      end
  when "Woche"
      if Date.today == item
          return true
      end
  end
  return false
end

def exportWriter (mobject, istsoll, istsollkum, istsollau, iso)
  filename = "public/report_" + DateTime.now.to_s + ".xls"
  workbook = WriteExcel.new(filename)
        
  # Add worksheet(s)
  worksheet  = workbook.add_worksheet

  # header format
  f_header0 = workbook.add_format
  f_header0.set_bold  
  # f_header0.set_color('blue')
  f_header0.set_size(20)
  # format.set_align('right')

  f_header1 = workbook.add_format
  f_header1.set_color('white')
  #f_header1.set_bg_color('black')
  f_header1.set_bg_color(57)

  f_param = workbook.add_format
  f_param.set_bold
  f_param.set_color('red')

  # col sizes
  worksheet.set_column(0,20,20)
  
  row = 0
  col = 0
  worksheet.write(row, col, (I18n.t :auftragscontrolling) + " " + DateTime.now.strftime("%d.%m.%y-%H:%M"), f_header0)
  row = row + 2
  worksheet.write(row, col, (I18n.t :parameter), f_header1)
  row = row + 1
  worksheet.write(row, col, (I18n.t :periode))
  worksheet.write(row, col+1, @c_mode, f_param)
  row = row + 1
  worksheet.write(row, col, (I18n.t :kategorie))
  worksheet.write(row, col+1, @c_scope, f_param)
  row = row + 1
  worksheet.write(row, col, (I18n.t :projekte))
  worksheet.write(row, col+1, mobject.name, f_param)
  row = row + 1
  worksheet.write(row, col, (I18n.t :substruktur))
  if @include_sub
    wosub = (I18n.t :ja)
  else
    wosub = (I18n.t :nein)
  end
  worksheet.write(row, col+1, wosub, f_param)
  row=row+2

  worksheet.write(row, 0, (I18n.t :datumvonbis), f_header1)
  worksheet.write(row+1, 0, (I18n.t :ist))
  worksheet.write(row+2, 0, (I18n.t :soll))
  worksheet.write(row+3, 0, (I18n.t :delta))
  for i in 1..istsoll.length-1
    worksheet.write(row, i, istsoll[i][0],f_header1)
    worksheet.write(row+1, i, istsoll[i][1])
    worksheet.write(row+2, i, istsoll[i][2])
    if istsoll[i][2]-istsoll[i][1] < 0
      worksheet.write(row+3, i, istsoll[i][2]-istsoll[i][1], f_param)
    else
      worksheet.write(row+3, i, istsoll[i][2]-istsoll[i][1])
    end 
  end
  
  row=row+6
  worksheet.write(row, 0, (I18n.t :kumuliert), f_header1)
  worksheet.write(row+1, 0, (I18n.t :ist))
  worksheet.write(row+2, 0, (I18n.t :soll))
  worksheet.write(row+3, 0, (I18n.t :delta))
  for i in 1..istsollkum.length-1
    worksheet.write(row, i, istsollkum[i][0],f_header1)
    worksheet.write(row+1, i, istsollkum[i][1])
    worksheet.write(row+2, i, istsollkum[i][2])
    if istsollkum[i][2]-istsollkum[i][1] < 0
      worksheet.write(row+3, i, istsollkum[i][2]-istsollkum[i][1], f_param)
    else
      worksheet.write(row+3, i, istsollkum[i][2]-istsollkum[i][1])
    end 
  end

  row=row+6
  for k in 0..iso.length-1

    maiso = iso[k]
    @user = User.find(maiso[i][0])
    if @user
      @name = @user.name + " " + @user.lastname
    else
      @name = "unbekannt"
    end
    
    worksheet.write(row, 0, @name, f_header1)
    worksheet.write(row+1, 0, (I18n.t :ist))
    worksheet.write(row+2, 0, (I18n.t :soll))
    worksheet.write(row+3, 0, (I18n.t :delta))

    for i in 1..maiso.length-1
      worksheet.write(row, i, maiso[i][1],f_header1)
      worksheet.write(row+1, i, maiso[i][2])
      worksheet.write(row+2, i, maiso[i][3])
      if maiso[i][3] - maiso[i][2] < 0
        worksheet.write(row+3, i, maiso[i][3] - maiso[i][2], f_param)
      else
        worksheet.write(row+3, i, maiso[i][3] - maiso[i][2])
      end 
    end

    row = row + 4

  end

  workbook.close
  return filename

end

def exportWriterRessourcen (data, header)
  filename = "public/report_" + DateTime.now.to_s + ".xls"
  workbook = WriteExcel.new(filename)
        
  # Add worksheet(s)
  worksheet  = workbook.add_worksheet

  # header format
  f_header0 = workbook.add_format
  f_header0.set_bold  
  # f_header0.set_color('blue')
  f_header0.set_size(20)
  # format.set_align('right')

  f_header1 = workbook.add_format
  f_header1.set_color('white')
  #f_header1.set_bg_color('black')
  f_header1.set_bg_color(57)

  f_header2 = workbook.add_format
  f_header2.set_bg_color('yellow')

  f_header3 = workbook.add_format
  f_header3.set_bg_color('red')

  f_header4 = workbook.add_format
  f_header4.set_bg_color('#00FF00')

  f_header5 = workbook.add_format
  f_header5.set_bg_color('orange')

  f_highlight = workbook.add_format
  #f_highlight.set_color('yellow')
  f_highlight.set_bg_color('yellow')

  f_param = workbook.add_format
  f_param.set_bold
  f_param.set_color('red')

  # col sizes
  worksheet.set_column(0,0,40)
  worksheet.set_column(1,11,5)
  
  row = 0
  col = 0
  worksheet.write(row, col, (I18n.t :ressourcencontrolling) + " " + (I18n.l Date.today), f_header0)
  row = row + 2
  worksheet.write(row, col, (I18n.t :parameter), f_header1)
  row = row + 1
  worksheet.write(row, col, (I18n.t :periode))
  worksheet.write(row, col+1, @c_mode, f_param)
  row = row + 2
  for i in 0..data.length-1 do

      worksheet.write(row, 0, User.find(data[i][0]).fullname, f_header5)
      worksheet.write(row+1, 0, (I18n.t :projekte), f_header1)
      for j in 0..header.length-1 do
        worksheet.write(row, j*2+1, header[j],f_header1)
        worksheet.write(row, j*2+2, "",f_header1)
        worksheet.write(row+1, j*2+1, "Plan",f_header1)
        worksheet.write(row+1, j*2+2, "Ist",f_header1)
      end
      row = row + 2

      mobs = data[i][1]
      totalplan = []
      totalist = []
      for i in 0..11
        totalplan << 0
        totalist << 0
      end
      for k in 0..mobs.length-1 do
        worksheet.write(row, 0, Mobject.find(mobs[k][0]).name)
        p = mobs[k][1]
        for l in 1..12
          for z in 0..p.length-1
            if p[z][0] == l
              worksheet.write(row, l*2-1, sprintf("%5.2f",p[z][1]).to_f, f_header4)
              totalplan[l-1] = totalplan[l-1] + p[z][1]
            end
          end
        end
        #row = row + 1
        p = mobs[k][2]
        for l in 1..12
          for z in 0..p.length-1
            if p[z][0] == l
              worksheet.write(row, l*2, sprintf("%5.2f",p[z][1]).to_f, f_header4)
              totalist[l-1] = totalist[l-1] + p[z][1]
            end
          end
        end
        row = row + 1
      end

      worksheet.write(row, 0, "Plan/Ist", f_header1)
      for l in 1..12
      
          delta = (totalplan[l-1]-totalist[l-1]).abs
          if totalplan[l-1] > totalist[l-1]
            max = totalplan[l-1]
          else
            max = totalist[l-1]
          end
          if max > 0
            abw = (delta/max).to_i*100
          else
            abw = 0
          end
          worksheet.write(row, l*2-1, sprintf("%5.2f",totalplan[l-1]).to_f, f_header1)
          if abw < 20
            worksheet.write(row, l*2, sprintf("%5.2f",totalist[l-1]).to_f, f_header1)
          end
          if abw >= 20 and abw < 50
            worksheet.write(row, l*2, sprintf("%5.2f",totalist[l-1]).to_f, f_header2)
          end
          if abw > 50
            worksheet.write(row, l*2, sprintf("%5.2f",totalist[l-1]).to_f, f_header3)
          end

      end

      row=row + 2

  end

  workbook.close
  return filename

end

def exportdata (data, name)
  filename = name
  workbook = WriteExcel.new(filename)
        
  # Add worksheet(s)
  worksheet  = workbook.add_worksheet

  # header format
  f_header1 = workbook.add_format
  f_header1.set_bold  
  f_header1.set_size(12)

  f_header0 = workbook.add_format
  f_header0.set_color('green')
  f_header0.set_size(8)
  
  # col sizes
  worksheet.set_column(0,12,20)
  i=0
  data[0].each_key do |k|
    worksheet.write(0, i, k.to_s, f_header1)
    i=i+1
  end

  for row in 0..data.length-1 do
    worksheet.write(row+1, 0, data[row][:periodicity], f_header0)
    worksheet.write(row+1, 1, data[row][:period], f_header0)
    worksheet.write(row+1, 2, data[row][:projekt_name], f_header0)
    worksheet.write(row+1, 3, data[row][:projekt_kst], f_header0)
    worksheet.write(row+1, 4, data[row][:projekt_auftragsnr], f_header0)
    worksheet.write(row+1, 5, data[row][:mitarbeiter_name], f_header0)
    worksheet.write(row+1, 6, data[row][:mitarbeiter_email], f_header0)
    worksheet.write(row+1, 7, data[row][:mitarbeiter_kst], f_header0)
    worksheet.write(row+1, 8, data[row][:mitarbeiter_rate], f_header0)
    worksheet.write(row+1, 9, data[row][:mitarbeiter_prate], f_header0)
    worksheet.write(row+1, 10, data[row][:aufwand_h], f_header0)
    worksheet.write(row+1, 11, data[row][:aufwand_k], f_header0)
    worksheet.write(row+1, 12, data[row][:kosten], f_header0)
  end

  workbook.close
  return filename

end


def wo_iterate(wo, include_sub, wolist)
  if include_sub
    subs = Mobject.where("parent=?", wo)
    subs.each do |s|
      wolist << s.id
      wo_iterate(s.id, include_sub, wolist)
    end
  end
end

def ticker
  if user_signed_in?
      ticker = " "
      
      # follow Tickets
      usertickets = UserTicket.where('user_id=? and (status=? or status=?)', current_user.id, "übergeben", "persönlich").last(3)
      usertickets.each do |ut|
        	 #ticker = ticker + "Ticket von " + ut.ticket.msponsor.company.name + " (" + ut.ticket.name + " " + ut.ticket.msponsor.mobject.name + ") erhalten... " 
             if ut.ticket.owner_type == "Msponsor"
                 sponsor = ut.ticket.owner
            	 ticker = ticker + "Ticket von " + sponsor.company.name + " (" + ut.ticket.name + " " + sponsor.mobject.name + ") erhalten... " 
             end 
      end

      # follow User
      favourits = Favourit.where('user_id=? and object_name=?', current_user.id, 'User')
      favourits.each do |f|
         u=User.find(f.object_id)
         u.mobjects.order(created_at: :desc).last(3).each do |ue|
        	 ticker = ticker + " " + ue.mtype + " " + ue.name + " von " + u.name + " " + u.lastname + "..."
         end
      end
      
      # follow Company
      favourits = Favourit.where('user_id=? and object_name=?', current_user.id, 'Company')
      favourits.each do |f|
         c=Company.find(f.object_id)
         c.mobjects.order(created_at: :desc).last(3).each do |ce|
        	 ticker = ticker + " " + ce.mtype + " " + ce.name + " von " + c.name + "..." 
         end
      end
      
      # follow Termin
      appointments = Appointment.where('app_date=? AND (user_id1=? OR user_id2=?)', Date.today, current_user.id, current_user.id)
      appointments.each do |a|
       
         if a.user_id1 == current_user.id
            @user = User.find(a.user_id2)
         else
            @user = User.find(a.user_id1)
         end
         if @user
           ticker = ticker + "Termin mit " + @user.name + " " + @user.lastname + " um " + a.time_from.to_s + " Uhr..."
         end
       
      end
      return ticker
  end
end

def online_status(user)
    content_tag :span, user.name,
        class: "user-#{user.id} online_status #{'online' if user.online?}"
end

def subtopic(topic)
  pos = topic.to_s.index("_")
  if pos > 0
    topic = (topic[pos+1..topic.length-1])
  else
    topic = topic
  end
  return topic
end

def import(email, name, lastname, project, activity, parent, anz, datum)

@user = User.where('email=?',email).first
if !@user
  users = User.create({org: "OE4711", costinfo: "KST0815", rate:150, calendar:true, time_from:8, time_to:20, dateofbirth:"09.05.1963", anonymous:false, status:"OK", active:true, email:email, password:"password", name:name, lastname:lastname, address1:"TKB", address2:"Im Roos", address3:"Weinfelden", superuser:false, webmaster:false })
  @user = User.where('email=?',@email).first
end

@projekt = Mobject.where('name=? and mtype=?',project, "projekte").first
if !@projekt
  mobjects = Mobject.create({parent: 0, status:"OK", active:true, mtype:"projekte", msubtype:nil, name:project, date_from: "01.01.2016", date_to: "31.12.2017", owner_type:"Company", owner_id: 1, mcategory_id:29, address1: "", address2: "", address3: ""})
  @projekt = Mobject.where('name=? and mtype=?',project, "projekte").first
  if @projekt
    if parent and parent != ""
      @par = Mobject.where('name=? and mtype=?',parent, "projekte").first
      if !@par
        mobjects = Mobject.create({parent: 0, status:"OK", active:true, mtype:"projekte", msubtype:nil, name:parent, date_from: "01.01.2016", date_to: "31.12.2017", owner_type:"Company", owner_id: 1, mcategory_id:29, address1: "", address2: "", address3: ""})
        @par = Mobject.where('name=? and mtype=?',parent, "projekte").first
      end
      if @par
        @projekt.parent = @par.id
        @projekt.save
      end
    end
  end
end

if @projekt and @user
  
  @madvisor = @projekt.madvisors.where('mobject_id=? and user_id=? and role=?', @projekt.id, @user.id, "projekte").first
  if !@madvisor
    madvisors = Madvisor.create({mobject_id: @projekt.id, user_id: @user.id, role: "projekte", grade: "Projekt-Mitarbeiter"})
  end

  @plannings = @user.plannings.where('mobject_id=? and user_id=?', @projekt.id, @user.id).first
  if !@plannings
    for y in 2016..2017
      for m in 1..12
        if m.to_s.length == 1
          mon = "0"+m.to_s
        else
          mon = m.to_s
        end
        plannings = Planning.create({mobject_id: @projekt.id, user_id: @user.id, amount: 10, jahr: y.to_s, monat: mon, costortime: "aufwand"})
      end
    end
  end

end

if @projekt and @user and datum != nil and datum != ""
  tt = Timetrack.where('mobject_id=? and user_id=? and activity=? and datum=? and amount=?', @projekt.id, @user.id, activity, datum.to_date, anz).first
  if !tt
    timetracks = Timetrack.create({mobject_id: @projekt.id, user_id: @user.id, activity: activity, amount: anz, datum: datum.to_date, costortime: "aufwand"})
    return true
  end
end
end

def isowner(mobject)
  zugriff = false
  if (mobject.owner_type == "User" and mobject.owner_id == current_user.id) or (mobject.owner_type == "Company" and mobject.owner.user_id == current_user.id)
    zugriff = true
  end
  return zugriff
end

def isdeputy(item)
  zugriff = false
  if current_user.superuser
    zugriff = true
  else
    @deputies = item.deputies
    @deputies.each do |d|
      if d.userid == current_user.id
        if d.date_from and d.date_to
          if d.date_from <= Date.today and d.date_to >= Date.today
            zugriff = true
          end
        else
          zugriff = true
        end
      end
    end
  end
  return zugriff
end

def zugriffsliste(mobjects, user)
  array = []
  if user_signed_in?
      mobjects.each do |m|
          #wenn Owner ok or deputy of Owner
          if isowner(m) or isdeputy(m.owner)
            array << m.id
          end
          #wenn Berechtigung ok
          m.madvisors.where('role=?',"projekte").each do |a|
            if current_user.id == a.user_id
              if !array.include?(m.id)
                array << m.id
              end
            end
          end
      end
  end
  return array
end

def contactChip(owner)
  html = '<div class="chip">'
  html = html + showImage2(:small,owner,true)
  if owner.class.name == "User"
    html = html + owner.name[0] + "." + owner.lastname
  end
  if owner.class.name == "Company"
    if owner.name.length <= 15
      html = html + " " + owner.name
    else
      html = html + " " + owner.name[0..15]
    end
  end
  html = html + '</div>'
  return html.html_safe
end

def build_cal(mode, scope1, scope2, scope3, datum)

html_string = ""
html_string = html_string + "<table class='table table-responsive table-week'>"
  html_string = html_string + "<thead>"
    html_string = html_string + "<th colspan='3'></th>"
    if mode == "Woche"
      startdate = Date.parse(datum) - Date.parse(datum).cwday+1
      enddate = startdate+7
      for i in 0..6
        if Date.today.cwday-1 == i
          html_string = html_string + "<th class='table-week actdate dateheader'>"
        else
          html_string = html_string + "<th class='table-week dateheader'>"
        end
        html_string = html_string + $wochentage[i]+"<br>"
        html_string = html_string + (startdate + i).strftime("%d.%m.%Y").to_s
        html_string = html_string + "</th>"
      end
    end
    if mode == "Monat"
      startdate = Date.parse(datum).beginning_of_month
      enddate = Date.parse(datum).end_of_month+1
      for i in 1..enddate-startdate
        if Date.today.day == i and Date.today >= startdate and Date.today <= enddate
          html_string = html_string + "<th class='table-week actdate dateheader'>"
        else
          html_string = html_string + "<th class='table-week dateheader'>"
        end
        html_string = html_string + i.to_s
        html_string = html_string + "</th>"
      end
    end
  html_string = html_string + "</thead>"
  html_string = html_string + "<body 'table-week'>"

    case scope1
      when "signage_cals"
        if scope2 == "locations"
          @cals = SignageCal.where('mkampagne=? and date_from<=? and date_to>=?',scope3, enddate, startdate)
        end
        if scope2 == "campaigns"
          @cals = SignageCal.where('mstandort=? and date_from<=? and date_to>=?',scope3, enddate, startdate)
        end
        @cals.each do |c|
          html_string = html_string + "<tr>"
            if scope2 == "locations" and c.mstandort
              @obj = Mobject.find(c.mstandort)
            end
            if scope2 == "campaigns" and c.mkampagne
              @obj = Mobject.find(c.mkampagne)
            end
            html_string = html_string + "<td>"
              html_string = html_string + showFirstImage2(:small, @obj, @obj.mdetails)
            html_string = html_string + "</td>"
            
            html_string = html_string + "<td>"
              html_string = html_string + @obj.name + " " + c.time_from.to_s + "-" + c.time_to.to_s + " Uhr" 

            html_string = html_string + "</td>"
              
            html_string = html_string + "<td>"
      			if @obj.owner_id == current_user.id or isdeputy(current_user)
    				  if !c.confirmed
    				    if scope2 == "locations"
                      html_string = html_string + link_to(signage_cals_path(:confirm_id => c.id, :loc_id => c.mstandort)) do
                        content_tag(:i, nil, class:"btn btn-primary btn-xs fa fa-check")
                      end
                end
    				    if scope2 == "campaigns"
                      html_string = html_string + link_to(signage_cals_path(:confirm_id => c.id, :kam_id => c.mkampagne)) do
                        content_tag(:i, nil, class:"btn btn-primary btn-xs fa fa-check")
                      end
                end
              else
    				    if scope2 == "locations"
                      html_string = html_string + link_to(signage_cals_path(:noconfirm_id => c.id, :loc_id => c.mstandort)) do
                        content_tag(:i, nil, class:"btn btn-primary btn-xs fa fa-ban")
                      end
                end
    				    if scope2 == "campaigns"
                      html_string = html_string + link_to(signage_cals_path(:noconfirm_id => c.id, :loc_id => c.mkampagne)) do
                        content_tag(:i, nil, class:"btn btn-primary btn-xs fa fa-ban")
                      end
                end
              end
              html_string = html_string + link_to(edit_signage_cal_path(c)) do
                content_tag(:i, nil, class:"btn btn-primary btn-xs fa fa-wrench")
              end
  				    html_string = html_string + link_to(c, method: :delete, data: { confirm: 'Are you sure?' }) do
                content_tag(:i, nil, class:"btn btn-danger btn-xs fa fa-trash")
              end
            end
            html_string = html_string + "</td>"
            if mode == "Woche"
              for k in 0..6
                if startdate+k >= c.date_from and startdate+k <= c.date_to
                  html_string = html_string + "<td class='colfilled'>"
                  html_string = html_string + "<div class='box'></div>"
                else
                  html_string = html_string + "<td>"
                end
                html_string = html_string + "</td>"
              end
            end
            if mode == "Monat"
              for k in 0..enddate-startdate
                if startdate+k >= c.date_from and startdate+k <= c.date_to
                  html_string = html_string + "<td class='colfilled'>"
                  html_string = html_string + "<div class='boxmon'></div>"
                else
                  html_string = html_string + "<td>"
                end
                html_string = html_string + "</td>"
              end
            end
          html_string = html_string + "</tr>"
        end
    end
  html_string = html_string + "</body>"
html_string = html_string + "</table>"
return html_string.html_safe
end

end    