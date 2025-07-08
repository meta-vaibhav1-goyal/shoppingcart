
@isTest
public class TestOpportunityInactivityBatch {

    @testSetup
    static void setupTestData() {
        // Create a user with an email
        User u = new User(
            Alias = 'tuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser' + DateTime.now().getTime() + '@test.com'
        );
        insert u;

        // Create Opportunity older than 30 days with valid owner
        Opportunity opp1 = new Opportunity(
            Name = 'Old Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            OwnerId = u.Id,
            LastModifiedDate = Date.today().addDays(-35)
        );
        insert opp1;

        // Create Opportunity within 30 days (should not be picked up)
        Opportunity opp2 = new Opportunity(
            Name = 'Recent Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            OwnerId = u.Id
        );
        insert opp2;
    }

    @isTest
    static void testBatchExecution_Positive() {
        Test.startTest();
        OpportunityInactivityBatch batch = new OpportunityInactivityBatch();
        Database.executeBatch(batch, 1);
        Test.stopTest();

        // Assertions
        System.assertEquals(1, batch.recordCount, 'Should have processed only one Opportunity');
    }

    @isTest
    static void testBatchExecution_NoEmail_Negative() {
        // Create user without email
        User noEmailUser = new User(
            Alias = 'noemail',
            Email = null,
            EmailEncodingKey = 'UTF-8',
            LastName = 'NoEmail',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'noemailuser' + DateTime.now().getTime() + '@test.com'
        );
        insert noEmailUser;

        // Create old opportunity for user with no email
        Opportunity opp = new Opportunity(
            Name = 'No Email Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(10),
            OwnerId = noEmailUser.Id,
            LastModifiedDate = Date.today().addDays(-40)
        );
        insert opp;

        Test.startTest();
        OpportunityInactivityBatch batch = new OpportunityInactivityBatch();
        Database.executeBatch(batch, 1);
        Test.stopTest();

        // Since we don't have access to sent emails directly, just assert record count
        System.assertEquals(1, batch.recordCount, 'Should still process record even if email not sent');
    }
}
