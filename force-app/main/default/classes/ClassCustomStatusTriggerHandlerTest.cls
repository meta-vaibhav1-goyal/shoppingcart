@isTest
public class ClassCustomStatusTriggerHandlerTest {
    
    @testSetup
    public static void setup() {
        List<Class__c> classList = new List<Class__c>();
        
        for(Integer i = 1; i <= 10; i++) {
            Class__c c = new Class__c();
            c.Name = 'Test Class ' + i;
            c.Name__c = 'Test Class Custom ' + i;
            classList.add(c);
        }
        
        Test.startTest();
        insert classList;
        
        List<Student__c> studentList = new List<Student__c>();
        for(Class__c clas: classList) {
            Student__c s = new Student__c();
            s.Name = 'Test Student';
            s.LastName__c = 'Test Student LastName';
            s.Class__c = clas.Id;
            studentList.add(s);
        }
        
        insert studentList;
        
        Test.stopTest();
       
    }
    
    @isTest
    public static void deleteStudent() {
        List<Class__c> classList = [SELECT Id, 	Custom__c FROM Class__c];
        
        for(Class__c cls: classList) {
            cls.Custom__c = 'Reset';
        }
        
        Test.startTest();
        update classList;
        Test.stopTest();
        
        List<Student__c> studentList = [SELECT Id, Class__c FROM Student__c WHERE Class__c =: classList[0].Id];
        
        System.assert(studentList.isEmpty(), 'No Such Student Should be found as it should be deleted due to class Custom Status To reset');
     }
    
    @isTest
    public static void deleteStudentNegativeTest() {
         List<Class__c> classList = [SELECT Id, Custom__c FROM Class__c];
        
        for(Class__c cls: classList) {
            cls.Custom__c = 'New';
        }
        
        Test.startTest();
        update classList;
        Test.stopTest();
        
        List<Student__c> studentList = [SELECT Id, Class__c FROM Student__c WHERE Class__c =: classList[0].Id];
        
        System.assert(!studentList.isEmpty(), 'Student Should Not be deleted');
    }
    
    
    @isTest
    public static void deleteStudentNegativeTest_NoUpdateOfCustomStatus() {
        
         List<Class__c> classList = [SELECT Id, Custom__c FROM Class__c];
        
        Test.startTest();
        
        List<Student__c> studentList = [SELECT Id, Class__c FROM Student__c WHERE Class__c =: classList[0].Id];
        
        Test.stopTest();
        
        System.assert(!studentList.isEmpty(), 'Student Should Not be Empty as Custom Status is not updated');
        
    }
    
    
    
    
    
    
    
    

}