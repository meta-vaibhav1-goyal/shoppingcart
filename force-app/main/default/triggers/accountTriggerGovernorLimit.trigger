trigger accountTriggerGovernorLimit on Account (before delete, before insert, before update) {

    Set<Id> accountIds = new Set<Id>();

    if(Trigger.isUpdate || Trigger.isDelete) {
        accountIds.addAll(Trigger.newMap.keySet());
    } else if(Trigger.isInsert) {
        for(Account acc: Trigger.new) {
            if(acc.Id != null) {
                accountIds.add(acc.Id);
            }
        }
    }

    if(accountIds.isEmpty()) return ;





    List<Opportunity> oppList = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE 
    accountId IN: accountIds and StageName IN ('Closed - Won', 'Closed - Lost')];


    // Grouping opp by AccountId
    Map<Id, List<Opportunity>> oppMap = new Map<Id, List<Opportunity>>();

    for(Opportunity opp: oppList) {
        if(!oppMap.containsKey(opp.accountId)) {
            oppMap.put(opp.accountId, new List<Opportunity>());
        }
        oppMap.get(opp.accountId).add(opp);
    }


    for(Account acc: Trigger.new) {
        // releted opp to acc 
        List<Opportunity> releatedAccOpps = oppMap.get(acc.Id);
        if(releatedAccOpps != null) {
            for(Opportunity opp: releatedAccOpps) {
                if(opp.StageName == 'Closed - Won') {

                    System.debug('Closed Won Opportunity ' + opp.Name);
                    
                } else if(opp.StageName == 'Closed - Lost') {
                    System.debug('Closed Lost Opportunity ' + opp.Name);
                    
                }
            }
        }
    }

}