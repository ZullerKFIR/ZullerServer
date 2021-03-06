
if (Meteor.isServer)
{
	Meteor.startup(function() {
		 collectionApi = new CollectionAPI({ authToken: '920a7d9e24ca5e0408a269668d7fe0a0' });
    collectionApi.addCollection(Attractions, 'Attractions');
    collectionApi.start();
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
