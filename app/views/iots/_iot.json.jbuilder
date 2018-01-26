json.extract! iot, :id, :owner_id, :owner_type, :name, :value, :created_at, :updated_at
json.url iot_url(iot, format: :json)