var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
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
    alert('Found ' + contacts.length + ' contacts.');
};

function onError(contactError) {
    alert('onError!');
};

function doContacts() {
  var options      = new ContactFindOptions();
  options.filter   = "Bob";
  options.multiple = true;
  options.desiredFields = [navigator.contacts.fieldType.id];
  options.hasPhoneNumber = true;
  var fields       = [navigator.contacts.fieldType.displayName, navigator.contacts.fieldType.name];
  navigator.contacts.find(fields, onSuccess, onError, options);
}

function onDeviceReady() {
  console.log(navigator.contacts);
  doContacts();
  deviceInfo.get( function(result) {
    alert("result = " + result);
  }, function() {
    console.log("error");
  });
}

document.addEventListener("deviceready", onDeviceReady, false);

var deviceInfo = cordova.require("cordova/plugin/DeviceInformation");

app.initialize();

