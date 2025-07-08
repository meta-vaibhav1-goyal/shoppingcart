global class OpportunityInactivityScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
        OpportunityInactivityBatch b = new OpportunityInactivityBatch();
        Database.executeBatch(b, 50);
    }
    
}