@isTest
public with sharing class ClassTriggerHandlerTest {

     @isTest
    static void testDeletionBlocked() {
        // Create class
        Class__c cls = new Class__c(Name = 'Test Class', Name__c = 'Test Class Custom');
        insert cls;

        // Add 2 female students
        List<Student__c> students = new List<Student__c>{
            new Student__c(Name = 'Alice', FirstName__c = 'FN1', LastName__c = 'LN1', Sex__c = 'Female', Class__c = cls.Id),
            new Student__c(Name = 'Jane', FirstName__c = 'FN2', LastName__c = 'LN2',Sex__c = 'Female', Class__c = cls.Id)
        };
        insert students;

        // Try to delete class (should fail)
        Test.startTest();
        try {
            Database.DeleteResult dbDel = Database.delete(cls, false);
            System.Assert.isFalse(dbDel.isSuccess(), 'Çlass Deletion is successful, it was not expected...');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Cannot delete this class'), 'Expected error not found');
        }
        Test.stopTest();
    }

    @isTest
    static void testDeletionAllowed() {
        // Create class
        Class__c cls = new Class__c(Name = 'Test Class 2', Name__c = 'Test Class Custom');
        insert cls;

        // Add 1 female student
        Student__c student = new Student__c(Name = 'Emily', FirstName__c = 'FN1', LastName__c = 'LN1', Sex__c = 'Female', Class__c = cls.Id);
        insert student;

        // Try to delete class (should pass)
        Test.startTest();
        delete cls;
        Test.stopTest();

        // If no error, deletion passed
        System.assert(true, 'Deletion allowed as expected');
    }
   
}
