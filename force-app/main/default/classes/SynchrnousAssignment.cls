public  class SynchrnousAssignment {
     // Create a class and a static function which takes classId as argument and returns all names of the
    // students in that class as a list. 


    public static List<String> studentsInClass(Id classId){

        List<Student__c> students = [SELECT Name FROM Student__c WHERE Class__c = :classId];

        List<String> studentNames = new List<String>();

        for(Student__c student : students){
            studentNames.add(student.Name);
        }
        return studentNames;

    }

    // list of class ids and students list 
    
    // returns a map of class as key and student id set as values.
    public static Map<Id, Set<Id>> getClassStudents(){

        Map<Id, Set<Id>> output = new Map<Id, Set<Id>>();

        List<Class__c> results = [SELECT Id, (SELECT Id FROM Students__r) FROM Class__c];

        for (Class__c classRecord : results) {
            Set<Id> studentIds = new Set<Id>();

            for (Student__c student : classRecord.Students__r) {
                studentIds.add(student.Id);
            }

            output.put(classRecord.Id, studentIds);
        }

        return output;

    }


    public static Integer getWorkingDaysBetween(Date startDate, Date endDate) {
       
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException('Start date and end date cannot be null');
        }
        
        if (startDate >= endDate) {
            return 0; 
        }
        
        Integer workingDays = 0;
        Date currentDate = startDate.addDays(1); // Not including start date
        
        // Loop through each day between start and end dates (exclusive)
        while (currentDate < endDate) {
            // Get the day of week (1=Sunday, 2=Monday, ..., 7=Saturday)
            // we take 1900-1-7 as a reference
            Integer dayOfWeek = Math.mod(Date.newInstance(1900, 1, 7).daysBetween(currentDate), 7) + 1;
            
            // Check if it's a weekday (Monday=2 to Friday=6)
            if (dayOfWeek >= 2 && dayOfWeek <= 6) {
                workingDays++;
            }
            
            currentDate = currentDate.addDays(1);
        }
        
        return workingDays;
    }

    


    // Create a class which show the list of sobjects exists in org.
    public static List<String> getAllSObjects(){
        
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

        List<String> sObjectNameList = new List<String>();

        for(String sObjectName : globalDescribe.keySet()){

            Schema.SObjectType sObjectType = globalDescribe.get(sObjectName);
            Schema.DescribeSObjectResult sObjectResult = sObjectType.getDescribe();   
            
            sObjectNameList.add(sObjectResult.getName());

        }
        return sObjectNameList;
    }
}