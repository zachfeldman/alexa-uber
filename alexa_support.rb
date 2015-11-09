ALEXA_SESSIONS = []

def start_alexa_session(alexa_request)
  current_session = ALEXA_SESSIONS.select{|session| session[:id] == alexa_request["session"]["sessionId"]}.first
  if !current_session
    new_session = {id: alexa_request["session"]["sessionId"]}
    ALEXA_SESSIONS.push(new_session)
  end
end

def get_alexa_session(alexa_request)
  ALEXA_SESSIONS.select{|session| session[:id] == alexa_request["session"]["sessionId"]}.first
end