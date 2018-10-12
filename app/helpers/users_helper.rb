module UsersHelper

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

def carousel2(mobject, size)
    html = ""
    if mobject.mdetails == nil
      html = html + image_tag(mobject.mtype + ".png", :size => size, class:"card-img-top img-responsive" )
    else
      if mobject.mdetails.count == 0
        html = html + image_tag(mobject.mtype + ".png", :size => size, class:"card-img-top img-responsive" )
      else
        html = html +  '<div class="owl-show">'
        mobject.mdetails.where('avatar_file_name !=?',"").each do |p|
          
          html = html + "<div class='row'>"

            html = html + "<div class='col-xs=12'>"
              if p.avatar_file_name == nil
                #html = html + "<div>" + image_tag(image_def("objekte", mobject.mtype), :size => size, class:"card-img-top img-responsive" ) + "</div>"
                html = html + "<div>" + showFirstImage2(:medium, @mobject, @mobject.mdetails) + "</div>"
                
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

            #html = html + "<div class='col-xs=12'>"
              #if p.document_file_name
                #html = html + link_to(p.document.url, target: "_blank") do 
                  #content_tag(:i, nil, class:"btn btn-primary fa fa-cloud-download")
                #end
              #end
            #html = html + "</div>"

          html = html + "</div>"
              
        end
        html = html +  "</div>"
      end
    end
    return html.html_safe
end

def carousel4(mobject, size)
html = ""
if mobject.mdetails.count>0
html = html + '<div class="container">'
  html = html + "<div class='row'>"
    html = html + "<div class='col-md-8'>"
      html = html + '<div class="carousel slide media-carousel" id="media">'
        html = html + '<div class="carousel-inner">'

          html = html + '<div class="item  active">'
            html = html + '<div class="row">'
              if mobject.mdetails
                mobject.mdetails.where('avatar_file_name!=?',"").each do |md| 
                  html = html + '<div class="col-md-4">'
                    html = html + image_tag(md.avatar(:medium), class:"card-img-top img-responsive" )
                  html = html + "</div>"
                end
              end
            html = html + "</div>"
          html = html + "</div>"

          html = html + '<div class="item">'
            html = html + '<div class="row">'
              if mobject.mdetails
                mobject.mdetails.where('document_file_name!=?',"").each do |md| 
                  html = html + '<div class="col-md-4">'
                    html = html + image_tag("anhang.jpg", :size => "200x200", class:"card-img-top img-responsive" )
                    html = html + link_to(md.document.url, target: "_blank") do 
                      content_tag(:i, nil, class:"btn btn-default btn-xs fa fa-cloud-download")
                    end
                    html = html + md.name
                  html = html + "</div>"
                end
              end
            html = html + "</div>"
          html = html + "</div>"

        html = html + "</div>"
        html = html + '<a data-slide="prev" href="#media" class="left carousel-control">‹</a>'
        html = html + '<a data-slide="next" href="#media" class="right carousel-control">›</a>'
      html = html + "</div>"
    html = html + "</div>"
  html = html + "</div>"
html = html + "</div>"
end
return html.html_safe
end

def carousel3(mobject, size)
html = ""
html = html + "<div id='carousel-example-generic' class='carousel slide' data-ride='carousel'>"
  #<!-- Indicators -->
  html = html + "<ol class='carousel-indicators'>"
    html = html + "<li data-target='#carousel-example-generic' data-slide-to='0' class='active'></li>"
    html = html + "<li data-target='#carousel-example-generic' data-slide-to='1'></li>"
    html = html + "<li data-target='#carousel-example-generic' data-slide-to='2'></li>"
  html = html + "</ol>"
 
  #<!-- Wrapper for slides -->
  html = html + "<div class='carousel-inner'>"
    html = html + "<div class='item active'>"
      #html = html + "<div class='box'>"
                html = html + "<div>" + image_tag(image_def("objekte", mobject.mtype), :size => size, class:"card-img-top img-responsive" ) + "</div>"
                #html = html + "<div>" + showFirstImage2(:medium, @mobject, @mobject.mdetails) + "</div>"
      #html = html + "</div>"
      html = html + "<div class='carousel-caption'>"
      	html = html + "<h3>First Text</h3>"
      html = html + "</div>"
    html = html + "</div>"
    html = html + "<div class='item'>"
      html = html + "<div class='box'></div>"
      html = html + "<div class='carousel-caption'>"
      	html = html + "<h3>Second Text</h3>"
      html = html + "</div>"
    html = html + "</div>"
    html = html + "<div class='item'>"
      html = html + "<div class='box'></div>"
      html = html + "<div class='carousel-caption'>"
      	html = html + "<h3>Third Text</h3>"
      html = html + "</div>"
    html = html + "</div>"
  html = html + "</div>"
 
  #<!-- Controls -->
  html = html + "<a class='left carousel-control' href='#carousel-example-generic' role='button' data-slide='prev'>"
    html = html + "<span class='fa fa-chevron-left'></span>"
  html = html + "</a>"
  html = html + "<a class='right carousel-control' href='#carousel-example-generic' role='button' data-slide='next'>"
    html = html + "<span class='fa fa-chevron-right'></span>"
  html = html + "</a>"
html = html + "</div>"  
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

def build_mediaTable(items, cname, year, par2, par3)

  html_string = ""
  html_string = html_string + '<div class="scrollmenu">'
    html_string = html_string + '<table class="table table-striped">'
      html_string = html_string + '<thead>'
        html_string = html_string + '<tr>'
          html_string = html_string + '<th>public</th>'
          html_string = html_string + '<th colspan="2">Name</th>'
          html_string = html_string + '<th colspan="1">Datum</th>'
          html_string = html_string + '<th colspan="1">Kosten</th>'
          html_string = html_string + '<th colspan="1">Aufwand</th>'
          html_string = html_string + '<th>Status</th>'
          html_string = html_string + '<th>Projektleiter</th>'
          @header = []
          @header = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Okt Nov Dez]
          for i in 0..11
            html_string = html_string + '<th>' + @header[i] + '</th>'
          end
          @data = []
          for i in 0..11
            @data << i
          end

          #html_string = html_string + '<th>Aktion</th>'
        html_string = html_string + '</tr>'
      html_string = html_string + '</thead>'
      html_string = html_string + '<body>'
    
  items.each do |item|
    
    if item
      
      if !item.date_from
        item.date_from = Date.today()-1
      end
      if !item.date_to
        item.date_to = Date.today()
      end
      if !item.sum_pkosten_plan
        item.sum_pkosten_plan = 0
      end
      if !item.sum_pkosten_ist
        item.sum_pkosten_ist = 0
      end
      if !item.sum_paufwand_plan
        item.sum_paufwand_plan = 0
      end
      if !item.sum_paufwand_ist
        item.sum_paufwand_ist = 0
      end
      
      html_string = html_string + '<tr>'
      if cname == "projekte"
        if item.online_pub
          html_string = html_string + '<td><i class="fa fa-road"></i></td>'
        else
          html_string = html_string + '<td><i class="fa fa-lock"></i></td>'
        end
        html_string = html_string + "<td>" + "______" + showFirstImage2(:small, item, item.mdetails) + "</td>"
        html_string = html_string + "<td>" + item.name + "</td>"

        #html_string = html_string + "<td>" + item.date_from.strftime("%d.%m.%Y") + "</td>"
        #html_string = html_string + "<td>" + item.date_to.strftime("%d.%m.%Y") + "</td>"
        soll = (item.date_to.to_date - item.date_from.to_date).to_i
        ist = (DateTime.now.to_date - item.date_from.to_date).to_i
        if soll > 0 and ist > 0
          html_string = html_string + "<td>"
            html_string = html_string + '<div class="progress">'
              html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
              html_string = html_string + '</div>'
            html_string = html_string + '</div>'
          html_string = html_string + "</td>"
        else
          html_string = html_string + "<td></td>"
        end

        #html_string = html_string + "<td>" + sprintf("%5.0f K"+(I18n.t :waehrung),item.sum_pkosten_plan/1000) + "</td>"
        if item.sum_pkosten_plan and item.sum_pkosten_ist
          html_string = html_string + "<td>"
            html_string = html_string + '<div class="progress">'
            html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + item.sum_pkosten_ist.to_s + '" aria-valuemin="0" aria-valuemax="' + item.sum_pkosten_plan.to_s + '" style="width:' + (item.sum_pkosten_ist*100/item.sum_pkosten_plan).to_s + '%">'
            html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
            html_string = html_string + '</div>'
            html_string = html_string + '</div>'
          html_string = html_string + "</td>"
        else
          html_string = html_string + "<td></td>"
        end

        #html_string = html_string + "<td>" + sprintf("%5.0f "+(I18n.t :personentage),item.sum_paufwand_plan) + "</td>"
        if item.sum_paufwand_plan and item.sum_paufwand_ist
          html_string = html_string + "<td>"
            html_string = html_string + '<div class="progress">'
            html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + item.sum_paufwand_ist.to_s + '" aria-valuemin="0" aria-valuemax="' + item.sum_paufwand_plan.to_s + '" style="width:' + (item.sum_paufwand_ist*100/item.sum_paufwand_plan).to_s + '%">'
            html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
            html_string = html_string + '</div>'
            html_string = html_string + '</div>'
          html_string = html_string + "</td>"
        else
          html_string = html_string + "<td></td>"
        end
        
        if item.gesamtstatus
          html_string = html_string + "<td>"
            html_string = html_string + "<div class='"+item.gesamtstatus + "'><span><i class='fa fa-stop'></i></span></div>"
          html_string = html_string + "</td>"
        else
          html_string = html_string + "<td></td>"
        end
          
        if true
          html_string = html_string + "<td>"
            html_string = html_string + "PL"
          html_string = html_string + "</td>"
        end

        #year="2018"
        for i in 1..12
          showme = false
          #Datum vor und nach Jahr
          if (item.date_from.year < year.to_i and item.date_to.year > year.to_i)
            showme = true
          else
            #Datum liegt im Jahr
            if (item.date_from.year == year.to_i and item.date_from.month <= i and item.date_to.month >=i)
              showme = true
            else
              #Startjahr liegt im Jahr zuvor
              if (item.date_from.year < year.to_i and item.date_to.year == year.to_i and item.date_to.month >= i)
                showme = true
              else
                #Endejahr liegt im Jahr später
                if (item.date_to.year > year.to_i and item.date_from.year == year.to_i and item.date_from.month <=i)
                  showme = true
                end
              end
            end
          end
          if showme
            html_string = html_string + "<td class='timeline'></td>"
          else
            html_string = html_string + "<td></td>"
          end
        end
        
        if false
        html_string = html_string + "<td>"
        html_string = html_string + link_to(item, :topic => "info") do 
          content_tag(:i, nil, class:"btn btn-default btn-xs fa fa-info")
        end
        if cname == "projekte"
          if isowner(item) or isdeputy(item.owner)
            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
              content_tag(:i, nil, class:"btn btn-danger btn-xs fa fa-trash")
            end
            html_string = html_string + link_to(edit_mobject_path(:id => item)) do 
              content_tag(:i, nil, class:"btn btn-default btn-xs fa fa-wrench")
            end
          end
        end
        html_string = html_string + "</td>"
        end

      end #projekte
      html_string = html_string + '</tr>'
    end #item show
  end # loop item
  html_string = html_string + '</body>'
