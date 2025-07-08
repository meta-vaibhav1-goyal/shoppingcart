public  class OpportunityTriggerHandler {
    
    public static void updateCloseDate(List<Opportunity> oppList, Map<Id,Opportunity> oppOldMap) {

        for(Opportunity opp: oppList) {
            if(opp.StageName != oppOldMap.get(opp.Id).StageName && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost' )) {
                opp.CloseDate = System.today();
            }
        }

        
    }
}