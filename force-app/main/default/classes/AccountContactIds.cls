
public class  AccountContactIds  implements Queueable {

    private Id contactId;

    public  AccountContactIds (Id contactId) {
        this.contactId = contactId;
    }

    public void execute(QueueableContext context) {
        // Step 1: Get the Contact record along with its Account
        Contact con = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId LIMIT 1];

        if(con == null) {
            throw new  System.QueryException();
        }

        if (con.AccountId == null) {
            return; 
        }

        // Step 2: Fetch the Account with ContactIDs__c field
        Account acc = [SELECT Id, ContactIDs__c FROM Account WHERE Id = :con.AccountId LIMIT 1];

        if (acc.ContactIDs__c == null) {
          
            List<Contact> contactList = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
            List<String> contactIds = new List<String>();

            for (Contact c : contactList) {
                contactIds.add(c.Id);
            }

            acc.ContactIDs__c = String.join(contactIds, ',');
        } else {
            String contIds = acc.ContactIDs__c;
            List<String> existingIds = contIds.split(',');
            if (!existingIds.contains(con.Id)) {
                existingIds.add(con.Id);
                acc.ContactIDs__c = String.join(existingIds, ',');
            }
        }

        

        update acc;
    }
}