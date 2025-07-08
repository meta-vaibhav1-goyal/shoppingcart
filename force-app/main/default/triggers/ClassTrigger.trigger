trigger ClassTrigger on Class__c (before delete, before update, before insert, after update, after insert, after delete, after undelete) {
    fflib_SObjectDomain.triggerHandler(ClassTriggerHandler.class);
}