
@isTest

public  class AccountContactIdsTest {

    @isTest
    static void testPositiveScenario() {
        Account acc = new Account(Name = 'Test Account ');
        insert acc;
        
        Contact con = new Contact(FirstName = 'Test ', LastName = 'Contact', AccountId = acc.Id);
        insert con;

        Test.startTest();
        System.enqueueJob(new AccountContactIds(con.Id));
        Test.stopTest();


        Account updatedAcc = [SELECT ContactIDs__c FROM Account WHERE Id = :acc.Id];
        System.assertNotEquals(null, updatedAcc.ContactIDs__c, 'ContactIDs__c should be populated');
        System.assert(updatedAcc.ContactIds__c.contains(con.Id), 'Contact Id should be in ContactIDs__c');

    
    }

    @isTest 
    static void testContactWithNoAccount() {
        Contact con = new Contact(FirstName = 'No Account', LastName = 'Contact');
        insert con;

        Test.startTest();
        System.enqueueJob(New AccountContactIds(con.Id));
        Test.stopTest();

        System.assert(true, 'Job completed without errors even though contact had no account');
    
    }


    @isTest 
    static void testInvalidContactId() {
        
        Test.startTest();
        
        try {
            System.enqueueJob(New AccountContactIds('001gK000008WNGMQA9'));
            System.assert(false, 'Excepted exception for invalid contact Id');
        } catch(Exception e) {
            System.assert(e.getMessage().contains('Contact'));
        }
        Test.stopTest();
    }
   
}