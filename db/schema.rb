# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_27_080505) do
  create_table "albums", force: :cascade do |t|
    t.boolean "sharing_mode"
    t.string "description"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "connections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "follower_id", null: false
    t.integer "following_id", null: false
    t.index ["follower_id"], name: "index_connections_on_follower_id"
    t.index ["following_id"], name: "index_connections_on_following_id"
  end

  create_table "photos", force: :cascade do |t|
    t.boolean "sharing_mode"
    t.string "description"
    t.string "title"
    t.binary "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "album_id"
    t.index ["album_id"], name: "index_photos_on_album_id"
    t.index ["user_id"], name: "index_photos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.string "email"
    t.string "role"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
  end

  add_foreign_key "albums", "users"
  add_foreign_key "connections", "users", column: "follower_id"
  add_foreign_key "connections", "users", column: "following_id"
  add_foreign_key "photos", "albums"
  add_foreign_key "photos", "users"
end
