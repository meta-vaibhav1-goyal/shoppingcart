@isTest
public class SObjectTest {

    @isTest
    static void testGetAllSObjects() {
        List<String> result = SynchrnousAssignment.getAllSObjects();

        System.assert(result != null , 'Result should not be null');
        System.assert(result.size() > 0, 'Result should contain at least one SObject');
        System.assert(result.contains('Account'), 'Result should contain Account');
        System.Assert(result.contains('Contact'), 'Result should contain Contact');

    }
}

   

