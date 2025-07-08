trigger AccountBillingCityTrigger on Account (after update) {

    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            AccountBillingCityTriggerHandler.updateContact(Trigger.New, Trigger.oldMap);
        }
    }



}