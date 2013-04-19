Attractions = new Meteor.Collection("Attractions");





if (Meteor.isClient) {
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
      //Accounts.createUser(options);
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
      NewBarPageEvents["click #addbarButton"] = function(){
                  var name,address,timeDuration,minAge,logo,phone,approved;
 		  													approved = true;
														 	 	name = $("#name").val();
												    address = $("#address").val();
														  	timeDuration = $("#timeDuration").val();
														  minAge = $("#minAge").val();
														  //logo = $("#logo").val();
														  phone = $("#password").val();
														  	
																Meteor.subscribe("Attractions");
																var Cursors = Attractions.find({name: name});
																var CurrParsed = Cursors.fetch();
																if (CurrParsed.length == 0){
																var GenInfo = {name : name, address : address, timeDuration : timeDuration, minAge : minAge, phone : phone};
																var genValues = EJSON.stringify(GenInfo);
																Attractions.insert(GenInfo,function(err){if (err != undefined) {
																			 alert("Insertion failed for the following reason " + err);
																																							 
																			 
																			 }
																			 else
																			 {alert("Bar Added");}
																	
																	 
																	
																																			
																		
																		});	}	else{alert("Bar cannot be added: Exists");}												
																	
																
	}
	
      Template.newbarPage.events(NewBarPageEvents);
      Template.adminPage.events(AdminPageEvents);
      Template.userPage.events(PageEvents);
}


if (Meteor.isServer)
{
	Meteor.startup(function() {
       	 

	});
}

