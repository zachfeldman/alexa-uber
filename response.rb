class AlexaResponse

  # @@ Sample:
  # request = AlexaResponse.new
  # request.build({
  #     say: "What should the temperature be?",
  #     card: {
  #       title: "Temperature set with Nest",
  #       subtitle: "Here is a nice subtitle",
  #       content: "Wondering what content to put? Nice."
  #     },
  #     should_end_session: false
  #   }

  def build(options = {})
    {
      version: "1.0.0",
      response: {
        outputSpeech: {
          type: "PlainText",
          text: options[:say]
        },
        card: {
          type: "Simple",
          title: options[:card][:title],
          content: options[:card][:content]
        },
        shouldEndSession: options[:should_end_session]
      }
    }.to_json
  end

end