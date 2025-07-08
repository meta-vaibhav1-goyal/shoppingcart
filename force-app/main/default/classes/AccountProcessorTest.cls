@isTest
public with sharing class AccountProcessorTest {

    @IsTest
    private static void countContactsTest () {
        List<Account> accList = new List<Account>();

        for(Integer i=0; i <= 250; i++) {
            accList.add(new Account(Name='Test Account ' + i));
        }

        

        insert accList;
        List<Contact> conList = new List<Contact>();

        List<Id> accIds = new List<Id>();
        

        for(Account acc: accList) {
            Contact con = new Contact(FirstName='Test Contact ', LastName= acc.Name);
            con.AccountId = acc.Id;
            conList.add(con);
            accIds.add(acc.Id);
        }

        insert conList;

        Test.startTest();
        AccountProcessor.countContacts(accIds);
        Test.stopTest();

        List<Account> accs = [SELECT Id,Number_Of_Contacts__c FROM Account WHERE Id IN :accIds];
        for(Account acc: accs) {
        System.assertEquals(1, accs[0].Number_Of_Contacts__c, 'Contacts are not counted successfully');
        }

      
        
  
    }
}