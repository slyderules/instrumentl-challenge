json.extract! receiver, :id, :ein, :name, :address, :city, :state, :zip, :filename, :uploaded_at, :created_at, :updated_at
json.url receiver_url(receiver, format: :json)
