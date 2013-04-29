(->
  Attraction = (name) ->
    @name = name
    @address = {}
    @weight = `undefined`
    @minAge = `undefined`
    @phone = `undefined`
    @logo = `undefined`
    throw "Cannot create Attraction object - Bad Name"  if name is `undefined`
  Attraction::getAttractionName = ->
    @name

  Attraction::setAddress = (city, street, houseNum) ->
    @address =
      city: city
      street: street
      houseNum: houseNum

    true

  Attraction::getCity = ->
    @address["city"]

  Attraction::getStreet = ->
    @address["street"]

  Attraction::getHouseNum = ->
    @address["houseNum"]

  Attraction::setWeight = (weigh) ->
    @weight = weigh
    true

  Attraction::getWeight = ->
    @weight

  Attraction::setMinAge = (mAge) ->
    @minAge = mAge
    true

  Attraction::getMinAge = ->
    @minAge

  Attraction::getPhone = ->
    @phone

  Attraction::setPhone = (pho) ->
    @phone = pho
    true

  Attraction::setLogo = (log) ->
    @logo = log
    true

  Attraction::getLogo = ->
    @logo

  Meteor.Attraction = Attraction
  Meteor.startup ->

)()
