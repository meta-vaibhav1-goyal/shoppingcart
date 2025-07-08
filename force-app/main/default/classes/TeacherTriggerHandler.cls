public  class TeacherTriggerHandler {

    

    public static void preventTeacherUpdate(List<Teacher__c> teachersList) {

        List<Teach__c> teachList = [SELECT  Teacher__c, Subject__c FROM Teach__c WHERE Teacher__c IN : teachersList];
        List<String> teachSubjectList = new List<String>();

        for (Teach__c teach : teachList) {
            teachSubjectList.add(teach.Subject__c);
        }

        for(Teacher__c teacher : teachersList) {
            if (teachSubjectList.contains('Hindi')) {
                teacher.Subject__c.addError('Can\'t create because teacher has class with same subject');
            }
        }



    }
        
    
}