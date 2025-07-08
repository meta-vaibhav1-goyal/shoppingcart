public with sharing class StudentMaxLimitTriggerHandler extends fflib_SObjectDomain {
    public StudentMaxLimitTriggerHandler(List<Student__c> sObjectList) {
        super(sObjectList);
    } 


    public class Constructor implements fflib_SObjectDomain.IConstructable {    
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new StudentMaxLimitTriggerHandler(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        preventInsertStudent((List<Student__c>) Records);

    }

    public static void preventInsertStudent(List<Student__c> studentList) {

        List<Id> studentListIds = new List<Id>();

        for(Student__c stud: studentList) {
            
            studentListIds.add(stud.Id);
        
        }

        Map<Id,Boolean> maxLimitMap = new Map<Id,Boolean>();

        List<Id> classIds = new List<Id>();

        for(Student__c stud: studentList){
            classIds.add(stud.Class__c);
        }

        Map<Id,Boolean> classMap = new ClassSelector().classMaxLimit(classIds);


       
        for(Student__c stud: studentList){
            if(classMap.get(stud.Class__c) == false){ 
                stud.addError('Cannot insert new student as max size is already reached.');
            }
        }

        


    }
    
}