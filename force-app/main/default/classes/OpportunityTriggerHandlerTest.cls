@isTest
public class OpportunityTriggerHandlerTest {
    
    @testSetup
    public static void setup() {
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Integer i = 1; i <= 10; i++) {
            Opportunity opp = new Opportunity();
            opp.Name = 'Opp Test ' + i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.newInstance(2025, 01, 15);
            oppList.add(opp);
        }
        
        Test.startTest();
        insert oppList;
        Test.stopTest();
    }
    
    
    @isTest 
    public static void updateCloseDateTest1() {
        List<Opportunity> oppList = [SELECT Id, Name, StageName, CloseDate FROM Opportunity];
        
        for(Opportunity opp: oppList) {
            opp.StageName = 'Closed Won';
        }
        
        Test.startTest();
        update oppList;
        Test.stopTest();
        
        List<Opportunity> updatedOppList = [SELECT Id, StageName, CloseDate FROM Opportunity WHERE Id =: oppList[0].Id];
        
        System.assertEquals(System.today(), updatedOppList[0].CloseDate, 'Opp Close Date Should be equal to Today Date');
        
    }
    
     @isTest 
    public static void updateCloseDateTest2() {
        List<Opportunity> oppList = [SELECT Id, Name, StageName, CloseDate FROM Opportunity];
        
        for(Opportunity opp: oppList) {
            opp.StageName = 'Closed Lost';
        }
        
        Test.startTest();
        update oppList;
        Test.stopTest();
        
        List<Opportunity> updatedOppList = [SELECT Id, StageName, CloseDate FROM Opportunity WHERE Id =: oppList[0].Id];
        
        System.assertEquals(System.today(), updatedOppList[0].CloseDate, 'Opp Close Date Should be equal to Today Date');
        
    }
    
    
     @isTest 
    public static void updateClosedDateNegativeTest() {
        List<Opportunity> oppList = [SELECT Id, Name, StageName, CloseDate FROM Opportunity];
        
         // Updating with different value of stageName to test the negative case
        for(Opportunity opp: oppList) {
            opp.StageName = 'Qualification';
        }
        
        Test.startTest();
        update oppList;
        Test.stopTest();
        
        List<Opportunity> updatedOppList = [SELECT Id, StageName, CloseDate FROM Opportunity WHERE Id =: oppList[0].Id];
        
        System.assertNotEquals(System.today(), updatedOppList[0].CloseDate, 'Opp Close Date Should Not be equal to Today Date');
        
    }
    
    @isTest
    public static void updateClosedDateNegativeTest_OppStageNotUpdated() {
         List<Opportunity> oppList = [SELECT Id, Name, StageName, CloseDate FROM Opportunity];
        
        Test.startTest();
        
        List<Opportunity> updatedOppList = [SELECT Id, StageName, CloseDate FROM Opportunity WHERE Id =: oppList[0].Id];
        
        Test.stopTest();
        
        System.assertEquals(Date.newInstance(2025, 01, 15), updatedOppList[0].CloseDate, 'Opp Close Date Remains Same since StageName is not updated');
        
        
    }
    

}