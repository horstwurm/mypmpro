# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180918111431) do

  create_table "appparams", force: :cascade do |t|
    t.string   "domain"
    t.string   "parent_domain"
    t.string   "right"
    t.boolean  "access"
    t.string   "info"
    t.float    "fee"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "charges", force: :cascade do |t|
    t.integer  "appparam_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "stripe_id"
    t.string   "topic"
    t.string   "plan"
    t.float    "amount"
    t.date     "date_from"
    t.date     "date_to"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "status"
    t.boolean  "active"
    t.boolean  "partner"
    t.string   "name"
    t.integer  "mcategory_id"
    t.string   "stichworte"
    t.string   "homepage"
    t.integer  "user_id"
    t.text     "description"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["mcategory_id"], name: "index_companies_on_mcategory_id"
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "company_params", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credentials", force: :cascade do |t|
    t.integer  "appparam_id"
    t.integer  "user_id"
    t.boolean  "access"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["appparam_id"], name: "index_credentials_on_appparam_id"
    t.index ["user_id"], name: "index_credentials_on_user_id"
  end

  create_table "deputies", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "userid"
    t.date     "date_from"
    t.date     "date_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string   "header"
    t.text     "body"
    t.integer  "m_from"
    t.integer  "m_to"
    t.string   "status"
    t.string   "back_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["m_from"], name: "index_emails_on_m_from"
    t.index ["m_to"], name: "index_emails_on_m_to"
  end

  create_table "madvisors", force: :cascade do |t|
    t.integer  "mobject_id"
    t.integer  "user_id"
    t.string   "grade"
    t.float    "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "role"
    t.index ["mobject_id"], name: "index_madvisors_on_mobject_id"
    t.index ["user_id"], name: "index_madvisors_on_user_id"
  end

  create_table "mcategories", force: :cascade do |t|
    t.string   "name"
    t.string   "ctype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mdetails", force: :cascade do |t|
    t.integer  "mobject_id"
    t.string   "mtype"
    t.string   "name"
    t.string   "status"
    t.boolean  "headline"
    t.string   "textoptions"
    t.integer  "sequence"
    t.text     "description"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.index ["mobject_id"], name: "index_mdetails_on_mobject_id"
  end

  create_table "mobjects", force: :cascade do |t|
    t.string   "mtype"
    t.integer  "mcategory_id"
    t.string   "freecat1"
    t.string   "freecat2"
    t.string   "freecat3"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "status"
    t.string   "name"
    t.text     "description"
    t.date     "date_from"
    t.date     "date_to"
    t.boolean  "active"
    t.boolean  "online_pub"
    t.string   "keywords"
    t.string   "homepage"
    t.string   "termin"
    t.string   "kosten"
    t.string   "qualitaet"
    t.string   "gesamtstatus"
    t.string   "tendenz"
    t.string   "costinfo"
    t.string   "orderinfo"
    t.float    "sum_amount"
    t.float    "sum_paufwand_ist"
    t.float    "sum_pkosten_ist"
    t.float    "sum_paufwand_plan"
    t.float    "sum_pkosten_plan"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "parent"
    t.boolean  "allow"
    t.integer  "allowdays"
    t.index ["mcategory_id"], name: "index_mobjects_on_mcategory_id"
    t.index ["mtype"], name: "index_mobjects_on_mtype"
    t.index ["owner_id"], name: "index_mobjects_on_owner_id"
    t.index ["owner_type"], name: "index_mobjects_on_owner_type"
  end

  create_table "partner_links", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.text     "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "active"
    t.string   "link"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["company_id"], name: "index_partner_links_on_company_id"
  end

  create_table "plannings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mobject_id"
    t.string   "jahr"
    t.string   "monat"
    t.float    "amount"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "jahrmonat"
    t.string   "costortime"
    t.string   "description"
    t.index ["jahrmonat"], name: "index_plannings_on_jahrmonat"
    t.index ["mobject_id"], name: "index_plannings_on_mobject_id"
    t.index ["user_id"], name: "index_plannings_on_user_id"
  end

  create_table "pplans", force: :cascade do |t|
    t.integer  "mobject_id"
    t.integer  "version"
    t.string   "version_name"
    t.string   "task"
    t.date     "date_from"
    t.date     "date_to"
    t.string   "tasktype"
    t.integer  "position"
    t.integer  "poc"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "searches", force: :cascade do |t|
    t.string   "search_domain"
    t.string   "controller"
    t.string   "sql_string"
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.string   "keywords"
    t.string   "costinfo"
    t.string   "org"
    t.integer  "mcategory_id"
    t.string   "freecat1"
    t.string   "freecat2"
    t.string   "freecat3"
    t.datetime "date_from"
    t.datetime "date_to"
    t.datetime "date_created_at"
    t.string   "mtype"
    t.integer  "counter"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "timetracks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mobject_id"
    t.string   "activity"
    t.float    "amount"
    t.date     "datum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "jahrmonat"
    t.string   "costortime"
    t.index ["jahrmonat"], name: "index_timetracks_on_jahrmonat"
    t.index ["mobject_id"], name: "index_timetracks_on_mobject_id"
    t.index ["user_id"], name: "index_timetracks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "status"
    t.string   "lastname"
    t.string   "name"
    t.boolean  "active"
    t.boolean  "anonymous"
    t.boolean  "superuser"
    t.boolean  "webmaster"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.date     "dateofbirth"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "costinfo"
    t.float    "rate"
    t.string   "org"
    t.binary   "image"
    t.string   "stripe_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webmasters", force: :cascade do |t|
    t.string   "object_name"
    t.integer  "object_id"
    t.integer  "user_id"
    t.integer  "web_user_id"
    t.text     "user_comment"
    t.text     "web_user_comment"
    t.string   "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_webmasters_on_user_id"
    t.index ["web_user_id"], name: "index_webmasters_on_web_user_id"
  end

end
