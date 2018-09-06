# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

path=File.join(Rails.root, "/app/assets/images/")

#OBJECT branchen 1..28
mcategories = Mcategory.create({ctype:"branche", name:"Bau- und Erdarbeiten"})
mcategories = Mcategory.create({ctype:"branche", name:"Dachdeckerarbeiten"})
mcategories = Mcategory.create({ctype:"branche", name:"EDV Telekommunikation"})
mcategories = Mcategory.create({ctype:"branche", name:"Elektrikarbeiten"})
mcategories = Mcategory.create({ctype:"branche", name:"Entsorgung"})
mcategories = Mcategory.create({ctype:"branche", name:"Fenster, Türen, Glas"})
mcategories = Mcategory.create({ctype:"branche", name:"Fliesen und Platten"})
mcategories = Mcategory.create({ctype:"branche", name:"Garten und Landschaft"})
mcategories = Mcategory.create({ctype:"branche", name:"KFZ, Motorrad, Boote"})
mcategories = Mcategory.create({ctype:"branche", name:"Maler & Lackierer"})
mcategories = Mcategory.create({ctype:"branche", name:"Maurer, Beton, Estrich"})
mcategories = Mcategory.create({ctype:"branche", name:"Metallbau, Verarbeitung"})
mcategories = Mcategory.create({ctype:"branche", name:"Parkettböden, Teppichböden"})
mcategories = Mcategory.create({ctype:"branche", name:"Planung & Beratung"})
mcategories = Mcategory.create({ctype:"branche", name:"Putz & Stuck"})
mcategories = Mcategory.create({ctype:"branche", name:"Raumausstatter"})
mcategories = Mcategory.create({ctype:"branche", name:"Sonstige Dienstleistungen"})
mcategories = Mcategory.create({ctype:"branche", name:"Sonstige Handwerkerleistungen"})
mcategories = Mcategory.create({ctype:"branche", name:"Treppen- & Innenausbau"})
mcategories = Mcategory.create({ctype:"branche", name:"Umzüge, Transporte"})
mcategories = Mcategory.create({ctype:"branche", name:"Wege- & Pflasterarbeiten"})
mcategories = Mcategory.create({ctype:"branche", name:"Werbung, Druck, Schilder"})
mcategories = Mcategory.create({ctype:"branche", name:"Zimmer, Holz, Tischler"})
mcategories = Mcategory.create({ctype:"branche", name:"Essen Catering Lebensmittel"})
mcategories = Mcategory.create({ctype:"branche", name:"Bund Kanton Gemeinden"})
mcategories = Mcategory.create({ctype:"branche", name:"Vereine"})
mcategories = Mcategory.create({ctype:"branche", name:"Einzelhandel"})
mcategories = Mcategory.create({ctype:"branche", name:"Finanzdienstleistungen"})
    
#create Question categories 93..105
mcategories = Mcategory.create({ctype:"projekte", name:"STRATEGY"})
mcategories = Mcategory.create({ctype:"projekte", name:"CHANGE"})
mcategories = Mcategory.create({ctype:"projekte", name:"RUN"})
mcategories = Mcategory.create({ctype:"projekte", name:"LIFECYCLE"})

#create Question categories 93..105
mcategories = Mcategory.create({ctype:"gruppen", name:"private"})
mcategories = Mcategory.create({ctype:"gruppen", name:"public"})

#create some users...
users = User.create({org: "OE4711", costinfo: "KST0815", rate:150, dateofbirth:"09.05.1963", anonymous:false, status:"OK", active:true, email:"horst.wurm@bluewin.ch", password:"password", name:"Horst", lastname:"Wurm", address1:"Hörnliblick 11", address2:"Zezikon", address3:"Thurgau", superuser:true, webmaster:true, avatar:File.open(path+'horst.gif', 'rb')})

#create some companies...
companies = Company.create({status:"OK", active:true, user_id:1, name:"Thurgauer Kantonalbank", mcategory_id:28 ,stichworte: "", address1:"Bankplatz 1", address2:"Weinfelden", address3:""})