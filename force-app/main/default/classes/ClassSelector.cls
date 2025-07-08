public with sharing class ClassSelector extends fflib_SObjectSelector {

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                Class__c.Id,
                Class__c.Name,
                Class__c.MaxSize__c,
                Class__c.NumberOfStudents__c
               
        };     
    }

    public Schema.SObjectType getSObjectType() {
        return Class__c.sObjectType;
    }


    public  Map<Id,Boolean> classMaxLimit (List<Id> classIds) {
        Map<Id,Boolean> classMap = new Map<Id,Boolean>();

         for(Class__c cls: [SELECT Id,MaxSize__c , NumberOfStudents__c FROM Class__c WHERE Id IN: classIds]){
            if(cls.NumberOfStudents__c >= cls.MaxSize__c ){
                classMap.put(cls.Id,false);
            }
            else {
                classMap.put(cls.Id,true);
            }
        }

        return classMap;


    }
    


    
}