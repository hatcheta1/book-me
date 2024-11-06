json.extract! service, :id, :business_id, :name, :description, :duration, :price, :created_at, :updated_at
json.url service_url(service, format: :json)
