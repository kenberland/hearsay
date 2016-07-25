var app = {
  initialize: function() {
    this.bindEvents();
  },
  bindEvents: function() {
    document.addEventListener('deviceready', this.onDeviceReady, false);
  },
  onDeviceReady: function() {
    app.receivedEvent('deviceready');
  },
  receivedEvent: function(id) {
    var parentElement = document.getElementById(id);
    var listeningElement = parentElement.querySelector('.listening');
    var receivedElement = parentElement.querySelector('.received');
    listeningElement.setAttribute('style', 'display:none;');
    receivedElement.setAttribute('style', 'display:block;');
    console.log('Received Event: ' + id);
  }
};

var HearsayContacts = {
  // PROPS
  contact_ids: null,
  current_contact: 0,
  current_contact_detail: {},
  // METHODS
  onSuccess: function(contacts) {
    console.log("contacts:" + JSON.stringify(contacts, null, 2));
    HearsayContacts.contact_ids = contacts;
    HearsayContacts.getOne(HearsayContacts.contact_ids[HearsayContacts.current_contact]["id"]);
  },
  onError: function(contactError) {
    alert('onError!');
  },
  onGetOneSuccess: function(contact) {
    console.log("single contact:" + JSON.stringify(contact, null, 2));
    HearsayContacts.current_contact_detail = contact[0];
    HearsayContacts.paintCurrent();
  },
  onGetOneError: function(contactError){
    alert('onError!');
  },
  perform: function() {
    var options      = new ContactFindOptions();
    options.multiple = true;
    options.desiredFields = [navigator.contacts.fieldType.id ];
    var fields = [navigator.contacts.fieldType.id];
    navigator.contacts.find(fields, this.onSuccess, this.onError, options);
  },
  getOne: function(id) {
    console.log("get one for id: " + id);
    var options = new ContactFindOptions();
    options.filter = id;
    var fields = [navigator.contacts.fieldType.id];
    navigator.contacts.find(fields, this.onGetOneSuccess, this.onGetOneError, options);
  },
  paintCurrent: function() {
    this.paint(this.current_contact_detail);
  },
  paint: function(contact) {
    $('#contact_name').html(contact.displayName);
    $('#contact_image').attr("src",contact.photos[0].value);
  },
  next: function(){
    this.current_contact++;
    this.current_contact = (this.current_contact > (this.contact_ids.length - 1)) ? 0 : this.current_contact;
    this.getOne(this.contact_ids[HearsayContacts.current_contact]["id"]);
  },
  previous: function(){
    this.current_contact--;
    this.current_contact = (this.current_contact < 0) ? (this.contact_ids.length - 1): this.current_contact;
    this.getOne(this.contact_ids[HearsayContacts.current_contact]["id"]);
  }
};

function onDeviceReady() {
  console.log("device uuid: " + device.uuid);
  HearsayContacts.perform();
}


document.addEventListener("deviceready", onDeviceReady, false);
app.initialize();

var event = new Event('deviceready');
document.dispatchEvent(event);

$("#next").click( function() {
  HearsayContacts.next();
}
		);
$("#previous").click( function() {
  HearsayContacts.previous();
}
		);