public  class AccountTriggerHandler {
   public static void createOpp(List<Account> accList, Map<Id,Account> oldAccMap) {

    List<Opportunity> oppList = new List<Opportunity>();

    for(Account acc: accList) {
        if( (oldAccMap == null && acc.Industry == 'Agriculture') || (acc.Industry != oldAccMap.get(acc.Id).Industry && acc.Industry == 'Agriculture') ) {
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name;
            opp.StageName = 'Prospective';
            opp.CloseDate = System.today();
            opp.AccountId = acc.Id;
            oppList.add(opp);
        } 
    }

    if(!oppList.isEmpty()) {
        insert oppList;
    }

   }
       
}