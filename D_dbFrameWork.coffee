(->
  dbConnection = undefined
  dbAttraction = ->
    dbConnection = new Meteor.Collection("Attractions")

  dbAttraction::getInfoOfAttractionName = (barName) ->
    cur = dbConnection.findOne(name: base64.encode(barName))
    unless cur is `undefined`
      foundAttraction = new Meteor.Attraction(barName)
      city = base64.decode(cur["address"]["city"])
      street = base64.decode(cur["address"]["street"])
      houseNum = base64.decode(cur["address"]["streetNumber"])
      foundAttraction.setAddress city, street, houseNum
      foundAttraction.setPhone base64.decode(cur["phone"])
      foundAttraction.setMinAge base64.decode(cur["minAge"])
      foundAttraction.setLogo base64.decode(cur["logo"])
      foundAttraction
    else
      `undefined`

  dbAttraction::getlist = ->
    dbConnection.find()

  dbAttraction::update = (query, whattodo, errorFunc) ->
    dbConnection.update query, whattodo, errorFunc

  dbAttraction::insert = (what, errorFunc) ->
    dbConnection.insert what, errorFunc

  dbAttraction::allow = (what) ->
    dbConnection.allow what

  Meteor.dbAttraction = new dbAttraction()
  Meteor.startup ->

)()