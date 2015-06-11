json.array!(@urls) do |url|
  json.url shortened_url(url, format: :json)
  json.details url_url(url, format: :json)
end
