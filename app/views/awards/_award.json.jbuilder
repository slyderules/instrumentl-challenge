json.extract! award, :id, :ein, :name, :address, :city, :state, :zip, :amount, :amount_gbp, :purpose, :filer_ein, :filename, :uploaded_at, :created_at, :updated_at
json.url award_url(award, format: :json)
