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

function onSuccess(contacts) {
  console.log("fuck" + contacts);
  var jsonContacts = JSON.stringify(contacts, null, 2);
  var x = document.getElementsByClassName("contacts");
  x[0].innerHTML = jsonContacts;
};

function onError(contactError) {
    alert('onError!');
};

function doContacts() {
  var options      = new ContactFindOptions();
  // options.filter  = "";
  options.multiple = true;
  options.desiredFields = [navigator.contacts.fieldType.id ];
  //, navigator.contacts.fieldType.displayName];
  var fields = [navigator.contacts.fieldType.id];
  // var fields = [];
  //, navigator.contacts.fieldType.displayName, navigator.contacts.fieldType.name, navigator.contacts.fieldType.phoneNumbers, navigator.contacts.fieldType.photos];
  navigator.contacts.find(fields, onSuccess, onError, options);
}

function onDeviceReady() {
  console.log("device uuid: " + device.uuid);
  doContacts();
}

document.addEventListener("deviceready", onDeviceReady, false);
app.initialize();

var event = new Event('deviceready');
document.dispatchEvent(event);
