public with sharing class ContactSearch {
   
        public static list<Contact> searchForContacts (String s1, String s2) {

            List<Contact> cts = [SELECT Id, Name FROM Contact WHERE LastName =: s1 AND MailingPostalCode =: s2];
            return cts;

        }
}