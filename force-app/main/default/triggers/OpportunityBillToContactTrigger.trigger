trigger OpportunityBillToContactTrigger on Opportunity (before update) {

    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            OpportunityBillToContactTriggerHandler.updateOppManager(Trigger.New, Trigger.oldMap);
        }
    }

}