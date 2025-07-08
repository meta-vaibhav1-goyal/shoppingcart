public with sharing class StudentSelector extends fflib_SObjectSelector{
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                Student__c.Id,
                Student__c.Name,
                Student__c.Sex__c,
                Student__c.Class__c
            };
    }
    public Schema.SObjectType getSObjectType() {
        return Student__c.sObjectType;
    }

    public Map<Id, Integer> femaleStudentCount(List<Id> classIds){
        Map<Id,Integer> classMap = new Map<Id,Integer>();

        // for(AggregateResult ar: [SELECT Class__c class_Id,  Count(Id)  FemaleCount FROM Student__c WHERE Class__c IN :classIds AND Sex__c = 'Female' Group By Class__c]) {
        //      classMap.put((Id)ar.get('class_Id'), (Integer)ar.get('FemaleCount'));
        // }

        List<AggregateResult> result = Database.query(
            newQueryFactory()
                .selectField('Class__c')
                .selectField('COUNT(Id) FemaleCount')
                .setCondition('Sex__c = \'Female\'')
                .toSOQL() + 'group by class__c having class__c in :classIds');
        
                
        for(AggregateResult ar: result){
                classMap.put((Id)ar.get('class_Id'), (Integer)ar.get('FemaleCount'));
        }

        return classMap;
    }
}