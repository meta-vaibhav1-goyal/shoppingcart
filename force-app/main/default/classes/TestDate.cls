@isTest
public class TestDate {

    @isTest
    static void testWorkingDays_OnlyWeekdays() {
        // Mon to Fri (no weekend)
        Date startDate = Date.newInstance(2024, 6, 3); // Monday
        Date endDate = Date.newInstance(2024, 6, 8);   // Saturday

        Integer result = SynchrnousAssignment.getWorkingDaysBetween(startDate, endDate);
        System.assertEquals(4, result, 'Should return 4 working days between Mon and Sat (excluding Sat and start)');
    }

    @isTest
    static void testWorkingDays_WithWeekend() {
        // Fri to Tue (Sat and Sun in between)
        Date startDate = Date.newInstance(2024, 6, 7); // Friday
        Date endDate = Date.newInstance(2024, 6, 11);  // Tuesday

        Integer result = SynchrnousAssignment.getWorkingDaysBetween(startDate, endDate);
        System.assertEquals(1, result, 'Only Monday should be a working day');
    }

    @isTest
    static void testWorkingDays_SameDay() {
        Date startDate = Date.newInstance(2024, 6, 10);
        Date endDate = Date.newInstance(2024, 6, 10);

        Integer result = SynchrnousAssignment.getWorkingDaysBetween(startDate, endDate);
        System.assertEquals(0, result, 'Same start and end date should return 0');
    }

    @isTest
    static void testWorkingDays_StartAfterEnd() {
        Date startDate = Date.newInstance(2024, 6, 12);
        Date endDate = Date.newInstance(2024, 6, 10);

        Integer result = SynchrnousAssignment.getWorkingDaysBetween(startDate, endDate);
        System.assertEquals(0, result, 'Start date after end should return 0');
    }

    @isTest
    static void testWorkingDays_NullInput() {
        Boolean exceptionThrown = false;

        try {
            SynchrnousAssignment.getWorkingDaysBetween(null, Date.today());
        } catch (Exception e) {
            exceptionThrown = true;
            System.assertEquals('Start date and end date cannot be null', e.getMessage());
        }

        System.assert(exceptionThrown, 'Exception should be thrown when startDate is null');

        exceptionThrown = false;
        try {
            SynchrnousAssignment.getWorkingDaysBetween(Date.today(), null);
        } catch (Exception e) {
            exceptionThrown = true;
        }

        System.assert(exceptionThrown, 'Exception should be thrown when endDate is null');
    }
}
