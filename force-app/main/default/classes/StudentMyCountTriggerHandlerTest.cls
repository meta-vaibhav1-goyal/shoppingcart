@isTest
public class StudentMyCountTriggerHandlerTest {
    
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
        
        for(Class__c cls : classList) {
            Student__c stu = new Student__c();
            stu.Name = 'Student Test';
            stu.FirstName__c = 'Student Test FirstName';
            stu.LastName__c = 'Student Test LastName';
            stu.Class__c = cls.Id;
            studentList.add(stu);
        }
        
        insert studentList;
        
        Test.stopTest();
        
     }
    
    
    @isTest 
    public static void updateClassMyCountTest() {
        
        Test.startTest();
        
  		List<Class__c> classList = [SELECT Id, MyCount__c FROM Class__c];
        
        Test.stopTest();
        
        System.assertEquals(1, classList[0].MyCount__c, 'MyCount__c should be equal to one as each class as One student');
        
    }
    
    
    @isTest
    public static void updateClassMyCountTest_CaseWhenStudentDelete() {
        
        Test.startTest();
        
        List<Class__c> classList = [SELECT Id, MyCount__c FROM Class__c];
        
        for(Class__c cls: classList) {
            List<Student__c> stuList = [SELECT Id, Class__c FROM Student__c WHERE Class__c =: cls.Id];
            
           
            
            delete stuList;
            
           
        }
        
        Test.stopTest();
        
        
        List<Student__c> studentList = [SELECT Id, Class__c FROM Student__c WHERE Class__c =: classList[0].Id];
        
        System.assertEquals(studentList.size(), 0, 'Class should not have any related students');
        System.assertEquals(0, classList[0].MyCount__c);
        
    }

}