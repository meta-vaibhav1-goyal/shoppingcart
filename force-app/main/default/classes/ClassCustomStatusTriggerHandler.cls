public  class ClassCustomStatusTriggerHandler {

    public static void deleteStudentRelatedRecords(List<Class__c> classList, Map<Id,Class__c> classOldMap) {
        
        for(Class__c clas: classList) {
            if(clas.Custom__c != classOldMap.get(clas.Id).Custom__c && clas.Custom__c == 'Reset' ) {
                delete [Select Id from Student__c Where Class__c =:clas.Id];
            }
        }
    }
}