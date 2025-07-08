@isTest
public class StudentMaxLimitTriggerHandlerTest {
    
   
    
    @isTest
    public static void onBeforeInsert() {

        Class__c c = new Class__c(Name = 'Another class', MaxSize__c = 2, Name__c = 'Another Class');
        insert c;

        

        List<Student__c> validStudents = new List<Student__c>();
        for(Integer i = 0; i < 2; i++) {
            Student__c s = new Student__c();
            s.Name = 'Valid ' + i;
            s.FirstName__c = 'FN ' + i;
            s.LastName__c = 'LN ' + i;
            s.Class__c = c.Id;
            validStudents.add(s);
        }

        insert validStudents;
    
        // List<Student__c> extraStudents = new List<Student__c>();     
        
        Student__c s = new Student__c();
        s.Name = 'Valid ';
        s.FirstName__c = 'FN';
        s.LastName__c = 'LN ';
        s.Class__c = c.Id;
              
        
        Test.startTest();
        
        try {
            Database.SaveResult dbInsert = Database.insert(s, false);
            System.Assert.isFalse(dbInsert.isSuccess(), 'Student is inserted, it was not expected to insert ');
           
       	} catch(DmlException e) {
            System.assert(e.getMessage().contains('Cannot add more students'), 'Excepted error not thrown');
        }
        Test.stopTest();
       
    } 
    
    
    
    @isTest
    public static void testWithInLimit() {
        Class__c c = new Class__c(Name = 'Another class', MaxSize__c = 3, Name__c = 'Another Class');
        insert c;
        
        List<Student__c> validStudents = new List<Student__c>();
        for(Integer i = 0; i < 2; i++) {
            Student__c s = new Student__c();
            s.Name = 'Valid ' + i;
            s.FirstName__c = 'FN ' + i;
            s.LastName__c = 'LN ' + i;
            s.Class__c = c.Id;
            validStudents.add(s);
        }
        
        Test.startTest();
        insert validStudents;
        Test.stopTest();
        
        List<Student__c> inserted = [SELECT Id, Class__c FROM Student__c WHERE Class__c =: c.Id];
        
        System.assertEquals(2, inserted.size(),'Should insert students within limits');
        
        
        
    }

}