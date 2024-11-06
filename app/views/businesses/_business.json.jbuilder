json.extract! business, :id, :owner_id, :name, :address, :about, :created_at, :updated_at
json.url business_url(business, format: :json)
