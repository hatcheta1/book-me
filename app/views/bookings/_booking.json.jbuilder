json.extract! booking, :id, :client_id, :business_id, :service_id, :start_time, :end_time, :date, :time_zone, :accepted, :created_at, :updated_at
json.url booking_url(booking, format: :json)
