trigger ClassCustomStatusTrigger on CLass__c (after update) {

    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            ClassCustomStatusTriggerHandler.deleteStudentRelatedRecords(Trigger.New, Trigger.oldMap);
        }
    }

}