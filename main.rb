require "./response"
require "sinatra"
require "json"

set :bind, '0.0.0.0'

post "/command" do
  alexa_request = JSON.parse(request.body.read)
  response = AlexaResponse.new
  response.build({
    say: "What should the temperature be?",
    card: {
      title: "Temperature set with Nest",
      content: "Wondering what content to put? Nice."
    },
    should_end_session: false
  })
end
