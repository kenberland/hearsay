cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/contacts.js",
        "id": "mp-cordova-plugin-contacts.contacts",
        "clobbers": [
            "navigator.contacts"
        ]
    },
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/Contact.js",
        "id": "mp-cordova-plugin-contacts.Contact",
        "clobbers": [
            "Contact"
        ]
    },
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/ContactAddress.js",
        "id": "mp-cordova-plugin-contacts.ContactAddress",
        "clobbers": [
            "ContactAddress"
        ]
    },
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/ContactError.js",
        "id": "mp-cordova-plugin-contacts.ContactError",
        "clobbers": [
            "ContactError"
        ]
    },
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/ContactField.js",
        "id": "mp-cordova-plugin-contacts.ContactField",
        "clobbers": [
            "ContactField"
        ]
    },
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/ContactFindOptions.js",
        "id": "mp-cordova-plugin-contacts.ContactFindOptions",
        "clobbers": [
            "ContactFindOptions"
        ]
    },
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/ContactName.js",
        "id": "mp-cordova-plugin-contacts.ContactName",
        "clobbers": [
            "ContactName"
        ]
    },
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/ContactOrganization.js",
        "id": "mp-cordova-plugin-contacts.ContactOrganization",
        "clobbers": [
            "ContactOrganization"
        ]
    },
    {
        "file": "plugins/mp-cordova-plugin-contacts/www/ContactFieldType.js",
        "id": "mp-cordova-plugin-contacts.ContactFieldType",
        "merges": [
            ""
        ]
    },
    {
        "file": "plugins/cordova-plugin-device/www/device.js",
        "id": "cordova-plugin-device.device",
        "clobbers": [
            "device"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.2.2",
    "mp-cordova-plugin-contacts": "1.1.1-dev",
    "cordova-plugin-device": "1.1.2"
};
// BOTTOM OF METADATA
});