// Imports
#require "Twitter.class.nut:1.2.0"

// Instantiate a Twitter object
// NOTE: enter your own Twitter app secrets
local twitter = Twitter(YOUR_API_KEY, YOUR_API_SECRET, YOUR_AUTH_TOKEN, YOUR_TOKEN_SECRET);

// Start searching Twitter stream
twitter.stream("swag", function(tweetData) {
    // Tell the device a Tweet pertaining to "swag" has been received
    device.send("tweet", true);
});

state <- 0

server.log("Turn Catcher On: " + http.agenturl() + "?catcher=1");
server.log("Turn Catcher Off: " + http.agenturl() + "?catcher=0");

function requestHandler(request, response) {
    server.log("called");
    try {
        if ("catcher" in request.query) {
            if (request.query.catcher == "1" || request.query.catcher == "0") {
                server.log("called");
                local new_state = request.query.catcher.tointeger();
                device.send("set.State", new_state);
                state <- new_state;
                if(state == 0) {
                    twitter.tweet("I just entertained my cat with StarCatcher, an @electricimp agent.");
                }
            }
            response.send(200, "OK");
        } else {
            response.send(200, state);
        }

    }
    catch (ex) {
        server.log(ex);
        response.send(500, "Internal server error");
    }

}

http.onrequest(requestHandler);
