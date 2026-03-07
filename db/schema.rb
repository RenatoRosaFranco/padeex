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

ActiveRecord::Schema[8.1].define(version: 2026_03_07_000002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "court_id", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.time "ends_at", null: false
    t.time "starts_at", null: false
    t.string "status", default: "active", null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["court_id", "date"], name: "index_bookings_on_court_id_and_date"
    t.index ["court_id"], name: "index_bookings_on_court_id"
    t.index ["tenant_id", "court_id", "date", "starts_at"], name: "index_bookings_on_tenant_court_date_starts_active", unique: true, where: "((status)::text = 'active'::text)"
    t.index ["tenant_id"], name: "index_bookings_on_tenant_id"
    t.index ["user_id", "date"], name: "index_bookings_on_user_id_and_date"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "brand_integrations", force: :cascade do |t|
    t.string "api_key"
    t.bigint "brand_profile_id", null: false
    t.datetime "created_at", null: false
    t.string "label"
    t.string "provider", null: false
    t.string "status", default: "inactive", null: false
    t.string "store_url"
    t.datetime "updated_at", null: false
    t.index ["brand_profile_id", "provider"], name: "index_brand_integrations_on_brand_profile_id_and_provider", unique: true
    t.index ["brand_profile_id"], name: "index_brand_integrations_on_brand_profile_id"
  end

  create_table "brand_product_categories", force: :cascade do |t|
    t.bigint "brand_profile_id", null: false
    t.string "color", default: "#3628c5", null: false
    t.datetime "created_at", null: false
    t.string "icon", default: "box-fill", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["brand_profile_id", "name"], name: "index_brand_product_categories_on_profile_and_name", unique: true
    t.index ["brand_profile_id"], name: "index_brand_product_categories_on_brand_profile_id"
  end

  create_table "brand_products", force: :cascade do |t|
    t.bigint "brand_product_category_id"
    t.bigint "brand_profile_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "external_url"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_product_category_id"], name: "index_brand_products_on_brand_product_category_id"
    t.index ["brand_profile_id", "status"], name: "index_brand_products_on_brand_profile_id_and_status"
    t.index ["brand_profile_id"], name: "index_brand_products_on_brand_profile_id"
  end

  create_table "brand_profiles", force: :cascade do |t|
    t.string "brand_name"
    t.string "category"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "website"
    t.index ["user_id"], name: "index_brand_profiles_on_user_id", unique: true
  end

  create_table "club_profiles", force: :cascade do |t|
    t.string "address"
    t.integer "cancellation_hours", default: 3, null: false
    t.string "club_name"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "phone"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "website"
    t.index ["latitude", "longitude"], name: "index_club_profiles_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_club_profiles_on_user_id", unique: true
  end

  create_table "courts", force: :cascade do |t|
    t.bigint "club_id"
    t.string "court_type", null: false
    t.datetime "created_at", null: false
    t.integer "hourly_rate_cents"
    t.string "name", null: false
    t.string "status", default: "active", null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.index ["club_id", "name"], name: "index_courts_on_club_id_and_name", unique: true, where: "(club_id IS NOT NULL)"
    t.index ["club_id"], name: "index_courts_on_club_id"
    t.index ["tenant_id"], name: "index_courts_on_tenant_id"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "feature_key", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "follows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "followed_id", null: false
    t.bigint "follower_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id", "status"], name: "index_follows_on_followed_id_and_status"
    t.index ["followed_id"], name: "index_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.bigint "club_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email"
    t.string "internal_code"
    t.string "name", null: false
    t.string "phone"
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["club_id", "internal_code"], name: "index_instructors_on_club_id_and_internal_code", unique: true, where: "(internal_code IS NOT NULL)"
    t.index ["club_id"], name: "index_instructors_on_club_id"
    t.index ["tenant_id"], name: "index_instructors_on_tenant_id"
    t.index ["user_id"], name: "index_instructors_on_user_id"
  end

  create_table "investment_interests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "investment_range", null: false
    t.string "last_name", null: false
    t.text "message"
    t.string "phone"
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_investment_interests_on_email"
    t.index ["tenant_id"], name: "index_investment_interests_on_tenant_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "icon", default: "bell-fill", null: false
    t.string "icon_color", default: "purple", null: false
    t.datetime "read_at"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.bigint "user_id", null: false
    t.index ["user_id", "created_at"], name: "index_notifications_on_user_id_and_created_at"
    t.index ["user_id", "read_at"], name: "index_notifications_on_user_id_and_read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.string "cancel_url"
    t.datetime "created_at", null: false
    t.string "currency", default: "brl", null: false
    t.string "openpix_correlation_id"
    t.bigint "orderable_id", null: false
    t.string "orderable_type", null: false
    t.datetime "paid_at"
    t.text "pix_brcode"
    t.datetime "pix_expires_at"
    t.string "pix_qrcode_url"
    t.string "status", default: "pending", null: false
    t.string "stripe_checkout_session_id"
    t.string "success_url"
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["openpix_correlation_id"], name: "index_orders_on_openpix_correlation_id", unique: true, where: "(openpix_correlation_id IS NOT NULL)"
    t.index ["orderable_type", "orderable_id"], name: "index_orders_on_orderable"
    t.index ["stripe_checkout_session_id"], name: "index_orders_on_stripe_checkout_session_id", unique: true
    t.index ["tenant_id"], name: "index_orders_on_tenant_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "brl", null: false
    t.bigint "order_id", null: false
    t.string "payment_method_type"
    t.string "status", null: false
    t.string "stripe_payment_intent_id"
    t.jsonb "stripe_raw"
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id", unique: true, where: "(stripe_payment_intent_id IS NOT NULL)"
    t.index ["tenant_id"], name: "index_payments_on_tenant_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "author", default: "Equipe PADEEX", null: false
    t.text "content", null: false
    t.string "cover"
    t.datetime "created_at", null: false
    t.text "excerpt"
    t.datetime "published_at"
    t.string "slug"
    t.bigint "tenant_id"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["tenant_id"], name: "index_posts_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tenants_on_slug", unique: true
  end

  create_table "time_blocks", force: :cascade do |t|
    t.bigint "court_id", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.time "ends_at", null: false
    t.string "reason", null: false
    t.time "starts_at", null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.index ["court_id", "date"], name: "index_time_blocks_on_court_id_and_date"
    t.index ["court_id"], name: "index_time_blocks_on_court_id"
    t.index ["tenant_id"], name: "index_time_blocks_on_tenant_id"
  end

  create_table "tournament_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.decimal "entry_fee", precision: 8, scale: 2
    t.string "gender"
    t.string "level"
    t.integer "max_pairs"
    t.string "name", null: false
    t.integer "position", default: 0
    t.date "registration_deadline"
    t.bigint "tenant_id"
    t.bigint "tournament_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_tournament_categories_on_tenant_id"
    t.index ["tournament_id", "position"], name: "index_tournament_categories_on_tournament_id_and_position"
    t.index ["tournament_id"], name: "index_tournament_categories_on_tournament_id"
  end

  create_table "tournament_group_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "position", default: 0
    t.bigint "tournament_group_id", null: false
    t.bigint "tournament_registration_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_group_id", "tournament_registration_id"], name: "idx_unique_group_membership", unique: true
    t.index ["tournament_group_id"], name: "index_tournament_group_memberships_on_tournament_group_id"
    t.index ["tournament_registration_id"], name: "idx_on_tournament_registration_id_df8fb7aa22"
  end

  create_table "tournament_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "position", default: 0
    t.bigint "tenant_id"
    t.bigint "tournament_category_id", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_tournament_groups_on_tenant_id"
    t.index ["tournament_category_id", "position"], name: "index_tournament_groups_on_tournament_category_id_and_position"
    t.index ["tournament_category_id"], name: "index_tournament_groups_on_tournament_category_id"
  end

  create_table "tournament_matches", force: :cascade do |t|
    t.bigint "away_registration_id", null: false
    t.integer "away_score"
    t.bigint "court_id"
    t.datetime "created_at", null: false
    t.bigint "home_registration_id", null: false
    t.integer "home_score"
    t.integer "position", default: 0
    t.datetime "scheduled_at"
    t.string "status", default: "scheduled", null: false
    t.bigint "tenant_id"
    t.bigint "tournament_category_id", null: false
    t.bigint "tournament_group_id"
    t.datetime "updated_at", null: false
    t.index ["away_registration_id"], name: "index_tournament_matches_on_away_registration_id"
    t.index ["court_id"], name: "index_tournament_matches_on_court_id"
    t.index ["home_registration_id"], name: "index_tournament_matches_on_home_registration_id"
    t.index ["tenant_id"], name: "index_tournament_matches_on_tenant_id"
    t.index ["tournament_category_id"], name: "index_tournament_matches_on_tournament_category_id"
    t.index ["tournament_group_id"], name: "index_tournament_matches_on_tournament_group_id"
  end

  create_table "tournament_registrations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "partner_name"
    t.string "partner_phone"
    t.integer "position", default: 0
    t.string "status", default: "pending", null: false
    t.bigint "tenant_id"
    t.bigint "tournament_category_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["tenant_id"], name: "index_tournament_registrations_on_tenant_id"
    t.index ["tournament_category_id", "status"], name: "idx_on_tournament_category_id_status_d897a586cc"
    t.index ["tournament_category_id", "user_id"], name: "idx_unique_tournament_registration", unique: true
    t.index ["tournament_category_id"], name: "index_tournament_registrations_on_tournament_category_id"
    t.index ["user_id"], name: "index_tournament_registrations_on_user_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.bigint "club_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.date "ends_on", null: false
    t.decimal "entry_fee", precision: 8, scale: 2
    t.string "format"
    t.integer "max_teams"
    t.string "name", null: false
    t.date "starts_on", null: false
    t.string "status", default: "draft", null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.index ["club_id", "starts_on"], name: "index_tournaments_on_club_id_and_starts_on"
    t.index ["club_id"], name: "index_tournaments_on_club_id"
    t.index ["tenant_id", "status"], name: "index_tournaments_on_tenant_id_and_status"
    t.index ["tenant_id"], name: "index_tournaments_on_tenant_id"
  end

  create_table "user_identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["provider", "uid"], name: "index_user_identities_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_user_identities_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.text "bio"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.string "gender"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "username"
    t.index ["user_id"], name: "index_user_profiles_on_user_id", unique: true
    t.index ["username"], name: "index_user_profiles_on_username", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.boolean "accepted_terms", default: false, null: false
    t.boolean "admin", default: false, null: false
    t.integer "consumed_timestep"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "jti"
    t.string "kind", default: "user", null: false
    t.string "mobile_number"
    t.string "name", default: "", null: false
    t.boolean "newsletter_subscribed", default: true, null: false
    t.boolean "onboarding_completed", default: false, null: false
    t.integer "onboarding_days_remaining", default: 7, null: false
    t.boolean "otp_required_for_login", default: false, null: false
    t.string "otp_secret"
    t.string "provider"
    t.string "referral_code"
    t.bigint "referred_by_id"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "stripe_customer_id"
    t.bigint "tenant_id"
    t.string "uid"
    t.string "unsubscribe_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["kind"], name: "index_users_on_kind"
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true, where: "(provider IS NOT NULL)"
    t.index ["referral_code"], name: "index_users_on_referral_code", unique: true
    t.index ["referred_by_id"], name: "index_users_on_referred_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", unique: true, where: "(stripe_customer_id IS NOT NULL)"
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
    t.index ["unsubscribe_token"], name: "index_users_on_unsubscribe_token", unique: true
  end

  create_table "waitlist_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.bigint "tenant_id"
    t.datetime "updated_at", null: false
    t.index ["tenant_id", "email"], name: "index_waitlist_entries_on_tenant_id_and_email", unique: true
    t.index ["tenant_id"], name: "index_waitlist_entries_on_tenant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "courts"
  add_foreign_key "bookings", "tenants"
  add_foreign_key "bookings", "users"
  add_foreign_key "brand_integrations", "brand_profiles"
  add_foreign_key "brand_product_categories", "brand_profiles"
  add_foreign_key "brand_products", "brand_product_categories"
  add_foreign_key "brand_products", "brand_profiles"
  add_foreign_key "brand_profiles", "users"
  add_foreign_key "club_profiles", "users"
  add_foreign_key "courts", "tenants"
  add_foreign_key "courts", "users", column: "club_id"
  add_foreign_key "follows", "users", column: "followed_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "instructors", "tenants"
  add_foreign_key "instructors", "users"
  add_foreign_key "instructors", "users", column: "club_id"
  add_foreign_key "investment_interests", "tenants"
  add_foreign_key "notifications", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "posts", "tenants"
  add_foreign_key "time_blocks", "courts"
  add_foreign_key "time_blocks", "tenants"
  add_foreign_key "tournament_categories", "tournaments"
  add_foreign_key "tournament_group_memberships", "tournament_groups"
  add_foreign_key "tournament_group_memberships", "tournament_registrations"
  add_foreign_key "tournament_groups", "tournament_categories"
  add_foreign_key "tournament_matches", "courts"
  add_foreign_key "tournament_matches", "tournament_categories"
  add_foreign_key "tournament_matches", "tournament_groups"
  add_foreign_key "tournament_matches", "tournament_registrations", column: "away_registration_id"
  add_foreign_key "tournament_matches", "tournament_registrations", column: "home_registration_id"
  add_foreign_key "tournament_registrations", "tournament_categories"
  add_foreign_key "tournament_registrations", "users"
  add_foreign_key "tournaments", "tenants"
  add_foreign_key "tournaments", "users", column: "club_id"
  add_foreign_key "user_identities", "users"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "users", "tenants"
  add_foreign_key "users", "users", column: "referred_by_id"
  add_foreign_key "waitlist_entries", "tenants"
end
