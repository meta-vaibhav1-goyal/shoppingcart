trigger StudentMyCountTrigger on Student__c (after insert, after update) {

   if(Trigger.isAfter) {
    StudentMyCountTriggerHandler.updateClassMyCount(Trigger.New, Trigger.oldMap);
   }

}