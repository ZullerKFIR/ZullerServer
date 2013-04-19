Attractions = new Meteor.Collection("Attractions");


if (Meteor.isClient) {
	 Session.set("newbar",undefined);
		Session.set("cloudedimage",undefined);
  ClientRoutes = {};
  ClientRoutes['/'] = 'userPage';
  ClientRoutes['/redirect'] = 'redirect';
	
  ClientRoutes['/admin'] = 'adminPage';
  ClientRoutes['/newbar'] = 'newbarPage';
  ClientRoutes['/getbar'] = 'getbarPage';
  ClientRoutes['/getinfofromb/:id'] = function(id) {
	   var hi = new String(this.querystring);
	   hi = hi.toString();
	   var queryLoc = hi.indexOf("=");
           var request = hi.substring(0,queryLoc);
	   var result = hi.substring(queryLoc + 1);
	   if (request == "getallattra")
	   {
		Attractions.find().forEach(function(player)
		{
			console.log(player);
		});

	   }
	   else
           {
		console.log("Command not found.");
	   }
	};
  Meteor.Router.add(ClientRoutes);
  Meteor.Router.filters({
   requireLogin: function(page) {
     if (Meteor.loggingIn()) {
         return 'loadingLayout';
     }
     else if (Meteor.user()) {
         return page;
     }
     else
     {
        return 'userPage';
     }
   }
  });
  Meteor.Router.filter('requireLogin');

  PageEvents = {};
  PageEvents["click #loginButton"] = function() {
      var options, password, username;
      username = $("#name").val();
      password = $("#password").val();
      options = {
        username: username,
        password: password
      }
      Meteor.logout();
      Accounts.createUser(options);
      Meteor.user();
      Meteor.loginWithPassword(username, password, function(err) {
	
            if (!err)
	    {
		    Meteor.Router.to('/admin',true);
	   }
           else
           {
		alert("Bad name or password!");
	   }
          
      });}
      AdminPageEvents = {};
      AdminPageEvents["click #logoutButton"] = function(){
	Meteor.logout();
	 Meteor.Router.to('/',true);
	}
      NewBarPageEvents = {};
      NewBarPageEvents["click #uploadlogoButton"] = function(){
      				  var eee = Session.get("newbar");
      						if (Session.get("newbar") != undefined)
      						{
      													filepicker.setKey('AS5VjruSwRWaumPwrHEg6z');
      													if (Session.get("cloudedimage") != undefined)
      													{
      																	filepicker.remove(Session.get("cloudedimage"), function(){
        																			console.log("Removed");
    																			});
      														
      														}
      													filepicker.pickAndStore({mimetype:"image/*"},
        														{location:"S3"}, function(fpfiles){
   																		 Session.set("cloudedimage",fpfiles[0]);
   																		 Attractions.update({_id: Session.get("newbar")},
                   								{$set: {logo: fpfiles[0]["url"]}}
                   						,function(error){if (error != undefined){alert("Weird error " + error);}});
   																			$('#logoContainer').html("&nbsp;");
																				    $('<img src="'+ fpfiles[0]["url"] +'">').load(function() {
  																										$(this).width(150).height(150).appendTo('#logoContainer');
																								});

   																		
  																				
        
   																});																
      							
      							
      							}
      							else
      							{
      									alert("Weird Error: Trying to upload files without a bar");
														      								
      								}
      	
      	
      	
      	
      	
      	
      	};
      NewBarPageEvents["click #anotherbarButton"] = function(){
														Session.set("newbar",undefined);
														Session.set("cloudedimage",undefined);
														$("#addbarButton").show();
														$('#logoContainer').html("&nbsp;");
									 	    $("#name").attr("readonly",false);
										    $("#address").attr("readonly",false);
												  	$("#timeDuration").attr("readonly",false);
												  $("#minAge").attr("readonly",false);
												  $("#password").attr("readonly",false);
												  $("#phone").attr("readonly",false);
									 					$("#uploadlogoButton").hide();
														$("#name").val("");
										    $("#address").val("");
												  	$("#timeDuration").val("");
												  $("#minAge").val("");
												  $("#password").val("");
												  $("#phone").val("");
};
      NewBarPageEvents["click #addbarButton"] = function(){
                  var name,address,timeDuration,minAge,logo,phone,approved;
 		  													approved = true;
														 	 	name = $("#name").val();
												    address = $("#address").val();
														  	timeDuration = $("#timeDuration").val();
														  minAge = $("#minAge").val();
														  phone = $("#password").val();
														  	
																Meteor.subscribe("Attractions");
																var Cursors = Attractions.find({name: name});
																var CurrParsed = Cursors.fetch();
																if (CurrParsed.length == 0){
																var GenInfo = {name : name, address : address, timeDuration : timeDuration, minAge : minAge, phone : phone,owner:Meteor.userId()};
																var genValues = EJSON.stringify(GenInfo);
																var newbarID = Attractions.insert(GenInfo,function(err){if (err != undefined) {
																			 alert("Insertion failed for the following reason " + err);
																																							 
																			 
																			 }
																			 else
																			 {
																			 				alert("Bar Added");
																			 				Session.set("newbar",newbarID);
																			 	    $("#addbarButton").hide();
																			 	    $("#uploadlogoButton").show();
																			 	    $("#name").attr("readonly","readonly");
																				    $("#address").attr("readonly","readonly");
																						  	$("#timeDuration").attr("readonly","readonly");
																						  $("#minAge").attr("readonly","readonly");
																						  $("#password").attr("readonly","readonly");
																			 					$("#phone").attr("readonly","readonly");
																			 
																			 
																			 }
																	
																	 
																	
																																			
																		
																		});	}	else{alert("Bar cannot be added: Exists");}												
																	
																
	}
	
      Template.newbarPage.events(NewBarPageEvents);
      Template.adminPage.events(AdminPageEvents);
      Template.userPage.events(PageEvents);
}


if (Meteor.isServer)
{
	Meteor.startup(function() {
   Attractions.allow({
  insert: function (userId, doc) {
    
    return true;
  },
  update: function (userId, doc, fields, modifier) {
    // can only change your own documents
    return doc.owner === userId;
  },
  remove: function (userId, doc) {
    // can only remove your own documents
    return doc.owner === userId;
  },
  fetch: ['owner']
});
});
}