html_string = html_string + '</table>'
html_string = html_string + '</div>'
return html_string.html_safe
end

def build_projektTable(items, version)

  html_string = ""
  html_string = html_string + '<div class="scrollmenu">'
    html_string = html_string + '<table class="table table-striped">'
      html_string = html_string + '<thead>'
        html_string = html_string + '<tr>'

          html_string = html_string + '<th>Pos</th>'
          html_string = html_string + '<th>Name</th>'
          html_string = html_string + '<th>von</th>'
          html_string = html_string + '<th>bis</th>'
          html_string = html_string + '<th>ToC</th>'
          html_string = html_string + '<th>PoC</th>'

          mindat=Date.today
          maxdat=Date.today
          #items.where('version=?',version).each do |i|
          items.each do |i|
            if i.date_from < mindat
              mindat = i.date_from
            end
            if i.date_to < maxdat
              maxdat = i.date_to
            end
          end
          
          startyear = mindat.strftime("%Y").to_i
          endyear = maxdat.strftime("%Y").to_i
          startmon = mindat.strftime("%m").to_i
          endmon = maxdat.strftime("%m").to_i

          #html_string = html_string + startyear.to_s + startmon.to_s
          #html_string = html_string + endyear.to_s + endmon.to_s

          @header = []
          @header = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Okt Nov Dez]
          @data = []
          for i in startyear..endyear+1
            for k in 1..12
              html_string = html_string + '<th>' + @header[k-1] + '</th>'
              is = i.to_s
              ks = k.to_s
              if is.length()==1
                is = "0"+is
              end
              if ks.length()==1
                ks = "0"+ks
              end
              @data << {:year => is, :month => ks}
            end
          end 

        html_string = html_string + '</tr>'
      html_string = html_string + '</thead>'
      html_string = html_string + '<body>'
    
      items.order(:date_from).each do |item|

          if !item.date_from
            item.date_from = Date.today()-1
          end
          if !item.date_to
            item.date_to = Date.today()
          end
    
          html_string = html_string + '<tr>'
    
            html_string = html_string + '<td>'
              html_string = html_string + link_to(edit_pplan_path(item)) do 
                content_tag(:i, nil, class:"btn btn-primary btn-xs fa fa-wrench")
              end
              if false
              html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => "objekte_projektplan", :action => "up")) do 
                content_tag(:i, nil, class:"btn btn-default btn-xs fa fa-angle-down")
              end
              html_string = html_string + link_to(mobject_path(:id => item.mobject_id, :topic => "objekte_projektplan", :action => "down")) do 
                content_tag(:i, nil, class:"btn btn-default btn-xs fa fa-angle-up")
              end
              end
            html_string = html_string + '</td>'
            html_string = html_string + "<td>" + item.task + "</td>"

            html_string = html_string + '<td>' + item.date_from.strftime("%d.%m.%Y") + '</td>'
            html_string = html_string + '<td>' + item.date_to.strftime("%d.%m.%Y") + '</td>'

            soll = (item.date_to.to_date - item.date_from.to_date).to_i
            ist = (DateTime.now.to_date - item.date_from.to_date).to_i
            if soll > 0 and ist > 0
              html_string = html_string + "<td>"
                html_string = html_string + '<div class="progress">'
                  html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (ist*100/soll).to_s + '%">'
                    html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                  html_string = html_string + '</div>'
                html_string = html_string + '</div>'
              html_string = html_string + "</td>"
            else
              html_string = html_string + "<td></td>"
            end
    
            if item.poc > 0
              html_string = html_string + "<td>"
                html_string = html_string + '<div class="progress">'
                  html_string = html_string + '<div class="progress-bar progress-bar-warning" role="progressbar2" aria-valuenow="' + ist.to_s + '" aria-valuemin="0" aria-valuemax="' + soll.to_s + '" style="width:' + (item.poc).to_s + '%">'
                    html_string = html_string + '<span class="sr-only">40% Complete (success)</span>'
                  html_string = html_string + '</div>'
                html_string = html_string + '</div>'
              html_string = html_string + "</td>"
            else
              html_string = html_string + "<td></td>"
            end
              
            #html_string = html_string + @data.to_s
            for i in 0..@data.length()-1
              showme = false

              if (item.date_from.year >= @data[i][:year].to_i and item.date_to.year <= @data[i][:year].to_i) and (item.date_from.month <= @data[i][:month].to_i and item.date_to.month >= @data[i][:month].to_i)
                showme = true
              end

              compDate = (@data[i][:year] + "." + @data[i][:month] + ".01").to_date
              if item.date_from <= compDate and item.date_to >= compDate
                  showme = true
              end

              if showme
                if item.tasktype == "Aktivität"
                  html_string = html_string + "<td class='timeline'></td>"
                end
                if item.tasktype == "Meilenstein"
                  html_string = html_string + "<td class='milestone'>"+content_tag(:i, nil, class:"fa fa-bandcamp")+"</td>"
                end
              else
                html_string = html_string + "<td></td>"
              end
            end
              
          html_string = html_string + '</tr>'
          
      end # loop item
      html_string = html_string + '</body>'
    html_string = html_string + '</table>'
  html_string = html_string + '</div>'
return html_string.html_safe
end

