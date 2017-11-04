json.extract! note, :id, :user_id, :datum, :uhrzeit, :message, :created_at, :updated_at
json.url note_url(note, format: :json)