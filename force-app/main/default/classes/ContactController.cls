public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        List<Contact> contacts = 
                [SELECT Id, FirstName,LastName, Phone, Email FROM Contact];
        return contacts;
    }
}