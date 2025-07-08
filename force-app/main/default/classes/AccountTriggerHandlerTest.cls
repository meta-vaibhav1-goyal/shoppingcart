@isTest
public class AccountTriggerHandlerTest {
    
    @testSetup
    public static void setup() {
        
         List<Account> accList = new List<Account>();
        
        for(Integer i = 1; i <= 10; i++) {
            Account acc = new Account();
            acc.Name = 'Test Trigger ' + i;
            acc.Industry = 'Agriculture';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
    }
    
    
    @isTest
    public static void createOppTest() {
        
        /* List<Account> accList = new List<Account>();
        
        for(Integer i = 1; i <= 10; i++) {
            Account acc = new Account();
            acc.Name = 'Test Trigger ' + i;
            acc.Industry = 'Agriculture';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest(); */
        
        List<Account> accList = [SELECT Id FROM Account];
        
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE AccountId =: accList[0].Id];
        
        System.assert(oppList != null, 'Opportunity is not created');
        
    }
    
     
    
    @isTest
    
    public static void updateCreateOppTest() {
        
	/*	List<Account> accList = new List<Account>();
        
        for(Integer i = 1; i <= 10; i++) {
            Account acc = new Account();
            acc.Name = 'Test Trigger ' + i;
            acc.Industry = 'Media';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList; */
        
        List<Account> accList = [SELECT Id, Industry FROM Account];
        
        for(Account acc: accList) {
            acc.Industry = 'Agriculture';
        }
        
        Test.startTest();
        update accList;
        
        Test.stopTest();
        
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE AccountId =: accList[0].Id];
        
        System.assert(oppList != null, 'Opportunity is not created');
        
    }
    
    
    @isTest
    public static void createOppNegativeTest() {
        List<Account> accList = new List<Account>();
        
        for(Integer i = 1; i <= 10; i++) {
            Account acc = new Account();
            acc.Name = 'Test Trigger ' + i;
            
            accList.add(acc);
        }
        
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE AccountId =: accList[0].Id];
        
        System.assert(oppList.isEmpty(), 'Opportunity should not be created as Account Industry is null');
    }
    
    
   
    
    

}