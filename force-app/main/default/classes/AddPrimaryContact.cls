public with sharing class AddPrimaryContact implements Queueable{

    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact contact, String state) {
        this.contact = contact;
        this.state = state;
    }
    public void execute(QueueableContext context){
        

        List<Account> accounts = [SELECT Id,Name FROM Account WHERE BillingState =: state LIMIT 200];

        List<Contact> cons = new List<Contact>();

        for(Account acc: accounts) {
            Contact con = contact.clone(false, false, false, false);
            con.AccountId = acc.id;
            cons.add(con);
        }

        if(!cons.isEmpty()) {
            insert cons;
        }

        
        
        

       
    }





}