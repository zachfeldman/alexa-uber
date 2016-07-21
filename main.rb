require "./response"
require "sinatra"
require "json"
require "geocoder"
require "uber_api"

set :bind, '0.0.0.0'

require './uber_support'

require './alexa_support'

def add_logfile logfile_name, content, request_origin
  log_content = "Request Origin: #{request_origin}\n\n"
  log_content += content
  File.open(logfile_name, 'w'){|c| c << log_content}
end

def timestamper
  Time.now.to_s.gsub(/[^\w\.]/, '_')
end

get '/' do
  "Hello world"
end

post "/" do

  alexa_request = JSON.parse(request.body.read)
  start_alexa_session(alexa_request)
  session = get_alexa_session(alexa_request)

  logfile_location = "logs/log-#{session[:started]}_#{session[:id].gsub(/[^\w\.]/, '_').gsub(".", "_")}"

  `mkdir #{logfile_location}` if !File.directory?(logfile_location)

  add_logfile "#{logfile_location}/#{session[:counter]}_request.txt", JSON.pretty_generate(alexa_request), "Alexa/Amazon"

  if alexa_request["request"]["type"] == "LaunchRequest"
    response_text = "Where would you like to go?"
    end_session = false
  elsif alexa_request["request"]["intent"] && alexa_request["request"]["intent"]["name"] != "GetConfirmationIntent"
    landmark = alexa_request["request"]["intent"]["slots"]["Landmark"]["value"]
    
    house_number = alexa_request["request"]["intent"]["slots"]["HouseNumber"]["value"]
    street_name = alexa_request["request"]["intent"]["slots"]["StreetName"]["value"]
    city = alexa_request["request"]["intent"]["slots"]["City"]["value"]

    if landmark
      location_request = Geocoder.search("#{landmark}, New York, NY")
      if location_request.count != 1
        response_text = "We couldn't find that location. Please try again."
      else
        formatted_address = location_request[0].data['formatted_address']
        session[:new_trip] = location_request
        p session.inspect
        response_text = "Just to confirm, you'd like a cab right now to #{formatted_address}, correct?"
      end

    elsif house_number && street_name && city
      location_request = Geocoder.search("#{house_number} #{street_name}, #{city}, NY")
      if location_request.count != 1
        response_text = "We couldn't find that location. Please try again."
      else
        formatted_address = location_request[0].data['formatted_address']
        session[:new_trip] = location_request
        p session.inspect
        response_text = "Just to confirm, you'd like a cab right now to #{formatted_address}, correct?"
      end

    else
      response_text = "Sorry, I couldn't find that landmark."
    end
    end_session = false
  else
    if alexa_request["request"]["intent"]["slots"]["Confirmation"]["value"] == "yes"
      location_1 = Geocoder.search(DEFAULT_HOME_LOCATION)
      get_uber(assemble_location_data(location_1), assemble_location_data(session[:new_trip]))
      session[:new_trip] = nil
      response_text = "Hailing your cab now. Check the Uber app for arrival information or to cancel your trip."
    else
      response_text = "Ok, I won't get you a cab now then."
    end
    end_session = true
  end


  response_builder = AlexaResponse.new
  response = response_builder.build({
    say: "The aliens have arrived",
    card: {
      title: "Request a cab with Uber",
      content: "Philly RB is awesome"
    },
    should_end_session: end_session
  })

  add_logfile "#{logfile_location}/#{session[:counter]}_response.txt", JSON.pretty_generate(JSON.parse(response)), "Sinatra App"
  session[:counter] += 1

  response
end
