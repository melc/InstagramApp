json.array!(@photostream) do |photostream|
  json.extract! photostream, :id, :client_id, :secret_code, :access_token
  json.url photostream_url(photostream, format: :json)
end
