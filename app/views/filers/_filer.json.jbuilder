json.extract! filer, :id, :ein, :name, :address, :city, :state, :zip, :filename, :uploaded_at, :created_at, :updated_at
json.url filer_url(filer, format: :json)
