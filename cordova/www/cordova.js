var device = {
  uuid: "0123456789abcdef"
};

function ContactFindOptions() {
}

navigator.contacts = {
  stuff: [
    {id:1, displayName: "Kenneth Berland", "photos": [ { "id": "6", "pref": false, "type": "url", "value": "http://www.9kracing.com/wp-content/uploads/2012/01/hot-yoga-pants-8.jpg" } ]},
    {id:2, displayName: "Heather Waterman", "photos": [ { "id": "6", "pref": false, "type": "url", "value": "http://cdn.rsvlts.com/wp-content/uploads/2013/07/Girls-in-Yoga-Pants-06.jpg" } ]},
    {id:3, displayName: "Leslie Meyers", "photos": [ { "id": "6", "pref": false, "type": "url", "value": "http://4.bp.blogspot.com/-Kt5kFWHjYuk/U9tYYyNXPKI/AAAAAAAA9d4/zu2-oD5IzAY/s1600/cute_girls_in_yoga_pants_make_the_perfect_utopia_46_photos40_1406883639-739127.jpg" } ]},
    {id:4, displayName: "Ivan DeWolf", "photos": [ { "id": "6", "pref": false, "type": "url", "value": "http://broscience.co/wp-content/uploads/2014/05/yoga-pants13.jpg" } ]}
  ],
  find: function(fields, onSuccess, onError, options) {
    var retval;
    if (options.multiple) {
      retval = [{id:1},{id:2},{id:3},{id:4}];
    } else {
      retval = [this.stuff[options.filter-1]]
    }
    onSuccess.bind(retval);
    onSuccess(retval);
  },
  fieldType: function(){
  }
};
/*
[
   {
     "id": "1",
     "rawId": "1",
     "displayName": "Bob Charles",
     "name": {
       "familyName": "Charles",
       "givenName": "Bob",
       "formatted": "Bob Charles"
     },
     "nickname": null,
     "phoneNumbers": [
       {
         "id": "1",
         "pref": false,
         "value": "(310) 555-1212",
         "type": "mobile"
       }
     ],
     "emails": null,
     "addresses": null,
     "ims": null,
     "organizations": null,
     "birthday": null,
     "note": null,
     "photos": [
       {
         "id": "6",
         "pref": false,
         "type": "url",
         "value": "content://com.android.contacts/contacts/1/photo"
       }
     ],
     "categories": null,
     "urls": null
   }
]
*/
