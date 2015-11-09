DEFAULT_HOME_LOCATION = ENV["DEFAULT_HOME_LOCATION"]
REAL_RIDE = ENV['UBER_REAL_RIDE']

def get_uber(location_1, location_2)
  # You'll need an UBER_SERVER_TOKEN and an UBER_BEARER_TOKEN
  client = Uber::Client.new(
    :server_token => ENV['UBER_SERVER_TOKEN'],
    :bearer_token => ENV['UBER_BEARER_TOKEN'],
    :sandbox => !REAL_RIDE
  )

  # Default to UberX
  product_choices = client.products(location_1[:lat].to_f, location_1[:lon].to_f)
  product_id = product_choices[2]["product_id"]

  # Create the ride request
  ride = client.request({
    :product_id => product_id,
    :start_latitude => location_1[:lat],
    :start_longitude => location_1[:lon],
    :end_latitude => location_2[:lat],
    :end_longitude => location_2[:lon]
  })
end

def assemble_location_data(location_request)
  location_lat = location_request[0].data["geometry"]["location"]["lat"]
  location_lon = location_request[0].data["geometry"]["location"]["lng"]
  {lat: location_lat, lon: location_lon}
end