def build_medialistNew(items, cname, par1, par2, par3)

  priceAnz = 0
  sensorAnz = 0

  html_string = ""
  html_string = html_string + '<div class="container">'
    html_string = html_string + '<div class="row">'
      html_string = html_string + '<div class="col-md-12 text-center">'
        #html_string = html_string + '<h2 class="service-title pad-bt15">übersicht</h2>'
        #html_string = html_string + '<p class="sub-title pad-bt15">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod<br>tempor incididunt ut labore et dolore magna aliqua.</p>'
        #html_string = html_string + '<hr class="bottom-line">'
      html_string = html_string + '</div>'

  items.each do |item|
    
    if item
      
        html_string = html_string + '<div class="col-xl-2 col-lg-3 col-md-4 col-sm-6 col-xs-12">'
        
          #bei mobject corporate design
          color = $graph_color2
          if items.table_name == "mobjects"
            if item.owner_type == "Company"
              item.owner.company_params.each do |p|
                if p.key.downcase == "color1"
                  color = p.value
                end
              end
            end
          end
          html_string = html_string + '<div class="blog-sec" style="border-left: 10px solid '+color+'">'
          
            #**************************************************************************************************************
            #IMAGE BLOCK
            #**************************************************************************************************************
            html_string = html_string + '<div class="blog-img">'
            case items.table_name
              when "company_params"
                  html_string = html_string + link_to(company_params_path(:id => item.id)) do
                    image_tag("settings.jpg", :size => :medium)
                  end
              when "deputies"
                  html_string = html_string + showImage2(:medium, User.find(item.userid), true)
               when "appparams"
                  html_string = html_string + image_tag(item.right+".png", :size => "250x250")
              when "users", "companies"
                html_string = html_string + showImage2(:medium, item, true)
              when "mdetails"
                html_string = html_string + showImage2(:medium, item, false)
              when "mobjects"
                html_string = html_string + showFirstImage2(:medium, item, item.mdetails)
              when "madvisors"
                if par1 == "objekte"
                  html_string = html_string + showFirstImage2(:medium, item.mobject, item.mobject.mdetails)
                end
                if par1 == "user"
                  html_string = html_string + showImage2(:medium, item.user, true)
                end
              when "searches"
                  if par1 != nil and par1 != ""
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
                      when "institutionen"
                        html_string = html_string + link_to(companies_path(:filter_id => item.id)) do
                          #content_tag(:i, nil, class:"fa fa-question-sign", style:"font-size:8em") 
                          image_tag("abfragen.jpg", :size => :medium)
                        end
                    end
                    html_string = html_string + "</soft_padding>"
                  end
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
              when "company_params"
                html_string = html_string + item.key if item.key
              when "deputies"
                html_string = html_string + User.find(item.userid).name + " " + User.find(item.userid).lastname
              when "appparams"
                html_string = html_string + (I18n.t item.right.to_sym)
              when "charges"
                html_string = html_string + (I18n.t item.appparam.right.to_sym)
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
                html_string = html_string + " " + item.name if item.name
              when "searches"
                html_string = html_string + item.name
              when "madvisors"
                if par1 == "user"
                  html_string = html_string + item.user.name + " " + item.user.lastname
                end
                if par1 == "objekte"
                  html_string = html_string + item.mobject.name
                end
              when "partner_links"
                if item.name
                    html_string = html_string + item.name + "<br>"
                end
                if item.link
                    html_string = html_string + item.link 
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
                  if par1 == "user"
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

              when "company_params"
                html_string = html_string + '<i class="fa fa-wrench"></i> '
                html_string = html_string + item.value.to_s if item.value

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

              when "mobjects"
                html_string = html_string + '<i class="fa fa-folder-open"></i> '
                html_string = html_string + " " + item.mcategory.name + "<br>"

                case item.mtype

                  when "projekte"
                    if !item.date_from
                      item.date_from = Date.today
                    end
                    if !item.date_to
                      item.date_to = Date.today
                    end
                    if !item.gesamtstatus
                      item.gesamtstatus = "OK"
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
                    
                end
                html_string = html_string + contactChip(item.owner)

                when "madvisors"
                    html_string = html_string + '<i class="fa fa-folder-open"></i> '
                    html_string = html_string + item.grade.to_s + "<br>"
                    if item.mobject.mtype == "projekte"
                      html_string = html_string + '<i class="fa fa-euro"></i> '
                      if !item.rate
                        item.rate = 0
                      end
                      html_string = html_string + sprintf("%5.2f",item.rate) + "<br>"
                    end

              when "searches"
                #html_string = html_string + "<anzeigetext>" + item.name + "</anzeigetext><br>"
                if item.search_domain == "object"
                  html_string = html_string + '<i class="fa fa-folder-open"></i> '
                  html_string = html_string + item.mtype + "<br>" 
                  html_string = html_string + item.msubtype.to_s + '<br>'
                end
                html_string = html_string + '<i class="fa fa-question-sign"></i> '
                html_string = html_string + 'Anzahl ' + item.counter.to_s + '<br>'
                
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
              when "company_params"
                if current_user.id = item.company.user_id or isdeputy(item.company.user_id)
                  access = true
                end

              when "partner_links"
                if current_user.id = item.company.user_id or isdeputy(item.company.user_id)
                  access = true
                end

              when "users"
  	            html_string = html_string + link_to(new_email_path(:m_to_id => item.id, :m_from_id => current_user.id, :back_url => request.original_url)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-envelope mediabutton")
                end
                if item.id == current_user.id or isdeputy(item)
                  access=true
                end 
                if par1 == "deputy"
    	            html_string = html_string + link_to(new_deputy_path(:user_id => item.id, :owner_id => par2, :owner_type => par3)) do 
                    content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-check mediabutton")
                  end
                  access=false
                end
                if par1 == "projekte"
    	            html_string = html_string + link_to(new_madvisor_path(:user_id => item.id, :mobject_id => par2)) do 
                    content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-plus mediabutton")
                  end
                  access=false
                end
                if par1 == "gruppen"
    	            html_string = html_string + link_to(new_madvisor_path(:user_id => item.id, :mobject_id => par2)) do 
                    content_tag(:i, nil, class:"btn btn-primary btn-lg fa fa-plus mediabutton")
                  end
                  access=false
                end

              when "companies"
                if item.user_id == current_user.id or isdeputy(item.user)
                  access=true
                end 

              when "searches"
                if item.user_id == current_user.id or isdeputy(item.user)
                  access=true
                end 

              when "mobjects", "partners"
                if cname == "mobjects"
                  if isowner(item) or isdeputy(item.owner)
                    access = true
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

             end
          end

          #kein Info button wenn kein weiterer drill down
          if cname != "mdetails" and cname != "madvisors" and cname != "partner_links" and cname != "appparams"
            html_string = html_string + link_to(item, :topic => "info") do 
              content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-info")
            end
          end
 
          if access
            case cname 
              when "company_params"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_company_param_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
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
               when "madvisors"
                if item.mobject.mtype == "projekte" or item.mobject.mtype == "gruppen"
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
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
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

              when "searches"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_search_path(:id => item)) do 
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

              when "mobjects"
  	            html_string = html_string + link_to(item, method: :delete, data: { confirm: 'Are you sure?' }) do 
                  content_tag(:i, nil, class:"btn btn-danger btn-lg fa fa-trash pull-right")
                end
  	            html_string = html_string + link_to(edit_mobject_path(:id => item)) do 
                  content_tag(:i, nil, class:"btn btn-default btn-lg fa fa-wrench")
                end

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
          image_tag(item.mtype + ".png", :size => ssize, class:"img-responsive")
        end
      else
        image_tag(item.mtype + ".png", :size => ssize, class:"img-responsive")
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
          else
            html_string = image_tag("no_pic.jpg", :size => "50x50", class:"card-img-top img-responsive" )
        end
      end
    end
    return html_string.html_safe
end

def myheader4(header, user, company, mobject, obj, item, topic)
  pos = topic.index("_")
  infosymbol = (topic[pos+1..topic.length-1]).to_sym
  txt = getinfo2(infosymbol)["infotext"]

  color1 = $graph_color2
  color2 = $grey
  if company
    company.company_params.each do |p|
      if p.key.downcase == "color1"
        color1 = p.value
      end
      if p.key.downcase == "color2"
        color2 = p.value
      end
    end
  end
  if mobject and mobject.owner_type == "Company"
    mobject.owner.company_params.each do |p|
      if p.key.downcase == "color1"
        color1 = p.value
      end
      if p.key.downcase == "color2"
        color2 = p.value
      end
    end
  end

  html_string = ""
  html_string = html_string + '<div class="panel-body" style="background-color:' + color1 + '; color:' + color2 + '">'
      html_string = html_string + "<h3>"+text+" "+txt+"</h3>"
      html_string = html_string + navigate3(obj, item, topic, txt)
  html_string = html_string + "</div>"
  return html_string.html_safe
end


def header(header)
    html_string = ""
    html_string = html_string + '<div class="panel-body ueberschrift">'
      html_string = html_string + "<h3>"+header+"</h3>"
    html_string = html_string + "</div>"
    return html_string.html_safe
end

def header4(text, obj, item, topic)
    pos = topic.index("_")
    infosymbol = (topic[pos+1..topic.length-1]).to_sym
    txt = getinfo2(infosymbol)["infotext"]
    html_string = ""
    html_string = html_string + '<div class="panel-body ueberschrift">'
      html_string = html_string + "<h3>"+text+" "+txt+"</h3>"
      html_string = html_string + navigate3(obj, item, topic, txt)
    html_string = html_string + "</div>"
    return html_string.html_safe
end

