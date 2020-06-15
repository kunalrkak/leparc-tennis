json.extract! reservation, :id, :user_id, :start, :end, :date, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
