

public class UpdateOppManager  implements Queueable {

    List<Opportunity> oppList;

    public UpdateOppManager(List<Opportunity> opportunities) {
        this.oppList = opportunities;
    }

    public void execute(QueueableContext context) {
        // Step 1: Collect Contact IDs from BillToContact__c
        Set<Id> contactIds = new Set<Id>();

        for (Opportunity opp : oppList) {
            if (opp.BillToContact__c != null && opp.Manager__c == null) {
                contactIds.add(opp.BillToContact__c);
            }
        }

        if (contactIds.isEmpty()) return;

        // Step 2: Query Contacts and their related Accounts
        Map<Id, Contact> contactMap = new Map<Id, Contact>(
            [SELECT Id, AccountId FROM Contact WHERE Id IN :contactIds]
        );

        
        List<Opportunity> toUpdate = new List<Opportunity>();

        for (Opportunity opp : oppList) {
            if (opp.BillToContact__c != null && opp.Manager__c == null) {
                Contact relatedContact = contactMap.get(opp.BillToContact__c);
                if (relatedContact != null && relatedContact.AccountId != null) {
                    opp.Manager__c = relatedContact.AccountId;
                    toUpdate.add(opp);
                }
            }
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}
