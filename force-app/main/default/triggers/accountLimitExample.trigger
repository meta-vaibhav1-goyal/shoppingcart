trigger accountLimitExample on Account (after delete, after insert, after update) {

    System.debug('Total Number of SOQL Queries allowed in this Apex code context: ' + Limits.getLimitQueries());

    System.debug('Total Number of records that can be queried in this Apex code context: ' + Limits.getLimitApexCursorRows());

    System.debug('Total Number of DML statements allowed in this Apex code context: ' + Limits.getLimitDMLRows());

    System.debug('Total Number of CPU usage time (in ms) allowed in this Apex code context: ' + Limits.getLimitCpuTime());

// Query the Opportunity object

    List<Opportunity> opptys = [select id, description, name, accountid, closedate, stagename from Opportunity where accountId IN : Trigger.newMap.keySet()];
    
    System.debug('1. Number of Queries used in this Apex code so far: ' + Limits.getAggregateQueries());

    System.debug('2. Number of rows queried in this Apex code so far: ' + Limits.getApexCursorRows());

    System.debug('3. Number of DML statements used so far: ' + Limits.getDmlRows());

    System.debug('4. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime());

//Proactively determine if there are too many Opportunities to update and avoid governor limits

    if(opptys.size() > Limits.getLimitDmlRows()) {

        // Logic to avoid governor limits - addError
        // We can throw an exception

    } else{

        System.debug('Continue processing. Not going to hit DML governor limits');

        System.debug('Going to update ' + opptys.size() + ' opportunities and governor limits will allow ' + Limits.getLimitDmlRows());

        for(Account a : Trigger.new){

            System.debug('Number of DML statements used so far: ' + Limits.getDmlStatements());

            for(Opportunity o: opptys){

                if (o.accountid == a.id)

                o.description = 'testing';

            }

        }

        update opptys;

        System.debug('Final number of DML statements used so far: ' + Limits.getDmlStatements());

        System.debug('Final heap size: ' + Limits.getHeapSize());

    }
}