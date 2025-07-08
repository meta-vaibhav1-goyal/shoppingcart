trigger AccountTrigger on Account (after insert, after update) {

    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            AccountTriggerHandler.createOpp(Trigger.New, null);
        } else if(Trigger.isUpdate) {
            AccountTriggerHandler.createOpp(Trigger.New, Trigger.oldMap);
        }
    } 

}