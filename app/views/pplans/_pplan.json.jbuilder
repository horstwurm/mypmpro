json.extract! pplan, :id, :mobject_id, :version, :version_name, :date_from, :date_to, :tasktype, :position, :poc, :created_at, :updated_at
json.url pplan_url(pplan, format: :json)
