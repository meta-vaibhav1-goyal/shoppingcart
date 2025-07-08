trigger StudentMaxLimitTrigger on Student__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    fflib_SObjectDomain.triggerHandler(StudentMaxLimitTriggerHandler.class);
    

}