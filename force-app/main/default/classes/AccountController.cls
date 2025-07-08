public with sharing class AccountController {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        List<Account> accList = new List<Account>();
        accList = [SELECT Id, Name,AnnualRevenue,NumberOfEmployees,Phone FROM Account LIMIT 10];
        return accList;
    }
}