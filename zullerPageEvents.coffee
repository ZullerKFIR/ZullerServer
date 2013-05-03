if Meteor.isClient
  AttractionDBConnection = Meteor.dbAttraction
  StreetsIL = new Meteor.Collection("StreetsIL")
  Session.set "newbar", `undefined`
  Session.set "cloudedimage", `undefined`
  PageEvents = {}
  PageEvents["click #loginButton"] = ->
    options = undefined
    password = undefined
    username = undefined
    username = $("#name").val()
    password = $("#password").val()
    options =
      username: username
      password: password

    Meteor.logout()
    Accounts.createUser options
    Meteor.user()
    Meteor.loginWithPassword username, password, (err) ->
      unless err
        Meteor.Router.to "/admin", true
      else
        alert "Bad name or password!"


  AdminPageEvents = {}
  AdminPageEvents["click #logoutButton"] = ->
    Meteor.logout()
    Meteor.Router.to "/", true

  getBarPageEvents = {}
  getBarPageEvents["click #getBarSelector"] = ->
    barSelector = $("#getBarSelector").val()
    unless barSelector is ""
      attFound = AttractionDBConnection.getInfoOfAttractionName(barSelector)
      $("#name").val attFound.getAttractionName()
      $("#citySelector").val attFound.getCity()
      streetName = attFound.getStreet()
      $("#streetSelector").append "<option>" + streetName + "</option>"
      $("#streetSelector").val streetName
      $("#HouseNum").val attFound.getHouseNum()
      $("#minAge").val attFound.getMinAge()
      $("#phone").val attFound.getPhone()
      $("#logoContainer").html "&nbsp;"
      unless cur["logo"] is `undefined`
        $("<img src=\"" + attFound.getLogo() + "\">").load ->
          $(this).width(150).height(150).appendTo "#logoContainer"

    else
      $("#name").val ""
      $("#address").val ""
      $("#minAge").val ""
      $("#phone").val ""
      $("#logoContainer").html "&nbsp;"

  NewBarPageEvents = {}
  NewBarPageEvents["click #citySelector"] = ->
    city = $("#citySelector").val()
    $("#streetSelector").html ""
    Streets = StreetsIL.find(cityname: city)
    count = 0
    Streets.forEach (streetvar) ->
      streetvar["streets"].forEach (street) ->
        StreetName = street
        $("#streetSelector").append "<option>" + StreetName + "</option>"
        count++



  NewBarPageEvents["click #uploadlogoButton"] = ->
    eee = Session.get("newbar")
    unless Session.get("newbar") is `undefined`
      filepicker.setKey "AS5VjruSwRWaumPwrHEg6z"
      unless Session.get("cloudedimage") is `undefined`
        filepicker.remove Session.get("cloudedimage"), ->
          console.log "Removed"

      filepicker.pickAndStore
        mimetype: "image/*"
      ,
        location: "S3"
      , (fpfiles) ->
        Session.set "cloudedimage", fpfiles[0]
        AttractionDBConnection.update
          _id: Meteor.base64.encode(Session.get("newbar"))
        ,
          $set:
            logo: fpfiles[0]["url"]
        , (error) ->
          alert "Weird error " + error  unless error is `undefined`

        $("#logoContainer").html "&nbsp;"
        $("<img src=\"" + fpfiles[0]["url"] + "\">").load ->
          $(this).width(150).height(150).appendTo "#logoContainer"


    else
      alert "Weird Error: Trying to upload files without a bar"

  Template.getbarPage.Attractions = ->
    BarListSlector = []
    barlist = AttractionDBConnection.getlist()
    
    #var barlist = Attractions.find();
    count = 0
    barlist.forEach (bar) ->
      barName = Meteor.base64.decode(bar.name)
      BarListSlector[count] = name: barName
      count++

    BarListSlector

  NewBarPageEvents["click #anotherbarButton"] = ->
    Session.set "newbar", `undefined`
    Session.set "cloudedimage", `undefined`
    eee4 = Session.get("newbar")
    $("#addbarButton").show()
    $("#logoContainer").html "&nbsp;"
    $("#name").attr "readonly", false
    $("#address").attr "readonly", false
    $("#citySelector").attr "readonly", false
    $("#streetSelector").attr "readonly", false
    $("#HouseNum").attr "readonly", false
    $("#minAge").attr "readonly", false
    $("#phone").attr "readonly", false
    $("#uploadlogoButton").hide()
    $("#name").val ""
    $("#citySelector").val ""
    $("#streetSelector").val ""
    $("#HouseNum").val ""
    $("#address").val ""
    $("#minAge").val ""
    $("#phone").val ""

  NewBarPageEvents["click #addbarButton"] = ->
    name = undefined
    address = undefined
    timeDuration = undefined
    minAge = undefined
    logo = undefined
    phone = undefined
    approved = undefined
    approved = true
    name = $("#name").val()
    address = $("#address").val()
    city = $("#citySelector").val()
    street = $("#streetSelector").val()
    streetNumber = $("#HouseNum").val()
    minAge = $("#minAge").val()
    phone = $("#phone").val()
    Meteor.subscribe "Attractions"
    barName = Meteor.base64.encode(name)
    barName2 = Meteor.base64.decode(barName)
    ExistsAttraction = AttractionDBConnection.getInfoOfAttractionName(name)
    if ExistsAttraction is `undefined`
      address =
        city: Meteor.base64.encode(city)
        street: Meteor.base64.encode(street)
        streetNumber: Meteor.base64.encode(streetNumber)

      GenInfo =
        name: Meteor.base64.encode(name)
        address: address
        minAge: Meteor.base64.encode(minAge)
        phone: Meteor.base64.encode(phone)
        owner: Meteor.userId()

      genValues = EJSON.stringify(GenInfo)
      newbarID = AttractionDBConnection.insert(GenInfo, (err) ->
        unless err is `undefined`
          alert "Insertion failed for the following reason " + err
        else
          alert "Bar Added"
          Session.set "newbar", newbarID
          eee4 = Session.get("newbar")
          $("#addbarButton").hide()
          $("#uploadlogoButton").show()
          $("#name").attr "readonly", "readonly"
          $("#address").attr "readonly", "readonly"
          $("#citySelector").attr "readonly", "readonly"
          $("#streetSelector").attr "readonly", "readonly"
          $("#HouseNum").attr "readonly", "readonly"
          $("#minAge").attr "readonly", "readonly"
          $("#phone").attr "readonly", "readonly"
      )
    else
      alert "Bar cannot be added: Exists"

  Template.getbarPage.events getBarPageEvents
  Template.newbarPage.events NewBarPageEvents
  Template.adminPage.events AdminPageEvents
  Template.userPage.events PageEvents

#Template.newbarPage.cities = function() { return StreetsIL.find(Meteor.base64.encode($("#citySelector").val()))}; 

#Handlebars.registerHelper('arrayify',function(obj){
#result = [];
#for (var key in obj) result.push({name:Meteor.base64.decode(key)});
#return result;
#});
