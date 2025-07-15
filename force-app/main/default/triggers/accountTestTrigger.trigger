trigger accountTestTrigger on Account (before insert, before update) {

    List<Id> accountIds = new List<Id>();

    for(Account acc: Trigger.New) {

        accountIds.add(acc.Id);
    }

    List<Contact> contacts = [SELECT Id, salutation, FirstName, LastName, Email FROM Contact WHERE AccountId IN: accountIds];



    List<Contact> updateContacts = new List<Contact>();

    for(Contact c: contacts) {
        c.Description = c.salutation + ' ' + c.FirstName + ' ' + c.LastName;
        updateContacts.add(c);
    }

    if(!updateContacts.isEmpty()) {
        update updateContacts;
    }

}