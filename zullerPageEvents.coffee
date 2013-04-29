if Meteor.isClient
  
  #	meteor_bootstrap.re
  base64 = {}
  base64.PADCHAR = "="
  base64.ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  base64.getbyte64 = (s, i) ->
    
    # This is oddly fast, except on Chrome/V8.
    #  Minimal or no improvement in performance by using a
    #   object with properties mapping chars to value (eg. 'A': 0)
    idx = base64.ALPHA.indexOf(s.charAt(i))
    throw "Cannot decode base64"  if idx is -1
    idx

  base64.decode = (s) ->
    
    # convert to string
    s = "" + s
    getbyte64 = base64.getbyte64
    pads = undefined
    i = undefined
    b10 = undefined
    imax = s.length
    return s  if imax is 0
    throw "Cannot decode base64"  unless imax % 4 is 0
    pads = 0
    if s.charAt(imax - 1) is base64.PADCHAR
      pads = 1
      pads = 2  if s.charAt(imax - 2) is base64.PADCHAR
      
      # either way, we want to ignore this last block
      imax -= 4
    x = []
    i = 0
    while i < imax
      b10 = (getbyte64(s, i) << 18) | (getbyte64(s, i + 1) << 12) | (getbyte64(s, i + 2) << 6) | getbyte64(s, i + 3)
      x.push String.fromCharCode(b10 >> 16, (b10 >> 8) & 0xff, b10 & 0xff)
      i += 4
    switch pads
      when 1
        b10 = (getbyte64(s, i) << 18) | (getbyte64(s, i + 1) << 12) | (getbyte64(s, i + 2) << 6)
        x.push String.fromCharCode(b10 >> 16, (b10 >> 8) & 0xff)
      when 2
        b10 = (getbyte64(s, i) << 18) | (getbyte64(s, i + 1) << 12)
        x.push String.fromCharCode(b10 >> 16)
    decodeURIComponent escape(x.join(""))

  base64.getbyte = (s, i) ->
    x = s.charCodeAt(i)
    throw "INVALID_CHARACTER_ERR: DOM Exception 5"  if x > 255
    x

  base64.encode = (s) ->
    throw "SyntaxError: Not enough arguments"  unless arguments_.length is 1
    s = unescape(encodeURIComponent(s))
    padchar = base64.PADCHAR
    alpha = base64.ALPHA
    getbyte = base64.getbyte
    i = undefined
    b10 = undefined
    x = []
    
    # convert to string
    s = "" + s
    imax = s.length - s.length % 3
    return s  if s.length is 0
    i = 0
    while i < imax
      b10 = (getbyte(s, i) << 16) | (getbyte(s, i + 1) << 8) | getbyte(s, i + 2)
      x.push alpha.charAt(b10 >> 18)
      x.push alpha.charAt((b10 >> 12) & 0x3F)
      x.push alpha.charAt((b10 >> 6) & 0x3f)
      x.push alpha.charAt(b10 & 0x3f)
      i += 3
    switch s.length - imax
      when 1
        b10 = getbyte(s, i) << 16
        x.push alpha.charAt(b10 >> 18) + alpha.charAt((b10 >> 12) & 0x3F) + padchar + padchar
      when 2
        b10 = (getbyte(s, i) << 16) | (getbyte(s, i + 1) << 8)
        x.push alpha.charAt(b10 >> 18) + alpha.charAt((b10 >> 12) & 0x3F) + alpha.charAt((b10 >> 6) & 0x3f) + padchar
    x.join ""

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
          _id: base64.encode(Session.get("newbar"))
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
      barName = base64.decode(bar.name)
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
    barName = base64.encode(name)
    barName2 = base64.decode(barName)
    ExistsAttraction = AttractionDBConnection.getInfoOfAttractionName(name)
    if ExistsAttraction is `undefined`
      address =
        city: base64.encode(city)
        street: base64.encode(street)
        streetNumber: base64.encode(streetNumber)

      GenInfo =
        name: base64.encode(name)
        address: address
        minAge: base64.encode(minAge)
        phone: base64.encode(phone)
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

#Template.newbarPage.cities = function() { return StreetsIL.find(base64.encode($("#citySelector").val()))}; 

#Handlebars.registerHelper('arrayify',function(obj){
#result = [];
#for (var key in obj) result.push({name:base64.decode(key)});
#return result;
#});