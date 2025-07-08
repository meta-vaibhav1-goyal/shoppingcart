public with sharing class ContactAndLeadSearch {
    

    public static List<List< sObject>> searchContactsAndLeads(String searchParam) {
        List<List<sObject>> results = [FIND :searchParam IN ALL FIELDS 
            RETURNING Lead(Name),Contact(FirstName,LastName,Department)];
            
        return results;

    }
}