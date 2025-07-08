public with sharing class OpportunityBillToContactTriggerHandler {
    public static void updateOppManager(List<Opportunity> oppList, Map<Id,Opportunity> oppOldMap) {

        Set<Id> contactIds = new Set<Id>();

        for(Opportunity opp: oppList) {
            if(opp.BillToContact__c != null && opp.Manager__c == null) {
                contactIds.add(opp.BillToContact__c);
            }
        }

        if(contactIds.isEmpty()) return;

        Map<Id,Contact> contactMap = new Map<Id,Contact>(
            [SELECT Id,AccountId FROM Contact WHERE Id IN: contactIds]
        );

        List<Opportunity> toUpdate = new List<Opportunity>();

        for(Opportunity opp: oppList) {
            if(opp.BillToContact__c != null && opp.Manager__c == null) {
                Contact relatedContact = contactMap.get(opp.BillToContact__c);
                if(relatedContact != null && relatedContact.AccountId != null) {
                    opp.Manager__c = relatedContact.AccountId;
                    toUpdate.add(opp);
                }
            }
        }

        if(!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}