def header4_cicd(text, user, company, mobject, obj, item, topic)
  pos = topic.index("_")
  infosymbol = (topic[pos+1..topic.length-1]).to_sym
  txt = getinfo2(infosymbol)["infotext"]

  color1 = $graph_color2
  color2 = $grey
  if company
    company.company_params.each do |p|
      if p.key.downcase == "color1"
        color1 = p.value
      end
      if p.key.downcase == "color2"
        color2 = p.value
      end
    end
  end
  if mobject and mobject.owner_type == "Company"
    mobject.owner.company_params.each do |p|
      if p.key.downcase == "color1"
        color1 = p.value
      end
      if p.key.downcase == "color2"
        color2 = p.value
      end
    end
  end

  html_string = ""
  html_string = html_string + '<div class="panel-body" style="background-color:' + color1 + '; color:' + color2 + '">'
      html_string = html_string + "<h3>" + text.upcase + "</h3>"
      html_string = html_string + navigate3(obj, item, topic, txt)
  html_string = html_string + "</div>"
  return html_string.html_safe
end

def header_comp(header, color)
    html_string = ""
      if color 
        html_string = html_string + '<div class="panel-body" id="header">'
      else
        html_string = html_string + '<div class="panel-body ueberschrift">'
      end
        html_string = html_string + "<h3>"+header+"</h3>"
      html_string = html_string + "</div>"
    return html_string.html_safe
end

def header_cicd(header, company, mobject)
  color1 = $graph_color2
  color2 = $grey
  if company  
    company.company_params.each do |p|
      if p.key.downcase == "color1"
        color1 = p.value
      end
      if p.key.downcase == "color2"
        color2 = p.value
      end
    end
  end
  if mobject and mobject.owner_type == "Company"
    mobject.owner.company_params.each do |p|
      if p.key.downcase == "color1"
        color1 = p.value
      end
      if p.key.downcase == "color2"
        color2 = p.value
      end
    end
  end
  html_string = ""
  html_string = html_string + '<div class="panel-body" style="background-color:' + color1 + '; color:' + color2 + '">'
    html_string = html_string + "<h3>"+header+"</h3>"
  html_string = html_string + "</div>"
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

def indexheader4(text, objekttyp, mtype, filter_id, search, mobject)
  html_string = ""
  filter=""
  if filter_id
    filter = "("+Search.find(filter_id).name+")"
  end
  if user_signed_in?
    @s = Search.where('user_id=? and search_domain=?', current_user, objekttyp)
  end
  color1 = $graph_color2
  color2 = $grey
  html_string = html_string + '<div class="panel-body" style="background-color:' + color1 + '; color:' + color2 + '">'
      html_string = html_string + "<div class='row'>"
        html_string = html_string + "<div class='col-xl-6 col-lg-6 col-md-6 col-sm-6 col-xs-12'>"
          html_string = html_string + "<h3>" + text.upcase + " " + filter + "</h3>"
        html_string = html_string + "</div>"
        html_string = html_string + "<div class='col-xl-6 col-lg-6 col-md-6 col-sm-6 col-xs-12'>"
    			if $controller_list.include?(controller_name) and (action_name == "index")
    				@items = url_for(action: action_name, controller: controller_name)
    				html_string = html_string + form_tag(@items, method: 'get', :data => {:mode => mtype, :mobject_id => mobject}, class: "form-inline pull-right") do
              content_tag(:i, search_field_tag('search'), class: "fa fa-search")
    				end
    			end
        html_string = html_string + "</div>"
      html_string = html_string + "</div>"
      if @s
      html_string = html_string + "<div class='dropdown'>"
        html_string = html_string + "<button class='btn btn-default dropdown-toggle' type='button' id='menu1' data-toggle='dropdown'>"+" Abfragen " + @s.count.to_s
        html_string = html_string + "<span class='caret'></span></button>"
        html_string = html_string + "<ul class='dropdown-menu' role='menu' aria-labelledby='menu1'>"

          @s.each do |filter|
            html_string = html_string + '<li role="presentation"><a role="menuitem" tabindex="-1">'
            case objekttyp
              when "institutionen"
                html_string = html_string + link_to(companies_path(:filter_id => filter.id)) do
                  content_tag(:span, " "+filter.name, class:"fa fa-list")
                end
              when "personen"
                html_string = html_string + link_to(users_path(:filter_id => filter.id)) do
                  content_tag(:span, " "+filter.name, class:"fa fa-list")
                end
              when "objekte"
                html_string = html_string + link_to(mobjects_path(:filter_id => filter.id)) do
                  content_tag(:span, " "+filter.name, class:"fa fa-list")
                end
            end
            html_string = html_string + "</li>"
            html_string = html_string + "<li class='divider'></li>"
          end

        html_string = html_string + '</ul>'

        #html_string = html_string + action_buttons4(object, item, topic)

      if user_signed_in?
        html_string = html_string + link_to(new_search_path(:user_id => current_user, :search_domain => objekttyp, :controller_name => controller_name, :mtype => mtype)) do
           content_tag(:i, " "+(I18n.t :abfrage), class: "btn btn-primary fa fa-plus pull-right")
        end
      end
      if filter_id
        html_string = html_string + link_to(edit_search_path(:id => filter_id)) do
           content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench pull-right")
        end
        html_string = html_string + link_to(Search.find(filter_id), method: :delete, data: { confirm: (I18n.t :sindsiesicher) } ) do
          content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red  pull-right")
        end
      end
      html_string = html_string + '</div>'
      end
      
      #html_string = html_string + navigate3(obj, item, topic, txt)
  html_string = html_string + "</div>"
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

def navigate3(object, item, topic, topictxt)

  html_string = ""

      #html_string = html_string + "<ul class='navsub navbar-nav'>"
        #html_string = html_string + "<li class='dropdown'>"
          #html_string = html_string + "<a href='#' class='dropdown-toggle' data-toggle='dropdown'><span class='fa fa-align-justify pull-right bigtext'></span></a>"
          #html_string = html_string + "<ul class='dropdown-menu'>"

  html_string = html_string + "<div class='dropdown'>"
    html_string = html_string + "<button class='btn btn-default dropdown-toggle' type='button' id='menu1' data-toggle='dropdown'>"+topictxt 
    html_string = html_string + "<span class='caret'></span></button>"
    html_string = html_string + "<ul class='dropdown-menu' role='menu' aria-labelledby='menu1'>"

  case object
    when "tabellen"
      html_string = html_string + build_nav3("tabellen",item,"tabellen_kategorien",1)
      
    when "personen"
      html_string = html_string + build_nav3("personen",item,"personen_info",1)
      html_string = html_string + build_nav3("personen",item,"personen_zeiterfassung", item.timetracks.count)
      html_string = html_string + build_nav3("personen",item,"personen_ressourcenplanung", item.plannings.count)
      #html_string = html_string + build_nav3("personen",item,"personen_projekte", item.mobjects.where('mtype=? and parent=?',"projekte",0).count)
      html_string = html_string + build_nav3("personen",item,"personen_gruppen", item.mobjects.where('mtype=?',"gruppen").count)
      html_string = html_string + build_nav3("personen",item,"personen_institutionen",item.companies.count)
      html_string = html_string + build_nav3("personen",item,"personen_zugriffsberechtigungen", item.credentials.count)
      html_string = html_string + build_nav3("personen",item,"personen_stellvertretungen", item.deputies.count)
      if user_signed_in?
        #html_string = html_string + build_nav3("personen",item,"personen_charges", item.charges.count)
      end

    when "institutionen"
        html_string = html_string + build_nav3("institutionen",item,"institutionen_info",1)
        html_string = html_string + build_nav3("institutionen",item,"institutionen_projektliste", item.mobjects.where('mtype=? and parent=?',"projekte",0).count)
        html_string = html_string + build_nav3("institutionen",item,"institutionen_projektplan", item.mobjects.where('mtype=? and parent=?',"projekte",0).count)
        html_string = html_string + build_nav3("institutionen",item,"institutionen_projektressourcen", item.mobjects.where('mtype=? and parent=?',"projekte",0).count)
        html_string = html_string + build_nav3("institutionen",item,"institutionen_projektilv", item.mobjects.where('mtype=? and parent=?',"projekte",0).count)
        if item.partner
          html_string = html_string + build_nav3("institutionen",item,"institutionen_partnerlinks", item.partner_links.count)
        end
        if user_signed_in?
          #html_string = html_string + build_nav3("institutionen",item,"institutionen_charges", item.charges.count)
          if current_user.id == item.user_id or isdeputy(item.user)
            html_string = html_string + build_nav3("institutionen",item,"institutionen_params", item.company_params.count)
          end
        end

      when "objekte"
        # if item.owner_type == "User"
        #   html_string = html_string + build_nav3("personen",item.owner,"personen_"+item.mtype,1)
        # end
        # if item.owner_type == "Company"
        #   html_string = html_string + build_nav3("institutionen",item.owner,"institutionen_"+item.mtype,1)
        # end

        html_string = html_string + build_nav3("objekte",item,"objekte_info",1)
        html_string = html_string + build_nav3("objekte",item,"objekte_projektplan", item.pplans.count)
        html_string = html_string + build_nav3("objekte",item,"objekte_details",item.mdetails.where('mtype=?',"details").count)
        if item.mtype == "projekte"
          if user_signed_in?
            if isowner(item) or isdeputy(item.owner) or ispl(item)
              html_string = html_string + build_nav3("objekte",item,"objekte_substruktur", Mobject.where('parent=?',item.id).count)
            end
          end
          html_string = html_string + build_nav3("objekte",item,"objekte_ressourcenplanung", item.plannings.count)
          html_string = html_string + build_nav3("objekte",item,"objekte_auftragscontrolling", item.timetracks.count)
        end

        if item.mtype == "gruppen"
          html_string = html_string + build_nav3("objekte",item,"objekte_gruppenmitglieder", item.madvisors.where('role=?',item.mtype).count)
          html_string = html_string + build_nav3("objekte",item,"objekte_ressourcenplanunggruppe", item.madvisors.where('role=?',item.mtype).count)
        end

        if user_signed_in?
          if isowner(item) or isdeputy(item.owner) or ispl(item)
            html_string = html_string + build_nav3("objekte",item,"objekte_projektberechtigungen", item.madvisors.where('role=?',item.mtype).count)
          end
        end

    end

    html_string = html_string + '</ul>'
    html_string = html_string + action_buttons4(object, item, topic)
    html_string = html_string + '</div>'

    #html_string = html_string + '</ul>'
    #html_string = html_string + '</li>'
    #html_string = html_string + '</ul>'

    #html_string = html_string + action_buttons4(object, item, topic)

    return html_string.html_safe
    
