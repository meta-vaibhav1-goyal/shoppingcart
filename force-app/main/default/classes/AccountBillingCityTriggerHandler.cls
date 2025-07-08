public with sharing class AccountBillingCityTriggerHandler {
    public static void updateContact(List<Account> accList, Map<Id,Account> oldAccMap) {


        Map<Id,Account> accMap = new Map<Id,Account>();

        List<Contact> conList = new List<Contact>();

        for(Account acc: accList) {
            if(acc.BillingCity != oldAccMap.get(acc.Id).BillingCity) {
                accMap.put(acc.Id,acc);
            }
        }

        For(Contact con : [SELECT Id, MailingCity, AccountId FROM Contact WHERE AccountId IN: accMap.keySet()]) {
            if(accMap.containsKey(con.AccountId)) {
                con.MailingCity = accMap.get(con.AccountId).BillingCity;
                conList.add(con);
            }
        }


        if(!conList.isEmpty()) {
            update conList;
        }

        

    }
}