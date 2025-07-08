public with sharing class ClassTriggerHandler extends fflib_SObjectDomain {


    public ClassTriggerHandler(List<Class__c> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ClassTriggerHandler(sObjectList);
        }
    }

   
    public override void onBeforeDelete(){
        preventDelete((List<Class__c>)Records);
    }

    public void preventDelete(List<Class__c> classList) {

        List<Id> ClassIdList = new List<Id>();

        for(Class__c cls : classList){
            ClassIdList.add(cls.Id);
        }

        Map<Id,Integer> femaleCount = new StudentSelector().femaleStudentCount(ClassIdList);

        for(Class__c clas: classList) {
            
            if(femaleCount.get(clas.Id) > 1) {
                clas.addError('Class cannot be deleted because it has more than 1 female students');
            }
        }

    }
}