end

def build_nav3(domain, item, domain2, anz)
  
  pos = domain2.index("_")
  infosymbol = (domain2[pos+1..domain2.length-1]).to_sym
  txt = getinfo2(infosymbol)["infotext"]

  case domain
    when "personen"
      unipath = user_path(:id => item.id, :topic => domain2)
    when "institutionen"
      unipath = company_path(:id => item.id, :topic => domain2)
    when "objekte"
      unipath = mobject_path(:id => item.id, :topic => domain2)
    when "tabellen"
      unipath = home_index9_path
  end

  html_string = ""

  if (!user_signed_in? and $activeapps.include?(domain2)) or (user_signed_in? and getUserCreds.include?(domain2)) or (user_signed_in? and current_user.superuser) 

    if anz > 0 and infosymbol != :info
        badge = content_tag(:span, anz.to_s, class:"badge pull right")
    else
        badge = ""
    end 
    if anz > 0 
      sel = "menu-active"
    else
      sel = "menu-inactive"
    end

    #html_string = html_string + '<li class="nav-item">'
    html_string = html_string + '<li role="presentation"><a role="menuitem" tabindex="-1">'
      html_string = html_string + link_to(unipath) do
        content_tag(:span, content_tag(:b, " " + txt) + " " + badge, class:"fa fa-" + getinfo2(infosymbol)["info"])
      end
    html_string = html_string + "</li>"
    html_string = html_string + "<li class='divider'></li>"
  end

  return html_string.html_safe
end

