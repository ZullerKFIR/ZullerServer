if Meteor.isClient
  ClientRoutes = {}
  ClientRoutes["/"] = "userPage"
  ClientRoutes["/redirect"] = "redirect"
  ClientRoutes["/admin"] = "adminPage"
  ClientRoutes["/newbar"] = "newbarPage"
  ClientRoutes["/getbar"] = "getbarPage"
  ClientRoutes["/getinfofromb/:id"] = (id) ->
    hi = new String(@querystring)
    hi = hi.toString()
    queryLoc = hi.indexOf("=")
    request = hi.substring(0, queryLoc)
    result = hi.substring(queryLoc + 1)
    if request is "getallattra"
      Attractions.find().forEach (player) ->
        console.log player

    else
      console.log "Command not found."

  Meteor.Router.add ClientRoutes
  Meteor.Router.filters requireLogin: (page) ->
    if Meteor.loggingIn()
      "userPage"
    else if Meteor.user()
      page
    else
      "userPage"

  Meteor.Router.filter "requireLogin"