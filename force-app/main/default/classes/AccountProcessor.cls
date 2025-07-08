public with sharing class AccountProcessor {
    @future 
    public static void countContacts  (List<Id> accIds) {
        List<Account> accList = new List<Account>();

        List<Account> accs = [SELECT Id,Number_Of_Contacts__c, Name, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accIds];

        for(Account acc : accs) {
             acc.Number_Of_Contacts__c = acc.Contacts.size();
        }

        if(!accs.isEmpty()) {
            update accs;
        }



    }

}