def action_buttons4(object_type, item, topic)
  
  html_string = ''

  case object_type 
    when "kategorien"
      html_string = html_string + link_to(home_index9_path) do
        content_tag(:i, " " + (I18n.t :uebersicht), class: "btn btn-default fa fa-list  pull-right")
      end
      html_string = html_string + link_to(new_mcategory_path(:ctype => item)) do
        content_tag(:i, " " + (I18n.t :kategorie) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus  pull-right")
      end

    when "personen"
      case topic
        when "personen_info"
          if user_signed_in? 
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              
                  html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher)})  do
                      content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red pull-right")
                  end

                  #def modalForm(mode, header, object_type, item, owner, owner_type, mtype, param)
                  #html_string = html_string + modalForm("change", item.fullname,"personen", item, nil, nil, nil, nil)
                  #modalNo = 1
                  #html_string = html_string + '<button type="button" class="btn btn-primary fa fa-wrench pull-right" data-toggle="modal" data-target="#myModal'+modalNo.to_s()+'"> ' + (I18n.t :aendern) +'</button>'
                  # html_string = html_string + link_to(edit_user_path(item)) do
                  #   content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary data-toggle='modal' data-target='#myModal' fa fa-wrench pull-right")
                  # end
                  html_string = html_string + link_to(edit_user_path(item)) do
                     content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench pull-right")
                  end
            end
            html_string = html_string + link_to(new_webmaster_path(:object_name => "User", :object_id => item.id, :user_id => current_user.id)) do
              content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange pull-right")
            end
          end
          html_string = html_string + link_to(users_path) do
            content_tag(:i, " " + (I18n.t :suchen), class:"btn btn-default fa fa-search pull-right") 
          end

        when "personen_institutionen"
          html_string = html_string + link_to(companies_path) do
            content_tag(:i, " " + (I18n.t :institutionenuebersicht), class: "btn btn-default fa fa-copyright-mark pull-right")
          end
          if user_signed_in?
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_company_path(:user_id => current_user.id)) do
                 content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange  pull-right") 
              end
            end
          end

        when "personen_projekte", "personen_gruppen"
          if user_signed_in?
            if current_user.id == item.id or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_mobject_path(:user_id => current_user.id, :mtype => subtopic(topic), :msubtype => nil)) do
                 content_tag(:i, " " + (I18n.t subtopic(topic)), class: "btn btn-primary fa fa-plus orange pull-right")
              end
            end
            if topic == "personen_projekte"
              if current_user.id == item.id or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(user_path(:id => @user.id, :topic => "personen_export")) do
                  content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :exportieren), class: "btn btn-default fa fa-download pull-right")
                end
              end
            end
          end
          if topic == "personen_projekte"
            html_string = html_string + link_to(mobjects_path :mtype => getTopicName(topic)) do
              content_tag(:i, " " + (I18n.t subtopic(topic).to_sym), class: "btn btn-default fa fa-search pull-right")
            end
          end

        when "personen_export"
          if user_signed_in?
            html_string = html_string + link_to(user_path(:id => @user.id, :topic => topic, :year => @c_year, :month => @c_month, :mode => @c_mode, :topic => topic, :writeexcel => true)) do
              content_tag(:i, " " + (I18n.t :excel), class: "btn btn-default fa fa-th  pull-right")
            end
          end

        when "personen_stellvertretungen"
             if user_signed_in?
              if (item.id == current_user.id) or current_user.superuser
                html_string = html_string + link_to(users_path(:mode => "deputy", :user_id => item.id)) do
                  content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange pull-right")
                end
              end
             end

        when "personen_zeiterfassung"
             if user_signed_in? and false
              if (item.id == current_user.id) or current_user.superuser
                html_string = html_string + link_to(new_timetrack_path(:user_id => @user.id, :scope => "aufwand", :datum => @c_datum)) do
                  content_tag(:i, " " + (I18n.t :aufwand) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange  pull-right")
                end
                html_string = html_string + link_to(new_timetrack_path(:user_id => @user.id, :scope => "kosten", :datum => @c_datum)) do
                  content_tag(:i, " " + (I18n.t :kosten) + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange  pull-right")
                end
              end
             end

      end

    when "institutionen"
      case topic
        when "institutionen_info"
          if user_signed_in?
            if current_user.id == item.user_id or isdeputy(item) or current_user.superuser

              html_string = html_string + link_to(edit_company_path(item), title: (I18n.t :bearbeiten)) do
                 content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench  pull-right")
              end
              html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher) }) do
                  content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red  pull-right")
              end
            end
            html_string = html_string + link_to(new_webmaster_path(:object_name => "Company", :object_id => item.id, :user_id => current_user.id)) do
              content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange  pull-right")
            end
          end
          html_string = html_string + link_to(companies_path(:page => session[:page]), title: (I18n.t :institutionen)) do
            content_tag(:i, " " + (I18n.t :suchen), class:"btn btn-default fa fa-search  pull-right") 
          end

        when "institutionen_projektliste"
          html_string = html_string + link_to(mobjects_path :mtype => "projekte") do
            content_tag(:i, " " + (I18n.t :suchen), class: "btn btn-default fa fa-search  pull-right")
          end
          if user_signed_in?
            if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_mobject_path :company_id => item.id, :mtype => "projekte", :msubtype => nil) do
                #content_tag(:i, " " + (I18n.t subtopic(topic)), class: "btn btn-primary fa fa-plus orange  pull-right")
                content_tag(:i, " " + (I18n.t :projekte), class: "btn btn-primary fa fa-plus orange  pull-right")
              end
            end
          end

        when "institutionen_projektilv"
          html_string = html_string + link_to(company_path(:id => item.id, :topic => "institutionen_projektilv", :year => @c_year, :month => @c_month, :mode => @c_mode, :writeexcel => true)) do
            content_tag(:i, " " + (I18n.t :excel), class: "btn btn-default fa fa-th  pull-right")
          end
          
        when "institutionen_partnerlinks"
          if user_signed_in?
            if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_partner_link_path :company_id => item.id) do
                content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange  pull-right")
              end
            end
          end

        when "institutionen_params"
          if user_signed_in?
            if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
              html_string = html_string + link_to(new_company_param_path :company_id => item.id) do
                content_tag(:i, " " + (I18n.t subtopic(topic)) + " " + (I18n.t :hinzufuegen), class: "btn btn-primary fa fa-plus orange  pull-right")
              end
            end
          end

        when "institutionen_stellvertretungen"
             if user_signed_in?
              if (item.user_id == current_user.id) or isdeputy(item) or current_user.superuser
                html_string = html_string + link_to(deputies_path(:company_id => item.id)) do
                  content_tag(:i, " " + (I18n.t subtopic(@topic)) + " " + (I18n.t :hinzufuegen), class:"btn btn-default fa fa-plus orange  pull-right")
                end
              end
             end

        when "institutionen_export"
          if user_signed_in?
            html_string = html_string + link_to(company_path(:id => @company.id, :year => @c_year, :month => @c_month, :mode => @c_mode, :topic => topic, :writeexcel => true)) do
              content_tag(:i, " " + (I18n.t :excel), class: "btn btn-default fa fa-th  pull-right")
            end
          end

            
      end

    when "objekte"
       case topic
          when "objekte_info"
             if user_signed_in?
               if isowner(item) or isdeputy(item.owner) or ispl(item)
         	        html_string = html_string + link_to(edit_mobject_path(item), title: (I18n.t :bearbeiten)) do
                     content_tag(:i, " "+(I18n.t :aendern), class: "btn btn-primary fa fa-wrench  pull-right")
                  end
         	        html_string = html_string + link_to(item, method: :delete, data: { confirm: (I18n.t :sindsiesicher) } ) do
                    content_tag(:i, " " + (I18n.t :loeschen), class: "btn btn-danger fa fa-trash red  pull-right")
                   end
               end
               html_string = html_string + link_to(new_webmaster_path(:object_name => "Mobject", :object_id => item.id, :user_id => current_user.id)) do
                  content_tag(:i, " " + (I18n.t :fraud), class: "btn btn-warning fa fa-ban orange  pull-right")
               end
             end
            if item.owner_type == "User"
               html_string = html_string + link_to(user_path(:id => item.owner.id, :topic => "personen_"+item.mtype)) do
                content_tag(:i, " "+ (I18n.t :uebersicht), class:"btn btn-default fa fa-eye pull-right") 
               end
            end
            if item.owner_type == "Company"
               html_string = html_string + link_to(company_path(:id => item.owner.id, :topic => "institutionen_"+item.mtype)) do
                content_tag(:i, " "+ (I18n.t :uebersicht), class:"btn btn-default fa fa-eye pull-right") 
               end
            end
             html_string = html_string + link_to(mobjects_path(:mtype =>item.mtype)) do
              content_tag(:i, " "+ (I18n.t :suchen), class:"btn btn-default fa fa-search  pull-right") 
             end
             if item.parent and item.parent > 0 
                html_string = html_string + link_to(mobject_path(:id => item.parent, :mtype => "projekte", :msubtype => nil, :topic => "objekte_info")) do
                  content_tag(:i, " " + (I18n.t :levelup), class:"btn btn-default fa fa-level-up  pull-right") 
                end
             end 

          when "objekte_details"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner) or ispl(item)
                  html_string = html_string + link_to(new_mdetail_path(:mobject_id => item.id, :mtype => "details")) do
                    content_tag(:i, " " + (I18n.t :details), class:"btn btn-primary fa fa-plus  pull-right") 
                  end
               end
              end

          when "objekte_projektplan"
              if user_signed_in?
                if isowner(item) or isdeputy(item.owner) or ispl(item)
                  html_string = html_string + link_to(new_pplan_path(:mobject_id => item.id)) do
                    content_tag(:i, " " + (I18n.t :task), class:"btn btn-primary fa fa-plus  pull-right") 
                  end
               end
              end

          when "objekte_substruktur"
             if user_signed_in?
                if isowner(item) or isdeputy(item.owner) or ispl(item)
                  if item.owner_type == "User"
                    html_string = html_string + link_to(new_mobject_path :user_id => item.owner_id, :mtype => "projekte", :msubtype => nil, :parent => item.id) do
                      content_tag(:i, " " + (I18n.t :substruktur), class:"btn btn-primary fa fa-plus pull-right") 
                    end
                  end
                  if item.owner_type == "Company"
                    html_string = html_string + link_to(new_mobject_path :company_id => item.owner_id, :mtype => "projekte", :msubtype => nil, :parent => item.id) do
                      content_tag(:i, " " + (I18n.t :substruktur), class:"btn btn-primary fa fa-plus pull-right") 
                    end
                  end
               end
              end

          when "objekte_projektberechtigungen"
             if user_signed_in?
                if isowner(item) or isdeputy(item.owner) or ispl(item)
                  html_string = html_string + link_to(users_path :mobject_id => item.id, :mode => item.mtype) do
                      content_tag(:i, " " + (I18n.t :Berechtigungen), class:"btn btn-primary fa fa-plus orange  pull-right") 
                  end
                  # #groups = item.owner.mobjects.where('mtype=?',"gruppen")
                  # groups = current_user.mobjects.where('mtype=?',"gruppen")
                  # groups.each do |g|
                  #   html_string = html_string + link_to(mobject_path :mobject_id => item.id, :topic => topic, :group_id => g.id) do
                  #       content_tag(:i, " " + g.name + " " + (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange  pull-right") 
                  #   end
                  # end
               end
              end
              
          when "objekte_gruppenmitglieder"
             if user_signed_in?
                if isowner(item) or isdeputy(item.owner)
                  html_string = html_string + link_to(users_path :mobject_id => item.id, :mode => item.mtype) do
                      content_tag(:i, (I18n.t :hinzufuegen), class:"btn btn-primary fa fa-plus orange  pull-right") 
                  end
               end
              end

          when "objekte_auftragscontrolling"
            if user_signed_in?
              html_string = html_string + link_to(mobject_path(:id => @mobject.id, :topic => "objekte_auftragscontrolling", :year => @c_year, :month => @c_month, :mode => @c_mode, :scope => @c_scope, :writeexcel => true)) do
                content_tag(:i, " " + (I18n.t :excel), class:"btn btn-default fa fa-th  pull-right") 
              end
              # if @export and @filename
    	         # html_string = html_string +link_to(@filename.remove("public")) do
              #     content_tag(:i, " " + (I18n.t :download) , class:"btn btn-default fa fa-download  pull-right") 
              #   end
              # end

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
    when :params
      info = "cog"
    when :menu
      info = "medium"
    when :stellvertretungen
      info = "share"
    when :projekte, :projektliste, :projektplan
      info = "tasks"
    when :institutionen
      info = "industry"
    when :zeiterfassung
      info = "safari"
    when :ressourcenplanung
      info = "first-order"
    when :gruppen
      info = "th"
    when :zugriffsberechtigungen, :projektberechtigungen, :berechtigungen
      info = "lock"
    when :news
      info = "alert"
    when :personen, :gruppenmitglieder, :projektressourcen
      info = "user"
    when :details
      info = "search"
    when :charges, :projektilv
      info = "euro"
    when :zugriffsberechtigungen, :projektberechtigungen
      info = "lock"
    when :auftragscontrolling
      info = "cube"
    when :substruktur
      info = "cog"
    when :partnerlinks
      info = "globe"
    when :ausschreibungsangebote
      info = "book"
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
    html_string = html_string + '<h2 class="service-title pad-bt15">Services</h2>'
    #html_string = html_string + '<p class="sub-title pad-bt15">folgende Services sind aktuell verfügbar.</p>'
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

    domain = "ressourcenplanung"
    if user_signed_in? and creds.include?("personen_ressourcenplanung")
        path = user_path(:id => current_user.id, :topic => "personen_ressourcenplanung")
        html_string = html_string + simple_menue(domain, path)
    end

    domain = "projekte"
    if creds.include?("hauptmenue_"+domain)
        path = mobjects_path(:mtype => domain, :msubtype => "root", :parent => 0)
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
    domains << "kapaplanung"
    domains << "projekte"
    domains << "personen"
    domains << "institutionen"

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
        content_tag(:i, nil, class:"fa fa-" + getinfo2(domain.to_sym)["info"], style:"font-size:3em") + " " + content_tag(:i, domain.upcase, style:"font-size:1em; color:black") 
      end
      #html_string = html_string + " " + domain.upcase
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

