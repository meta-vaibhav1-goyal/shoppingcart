public with sharing class StudentMyCountTriggerHandler {
    
    public static void updateClassMyCountInsert(List<Student__c> studentList) {

        List<Id> classIds = new List<Id>();

        
        for(Student__c stud: studentList){
            if(stud.Class__c != null) {
                classIds.add(stud.Class__c);
            }
           
        }
        
   

        if(classIds.isEmpty()) return ;
                

        
        Map<Id, Class__c> classMap =  new Map<Id, Class__c>(
            [SELECT Id, MyCount__c FROM Class__c WHERE Id IN :classIds]
        );


        for(Id classId: classIds) {
            if(classMap.containsKey(classId)) {
                classMap.get(classId).MyCount__c = classMap.get(classId).MyCount__c + 1;
            }
        }

        update classMap.values();
    }
    
    
    public static void updateClassMyCountUpdate(List<Student__c> studentList, Map<Id,Student__c> studOldMap) {
        
        List<Id> newClassIds = new List<Id>();
        List<Id> oldClassIds = new List<Id>();
        
        for(Student__c stu: studentList) {
            if(stu.Class__c != studOldMap.get(stu.Id).Class__c) {
                oldClassIds.add(studOldMap.get(stu.Id).Class__c);
                newClassIds.add(stu.Class__c);
            }
        }
        
        Map<Id,Class__c> oldClassMap = new Map<Id,Class__c>(
        [SELECT Id, MyCount__c FROM Class__c WHERE Id IN: oldClassIds]);
        
        Map<Id,Class__c> newClassMap = new Map<Id,Class__c>(
        [SELECT Id, MyCount__c FROM Class__c WHERE Id IN: newClassIds]);
        
        for(Id oldClsId: oldClassIds) {
            oldClassMap.get(oldClsId).MyCount__c =  oldClassMap.get(oldClsId).MyCount__c - 1;
        }
        
         for(Id newClsId: newClassIds) {
            newClassMap.get(newClsId).MyCount__c =  newClassMap.get(newClsId).MyCount__c + 1;
        }
      
        
    }
    

       
}