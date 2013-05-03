(->
  dbAttraction = undefined
  dbConnection = undefined
  dbConnection = new Meteor.Collection("Attractions")
  dbAttraction = ->

  dbAttraction::getInfoOfAttractionName = (barName) ->
    city = undefined
    cur = undefined
    foundAttraction = undefined
    houseNum = undefined
    street = undefined
    cur = dbConnection.findOne(name: Meteor.base64.encode(barName))
    if cur isnt `undefined`
      foundAttraction = new Meteor.Attraction(barName)
      city = Meteor.base64.decode(cur["address"]["city"])
      street = Meteor.base64.decode(cur["address"]["street"])
      houseNum = Meteor.base64.decode(cur["address"]["streetNumber"])
      foundAttraction.setAddress city, street, houseNum
      foundAttraction.setPhone Meteor.base64.decode(cur["phone"])
      foundAttraction.setMinAge Meteor.base64.decode(cur["minAge"])
      if cur["logo"] isnt `undefined`
          foundAttraction.setLogo Meteor.base64.decode(cur["logo"])
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