def image_def (objekt, mtype)
    case objekt
      when $app_name
        pic = "connect.jpg"
      when "personen"
        pic = "user.jpg"
      when "institutionen"
        pic = "company.jpg"
      when "objekte"
        pic = "fragen.jpg"
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
    hash = {"domain" => "hauptmenue", "right" => "personen", "access" => true, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "institutionen", "access" => true, "info" => "news", "fee" => 0}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "hauptmenue", "right" => "projekte", "access" => true, "info" => "payable", "fee" => 700}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "personen", "right" => "info", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "institutionen", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "personen", "right" => "gruppen", "access" => true, "info" => "news"}
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
    hash = {"domain" => "personen", "right" => "charges", "access" => true, "info" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "info", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "projektliste", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "projektplan", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "projektressourcen", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "projektilv", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "partnerlinks", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "charges", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "params", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "institutionen", "right" => "rollen", "access" => true, "info" => "news"}
    @array << hash

    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "info", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "projektplan", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "details", "access" => true, "info" => "news"}
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
    hash = {"domain" => "objekte", "right" => "ressourcenplanunggruppe", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "projektdashboard", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "gruppenmitglieder", "access" => true, "info" => "news"}
    @array << hash
    hash = Hash.new
    hash = {"domain" => "objekte", "right" => "substruktur", "access" => true, "info" => "news"}
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

def ispl(mobject)
  zugriff = false
  if mobject.mtype == "projekte"
    if mobject.madvisors.where('role=? and grade=? and user_id=?', "projekte", "Projektleiter", current_user.id).count > 0
      zugriff = true
    end
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

def zugriffsliste(mobjects, mtype, user)
  array = []
  if user_signed_in?
      if mobjects != nil or mobject.count > 0
        mobjects.each do |m|
            #wenn Owner ok or deputy of Owner 
            if isowner(m) or isdeputy(m.owner)
              array << m.id
            end
            #wenn Berechtigung ok
            m.madvisors.where('role=?',mtype).each do |a|
              if current_user.id == a.user_id
                if !array.include?(m.id)
                  array << m.id
                end
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

def modalForm(mode, header, object_type, item, owner, owner_type, mtype, param)
  button_html = ""
  if mode == "change"
    button_html = button_html + '<button type="button" class="btn btn-primary fa fa-wrench pull-right" data-toggle="modal" data-target="#myModal"> ' + (I18n.t :aendern) +'</button>'
  end
  if mode == "new"
    button_html = button_html + '<button type="button" class="btn btn-primary fa fa-plus pull-right" data-toggle="modal" data-target="#myModal"> ' + (I18n.t :hinzufuegen) +'</button>'
  end
  
  html=""
  #html = html + '<myModalContent>'
    case object_type 
      when "personen"
        @user = item
        html = html + render("users/form")
      when "institutionen"
        @company = item
        if mode == "new"
          @company = Company.new
          @company.user_id = owner.id
          @company.active = true
          @company.social = false
          @company.status = "OK"
          @company.partner = false
        end
        html = html + render("companies/form")
      when "objekte"
        @mobject = item
        if mode == "new"
          @mobject.status = "OK"
          @mobject.mtype = mtype
          @mobject.freecat1 = ""
          @mobject.freecat2 = ""
          @mobject.freecat3 = ""
          @mobject.active = true
          @mobject.online_pub = false
          @mobject.name = ""
          @mobject.description = ""
          @mobject.homepage = ""
          @mobject.costinfo = ""
          @mobject.orderinfo = ""
          @mobject.date_from = Date.today
          @mobject.date_to = Date.today+30
          @mobject.sum_pkosten_ist = 0
          @mobject.sum_pkosten_plan = 100000
          @mobject.sum_paufwand_ist = 0
          @mobject.sum_paufwand_plan = 100
          @mobject.quality = "hoch"
          @mobject.risk = "tief"
          @mobject.allow = false
          @mobject.allowdays = 5
          if param
            @mobject.parent = param.to_i
          else
            @mobject.parent = 0
          end
          @mobject.owner_id = owner.id
          @mobject.owner_type = owner_type
        end
        html = html + render("mobjects/form")

      when "zeiterfassung"
        @timetrack = item
        if mode == "new"
          if params[:mobject_id]
            @timetrack.mobject_id = params[:mobject_id]
          else
            @advisors = current_user.madvisors.where('role=?',"projekte")
            if @advisors.first
              @timetrack.mobject_id = @advisors.first.mobject_id
              @mobs = []
              @mobsID = []
              @advisors.each do |m|
                if Mobject.find(m.mobject_id).active
                  @mobs << [m.mobject.name, m.mobject_id]
                  @mobsID << m.mobject_id
                end
              end
              
              @mobs = []
              @mobjects = Mobject.where('id IN (?)', @mobsID).order(:name)
              @mobjects.each do |m|
                @mobs << [m.name, m.id]
              end
            else
              redirect_to user_path(:id => params[:user_id], :topic => "personen_zeiterfassung"), notice: (I18n.t :noprojects)
            end
          end
          @timetrack.user_id = owner.id
          @timetrack.costortime = mtype
          if param
            @timetrack.datum=param
          else
            @timetrack.datum=Date.today.strftime('%Y-%m-%d')
          end
          if @timetrack.costortime == "aufwand"
            @timetrack.amount = 8.0
            @timetrack.activity = ""
          end
          if @timetrack.costortime == "kosten"
            @timetrack.amount = 25000.00
            @timetrack.activity = ""
          end
        end
        html = html + render("timetracks/form")
  end
  #html = html + '</myModalContent>'
  html = html + render("users/form")
  button_html = button_html + "<script>$('myModalContent').replaceWith('"+ html + "');</script>"
  return button_html.html_safe
end

def modalUserForm(user, mode, modalNo)
  #<!--Modal Window for Changes-->
  html = '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js"></script>'
  html = html + '<div class="modal" id="myModal' + modalNo.to_s() + ">'"
    html = html + '<div class="modal-dialog">'
      html = html + '<div class="modal-content">'
        #<!-- Modal Header -->
        html = html + '<div class="modal-header modal-title" style="color:grey">' + "<modalFormHeader>need to be replaced<modalFormHeader>"
          html = html + '<button type="button" class="close" data-dismiss="modal">&times;</button>'
        html = html + '</div>'
        #<!-- Modal body -->
        html = html + '<div class="modal-body">'
        html = html + '<myModalContent>'
          @user = user
          html = html + render("users/form")
        html = html + '</div>'
        #<!-- Modal footer -->
        #html = html + '<div class="modal-footer">'
          #html = html + '<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>'
        #html = html + '</div>'
      html = html + '</div>'
    html = html + '</div>'
  html = html + '</div>'
  return html.html_safe
end

def subids(mobject_id, subs)
  @subprojects = Mobject.where('parent=?', mobject_id)
  @subprojects.each do |p|
    subs << p.id
    subids(p.id, subs)
  end
  return subs
end

def controlRes(user_id, mobject_id, scope, mode, von, bis, jahr, monat)

  #substruktur 
  @subs = []
  @subs << mobject_id
  @subs = subids(mobject_id, @subs)
  if user_id
    @tts = Timetrack.select("jahrmonat, sum(amount) as summe").where('user_id=? and mobject_id in (?) and costortime=? and datum>=? and datum<=?', user_id, @subs, scope, von, bis).group("jahrmonat").order(:jahrmonat)
    @pts = Planning.select("jahrmonat, sum(amount) as summe").where('user_id=? and mobject_id in (?) and costortime=? and jahr=?', user_id, @subs, scope, jahr.to_s).group("jahrmonat").order(:jahrmonat)
  else
    @tts = Timetrack.select("jahrmonat, sum(amount) as summe").where('mobject_id in (?) and costortime=? and datum>=? and datum<=?', @subs, scope, von, bis).group("jahrmonat").order(:jahrmonat)
    @pts = Planning.select("jahrmonat, sum(amount) as summe").where('mobject_id in (?) and costortime=? and jahr=?',@subs, scope, jahr.to_s).group("jahrmonat").order(:jahrmonat)
  end

  @dataTT = []
  @labelTT = []
  @dataPT = []
  @labelPT = []
  @dataTTad = []
  @dataPTad = []
  @tts.each do |t|
    @dataTT << t.summe
    @labelTT << t.jahrmonat
  end
  for monat in 1..12
    monats = monat.to_s
    if monats.length == 1
      monats = "0"+monats
    end
    c_jahrmonat = jahr.to_s + "-" + monats
    found=false
    for i in 0..@dataTT.length()-1
      if c_jahrmonat == @labelTT[i]
        found=true
        datval = @dataTT[i]
      end
    end
    if found
      @dataTTad << datval
    else
      @dataTTad << 0
    end
  end
  
  @pts.each do |t|
    @dataPT << ((t.summe * 170) / 100)
    @labelPT << t.jahrmonat
  end
  for monat in 1..12
    monats = monat.to_s
    if monats.length == 1
      monats = "0"+monats
    end
    c_jahrmonat = jahr.to_s + "-" + monats
    found=false
    for i in 0..@dataPT.length()-1
      if c_jahrmonat == @labelPT[i]
        found=true
        datval = @dataPT[i]
      end
    end
    if found
      @dataPTad << datval
    else
      @dataPTad << 0
    end
  end

  @dataTTkum = []  
  @dataPTkum = []
  @dataTTkum << @dataTTad[0]
  @dataPTkum << @dataPTad[0]
  for i in 1..@dataTTad.length-1
    @dataTTkum << @dataTTad[i] + @dataTTkum[i-1]
    @dataPTkum << @dataPTad[i] + @dataPTkum[i-1]
  end

  return {:dataTT => @dataTTad, :dataPT => @dataPTad, :dataTTkum => @dataTTkum, :dataPTkum => @dataPTkum}
