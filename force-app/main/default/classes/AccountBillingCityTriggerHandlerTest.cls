@isTest
public class AccountBillingCityTriggerHandlerTest {
    
    @testSetup
    public static void setup() {
        List<Account> accList = new List<Account>();
        
        for(Integer i = 1; i <= 10; i++) {
            Account acc = new Account();
            acc.Name = 'Test ' + i;
            acc.BillingCity = 'Paris';
            accList.add(acc);
        }
        Test.startTest();
        insert accList;
        List<Contact> conList = new List<Contact>();
        
        for(Account acc: accList) {
            Contact con = new Contact();
            con.FirstName = 'Test Contact ';
            con.LastName = 'Test Contact LastName';
            con.MailingCity = 'Jaipur';
            con.AccountId = acc.Id;
            conList.add(con);
        }
        
        
        insert conList;
        Test.stopTest();
    }
    
    
    @isTest
    public static void updateContactTest() {
        
        List<Account> accList = [SELECT Id,BillingCity FROM Account];
        
        for(Account acc: accList) {
            acc.BillingCity = 'Parisss';
        }
        
        Test.startTest();
        update accList;
        Test.stopTest();
        
        List<Contact> conList = [SELECT Id,AccountId, MailingCity FROM Contact WHERE AccountId =: accList[0].Id];
        
        System.assertEquals( 'Parisss', conList[0].MailingCity, 'MailingCity of Related Contact Must be Equal to Account BillingCity');
    }
    
    @isTest
    public static void updateContactNegativeTest() {
        List<Account> accList = [SELECT Id,BillingCity FROM Account];
        
        for(Account acc: accList) {
            acc.BillingCity = 'Jaipur';
        }
        
        Test.startTest();
        update accList;
        Test.stopTest();
        
         
        List<Contact> conList = [SELECT Id,AccountId, MailingCity FROM Contact WHERE AccountId =: accList[0].Id];
        
        System.assertNotEquals( 'Parisss', conList[0].MailingCity, 'MailingCity of Related Contact Must be Equal to Account BillingCity');
        
    }
    
    
    
    @isTest
    public static void updateContactAccountBillingCityNotUpdated() {
         List<Account> accList = [SELECT Id,BillingCity FROM Account];
        
        Test.startTest();
        update accList;
        Test.stopTest();
        
        List<Contact> conList = [SELECT Id,AccountId, MailingCity FROM Contact WHERE AccountId =: accList[0].Id];
        
        System.assertNotEquals( 'Parisss', conList[0].MailingCity, 'MailingCity of Related Contact is same as initial since Account BillingCity is not updated');
        
        
    }
    
    
    
    
    

}