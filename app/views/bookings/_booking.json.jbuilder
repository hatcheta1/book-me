json.extract! booking, :id, :client_id, :business_id, :service_id, :started_at, :ended_at, :accepted, :created_at, :updated_at
json.url booking_url(booking, format: :json)
