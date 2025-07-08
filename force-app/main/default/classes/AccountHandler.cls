public class AccountHandler {
    
    public static Account insertNewAccount(String s) {
        
        try {
            Account acct = new Account(Name = s);
            insert acct;
            return acct;
            
        } catch(DmlException e) {
            System.debug('A DML exception has occurred: ' +
                e.getMessage());
            	return null;
        }
    }

}