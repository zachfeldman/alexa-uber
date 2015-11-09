autoscale: true
footer: @zachfeldman | http://zfeldman.com
slidenumbers: true

#[fit] Writing Ruby Apps for the Amazon Echo

![fit inline](ruby-echo.png)

---

#[fit] The Amazon Echo

## It has 7 microphones

---

# Built-in functionality

"Alexa, set an alarm for 45 seconds from now."

"Alexa, tell me a joke."

"Alexa, play Good Morning by Kanye West."

"Alexa, what's the forecast for tomorrow?"

---

# Initial third-party app development efforts

#[alexaho.me](http://alexaho.me)

---

# alexaho.me project approach

- Included scaper (uses JS injection) and server to process commands

- Took advantage of, "stop" keyword to bypass system commands

- Text parsing done "manually", different than Amazon "intent" system

- Ultimately unreliable, although popular

---

# Some integrations built with alexaho.me

- Twitter

- Hue (personal wifi lights)

- Nest (thermostat)

---

# Official SDK status

- Now available for any dev with an Echo to sign up for

- Most code samples are in Java, documentation is very high-level

---

# Official SDK app architecture

- Apps are written as web services that Alexa sends requests to

- JSON responses prompt the Echo to talk back to user and display "cards"

- Apps are basically a "conversation" that can only last so long

---

# Official SDK app architecture

- Amazon side

  - Intent schema (+ custom slots)

  - Sample utterances

- App side

  - Utterance parsing

  - Results being returned as JSON

---

#[fit] Demo - Uber integration

---

#[fit] Let's see some code

---

# Unique issues w/ using Sinatra

- New sessions are initiated each time the Alexa service sends a request

- Can't be setup on a simple AWS Lambda

---

# Notes on setup

- I'm using an AWS Lambda as a proxy for my Alexa requests

- Normally, all Alexa apps have to be on a server with a valid SSL cert

- Instead, you can use a lambda and redirect requests locally


---

#[fit] Where do we go from here?

- Working on a DSL to designate Alexa apps with Ruby

- Would work in a similar way to Sinatra dividing requests into LaunchRequest, IntentRequest, EndSessionRequest

- Wishing Amazon provided a way to send delayed responses...

---

#[fit] Thanks!

#[fit] Questions?
