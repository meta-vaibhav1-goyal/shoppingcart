@isTest
public  class ClassStudentMapTest {

    @isTest
    static void testGetClassStudent_PostiveTest() {
        Class__c class1 = new Class__c(Name='Class A');
        insert class1;
        
        List<Student__c> students = new List<Student__c>();

        for(Integer i=0; i < 5; i++) {
            Student__c student = new Student__c(Name='Student' + i, Class__c = class1.Id);
            students.add(student);
        }

        insert students;

        Test.startTest();
        Map<Id,Set<Id>> result = SynchrnousAssignment.getClassStudents();
        Test.stopTest();

        System.assert(result.containsKey(class1.Id), 'Map should contain class1 id');
        System.assertEquals(5, result.get(class1.Id).size(), 'Should have 5 students in the set');
    }


    @isTest
    static void testGetClassStudent_NegativeTest() {
        Class__c class2 = new Class__c(Name='Empty Class');
        insert class2;

        Test.startTest();
        Map<Id, Set<Id>> result = SynchrnousAssignment.getClassStudents();
        Test.stopTest();

        System.assert(result.containsKey(class2.Id), 'Map should contain class2 id');
        System.assertEquals(0, result.get(class2.Id).size(), 'Set should be empty for no students in the class');
    
    }

    @isTest
    static void testGetClassStudent_NoClass() {
        
        Test.startTest();
        Map<Id, Set<Id>> result = SynchrnousAssignment.getClassStudents();
        Test.stopTest();

        System.assertEquals(0, result.size(), 'Map should not have any classes');
    }


    
}