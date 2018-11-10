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

ActiveRecord::Schema.define(version: 2018_10_03_094422) do

# Could not dump table "admins" because of following StandardError
#   Unknown type 'string' for column 'contactno'

  create_table "guestusers", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.text "contactno", null: false
  end

# Could not dump table "missingdetails" because of following StandardError
#   Unknown type 'string' for column 'status'

  create_table "notifications", force: :cascade do |t|
    t.string "notification"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rescueteams", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "area"
    t.string "teamsize"
    t.string "contactno"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