end

def exportProjekt (mobject, scope)
  filename = "public/projectreport_projekt"+mobject.id.to_s+".xls"
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
  f_header1.set_bg_color('black')
  #f_header1.set_bg_color(57)

  f_header2 = workbook.add_format
  f_header2.set_color('white')
  #f_header1.set_bg_color('black')
  f_header2.set_bg_color('red')

  f_header3 = workbook.add_format
  f_header3.set_color('white')
  f_header3.set_bg_color('grey')
  #f_header2.set_bg_color('red')

  f_param = workbook.add_format
  f_param.set_bold
  f_param.set_color('red')

  # col sizes
  worksheet.set_column(0,40,20)
  
  row = 0
  col = 0
  worksheet.write(row, col, (I18n.t :auftragscontrolling) + " " + Mobject.find(mobject).name + " " + DateTime.now.strftime("%d.%m.%y-%H:%M"), f_header0)

  #alle Unterstrukturen
  @subs = []
  @subs << mobject.id
  @subs = subids(mobject.id, @subs)

  @tts = Timetrack.select("jahrmonat, sum(amount) as summe").where('mobject_id in(?) and costortime=?', @subs, scope).group("jahrmonat").order(:jahrmonat)
  @pts = Planning.select("jahrmonat, sum(amount) as summe").where('mobject_id in(?) and costortime=?', @subs, scope).group("jahrmonat").order(:jahrmonat)

  #datum range
  @start = Date.today.year.to_s + "-" + "01"
  @end = Date.today.year.to_s + "-" + "12"
  if @tts.first != nil
    @start = @tts.first.jahrmonat
    @end = @tts.last.jahrmonat
  end
  if @pts.first != nil
    if @pts.first.jahrmonat < @start
      @start = @pts.first.jahrmonat
    end
    if @pts.last.jahrmonat > @end
      @end = @pts.last.jahrmonat
    end
  end

  row = row + 3
  worksheet.write(row, 0, Mobject.find(mobject).name , f_header0)
  row = row + 1
  #Datum Range
  range = getDatumRange(@start, @end)
  col=1
  for i in 0..range.length-1
    worksheet.write(row, col, range[i], f_header1)
    col=col+1
  end

  data = getReportData(range, @tts)
  row = row + 1
  worksheet.write(row, 0, scope + " IST kumuliert", f_header1)
  worksheet.write(row+1, 0, scope + " IST", f_header1)
  col=1
  for i in 0..data[:data].length-1
    worksheet.write(row, col, data[:datakum][i], f_header2)
    worksheet.write(row+1, col, data[:data][i])
    col=col+1
  end
  data = getReportData(range, @pts)
  row = row + 2
  worksheet.write(row, 0, scope + " PLAN kumuliert", f_header1)
  worksheet.write(row+1, 0, scope + " PLAN", f_header1)
  col=1
  for i in 0..data[:data].length-1
    worksheet.write(row, col, data[:datakum][i])
    worksheet.write(row+1, col, data[:data][i])
    col=col+1
  end

  # nur wenn Unterprojekte
    for m in 0..@subs.length-1

      #if m == 0
        #@tts = Timetrack.select("jahrmonat, sum(amount) as summe").where('mobject_id in (?) and costortime=?', @subs, scope).group("jahrmonat").order(:jahrmonat)
        #@pts = Planning.select("jahrmonat, sum(amount) as summe").where('mobject_id in (?) and costortime=?', @subs, scope).group("jahrmonat").order(:jahrmonat)
      #else
        @tts = Timetrack.select("jahrmonat, sum(amount) as summe").where('mobject_id =? and costortime=?', @subs[m], scope).group("jahrmonat").order(:jahrmonat)
        @pts = Planning.select("jahrmonat, sum(amount) as summe").where('mobject_id = ? and costortime=?', @subs[m], scope).group("jahrmonat").order(:jahrmonat)
      #end
  
      data = getReportData(range, @tts)
      row = row + 3
      worksheet.write(row, 0, Mobject.find(@subs[m]).name , f_header0)
      
      row = row + 1
      worksheet.write(row, 0, scope + " IST kumuliert", f_header1)
      worksheet.write(row+1, 0, scope + " IST", f_header1)
      col=1
      for i in 0..data[:data].length-1
        worksheet.write(row, col, data[:datakum][i], f_header2)
        worksheet.write(row+1, col, data[:data][i])
        col=col+1
      end
  
      data = getReportData(range, @pts)
      row = row + 2
      worksheet.write(row, 0, scope + " PLAN kumuliert", f_header1)
      worksheet.write(row+1, 0, scope + " PLAN", f_header1)
      col=1
      for i in 0..data[:data].length-1
        worksheet.write(row, col, data[:datakum][i])
        worksheet.write(row+1, col, data[:data][i])
        col=col+1
      end

      #alle MA
      #if m == 0
        #@tts = Timetrack.select("jahrmonat, sum(amount) as summe").where('mobject_id in (?) and costortime=?', @subs, scope).group("jahrmonat").order(:jahrmonat)
        #@pts = Planning.select("jahrmonat, sum(amount) as summe").where('mobject_id in (?) and costortime=?', @subs, scope).group("jahrmonat").order(:jahrmonat)
      #else
        @ttsma = Timetrack.select("user_id").where('mobject_id =? and costortime=?', @subs[m], scope).distinct
        @ptsma = Planning.select("user_id").where('mobject_id=? and costortime=?', @subs[m], scope).distinct
      #end
      malist = []
      @ttsma.each do |ma|
        malist << ma.user_id
      end
      @ptsma.each do |ma|
        if !malist.include?(ma.user_id)
          malist << ma.user_id
        end
      end

      if true
      for ma in 0..malist.length-1 do

        @ttsma = Timetrack.select("jahrmonat, sum(amount) as summe").where('user_id=? and mobject_id =? and costortime=?', malist[ma], @subs[m], scope).group("jahrmonat").order(:jahrmonat)
        @ptsma = Planning.select("jahrmonat, sum(amount) as summe").where('user_id = ? and mobject_id = ? and costortime=?', malist[ma], @subs[m], scope).group("jahrmonat").order(:jahrmonat)

        data = getReportData(range, @ttsma)
        row = row + 3
        @user = User.find(malist[ma])
        worksheet.write(row, 0, @user.name + " " + @user.lastname, f_header3)
        row = row + 1
        worksheet.write(row, 0, scope + " IST kumuliert", f_header1)
        worksheet.write(row+1, 0, scope + " IST", f_header1)
        col=1
        for i in 0..data[:data].length-1
          worksheet.write(row, col, data[:datakum][i], f_header3)
          worksheet.write(row+1, col, data[:data][i])
          col=col+1
        end

        data = getReportData(range, @ptsma)
        row = row + 2
        worksheet.write(row, 0, scope + " PLAN kumuliert", f_header1)
        worksheet.write(row+1, 0, scope + " PLAN", f_header1)
        col=1
        for i in 0..data[:data].length-1
          worksheet.write(row, col, data[:datakum][i])
          worksheet.write(row+1, col, data[:data][i])
          col=col+1
        end

      end
      row = row + 1
      end
  
    end

    workbook.close
    return filename

end

def getReportData(range, data)
  dataTT = []
  dataTTkum = []
  if data
    #init data
    for i in 0..range.length-1
      dataTT << 0
    end
    #fill data in right position
    data.each do |t|
      found = 0
      for i in 0..range.length-1
        if range[i] == t.jahrmonat
          dataTT[i] = t.summe
        end
      end
    end
    dataTTkum[0] = dataTT[0]
    for i in 1..range.length-1
      dataTTkum[i] = dataTTkum[i-1]+dataTT[i]
    end
  end
  return {:data => dataTT, :datakum => dataTTkum}
end

def getDatumRange(start, ende)
  datum = start
  labelTT = []
  while datum <= ende do
    labelTT << datum
    #calculate next date
    year = datum[0..3].to_i
    month = datum[5..6].to_i
    if month == 12
      months = "01"
      year = year + 1
    else
      month = month + 1
      months = month.to_s
      if months.length == 1
        months = "0" + months
      end
    end
    datum = year.to_s + "-" + months
  end
  return labelTT
end

end    