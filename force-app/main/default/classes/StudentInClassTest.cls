@isTest
public  class StudentInClassTest {

    @isTest
    static void testStudentInClass() {
        Class__c testClass = new Class__c(Name = 'Test Class', 	Name__c= 'Test class');
        insert testClass;

        List<Student__c> studentList = new List<Student__c>();

        for(Integer i=0; i < 5; i++) {
            Student__c s = new Student__c(Name = 'Student ' + i , Class__c = testClass.Id);
            studentList.add(s);
        }

        insert studentList;

        Test.startTest();
        List<String> result =  SynchrnousAssignment.studentsInClass(testClass.Id);
        Test.stopTest();

        System.assertEquals(5, result.size());
    }

    @isTest
    static void testStudentInClass_NegativeCase() {
        Class__c emptyClass = new Class__c(Name = 'Empty Class', Name__c= 'Empty Class');
        insert emptyClass;

        Test.startTest();
        List<String> result = SynchrnousAssignment.studentsInClass(emptyClass.Id);
        Test.stopTest();
        
        System.assertEquals(0, result.size(), 'Expected no student names for empty class');
    }

    @isTest
    static void testStudentInClass_InvalidId() {
        
        Test.startTest();
        List<String> result = SynchrnousAssignment.studentsInClass(null);
        Test.stopTest();

        System.Assert.areEqual(0, result.size(), 'Expected no student names when null class Id passed');
    }

   
}