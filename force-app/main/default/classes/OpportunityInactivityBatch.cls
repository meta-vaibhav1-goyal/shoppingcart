global  class OpportunityInactivityBatch implements Database.Batchable<sObject>,Database.Stateful{

    Integer recordCount = 0;

    global Database.QueryLocator start(Database.BatchableContext bc){
        Date thirtyDaysAgo = Date.today().addDays(-30);
        return Database.getQueryLocator([SELECT Id, Name, LastModifiedDate,
                                        Owner.Email FROM Opportunity WHERE LastModifiedDate <= : thirtyDaysAgo ]);

    }

    global void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        for(Opportunity opp: scope) {
            if(opp.Owner.Email != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[]{opp.Owner.Email});
                mail.setSubject('Opportunity that has not been modified');
                mail.setPlainTextBody('Dear ' + opp.Owner.Name + ',\n\nThe Opportunity "' + opp.Name + ' " has not been modified for the past 30 days.Please review it.\n\nThanks.');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
            }
        }

        recordCount = recordCount + scope.size();
    }

    global void finish(Database.BatchableContext bc) {
        System.debug('Total records processed ' + recordCount);
    }

}