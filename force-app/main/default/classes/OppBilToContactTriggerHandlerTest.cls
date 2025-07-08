@isTest
public class OppBilToContactTriggerHandlerTest {
    
    @isTest
    static void testUpdateOppManager_Positive() {
        // Create Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create Contact linked to the Account
        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id);
        insert con;

         Test.startTest();
        // Create Opportunity with BillToContact__c set and Manager__c as null
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            BillToContact__c = con.Id,
            Manager__c = null
        );
        

       
        insert opp;
        
        Test.stopTest();
        

        // Assert: Manager__c should now be updated to Contact's AccountId
        Opportunity updatedOpp = [SELECT Id, Manager__c FROM Opportunity WHERE Id = :opp.Id];
        
        System.assertEquals(acc.Id, updatedOpp.Manager__c, 'Manager__c should be updated to Contact\'s Account Id');
    }

    
    @isTest
    static void testUpdateOppManager_Negative_NoBillToContact() {
        // Create Opportunity with no BillToContact__c
        // 
        Test.startTest();
        
        Opportunity opp = new Opportunity(
            Name = 'No Contact Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Manager__c = null
        );
        insert opp;

        Test.stopTest();

        // Assert: Manager__c should still be null
        Opportunity updatedOpp = [SELECT Id, Manager__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(null, updatedOpp.Manager__c, 'Manager__c should remain null if BillToContact__c is not set');
    }

    
    @isTest
    static void testUpdateOppManager_Negative_ContactNoAccount() {
        // Create Contact without an Account
        Contact con = new Contact(FirstName = 'Orphan', LastName = 'Contact');
        insert con;

        // Create Opportunity with this Contact and Manager__c null
      
        Test.startTest();
        
        Opportunity opp = new Opportunity(
            Name = 'Orphan Contact Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            BillToContact__c = con.Id,
            Manager__c = null
        );
        insert opp;

        Test.stopTest();

        // Assert: Manager__c should still be null since Contact has no Account
        Opportunity updatedOpp = [SELECT Id, Manager__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(null, updatedOpp.Manager__c, 'Manager__c should remain null if Contact has no Account');
    }

    
    @isTest
    static void testUpdateOppManager_Negative_AlreadyHasManager() {
        // Create Account
        Account acc = new Account(Name = 'Existing Account');
        insert acc;

        // Create Contact linked to this Account
        Contact con = new Contact(FirstName = 'Existing', LastName = 'Contact', AccountId = acc.Id);
        insert con;

        // Create Opportunity that already has Manager__c set

        Test.startTest();
        
        Opportunity opp = new Opportunity(
            Name = 'Already Managed Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            BillToContact__c = con.Id,
            Manager__c = acc.Id
        );
        
        insert opp;
		
        Test.stopTest();
        

        // Assert: Manager__c should remain unchanged
        Opportunity updatedOpp = [SELECT Id, Manager__c FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals(acc.Id, updatedOpp.Manager__c, 'Manager__c should remain unchanged if already set');
    }


}