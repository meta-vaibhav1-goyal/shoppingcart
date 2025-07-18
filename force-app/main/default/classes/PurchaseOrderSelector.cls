public with sharing class PurchaseOrderSelector extends fflib_SObjectSelector implements IPurchaseOrderSelector {
   public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            PurchaseOrder__c.Id,
            PurchaseOrder__c.Name,
            PurchaseOrder__c.OrderDate__c,  
            PurchaseOrder__c.Status__c, 
            PurchaseOrder__c.TotalAmount__c,
            PurchaseOrder__c.CreatedDate
        };
    }
    public Schema.SObjectType getSObjectType() {
        return PurchaseOrder__c.sObjectType;
    }
    public List<PurchaseOrder__c> selectById(Set<ID> idSet) {
        return (List<PurchaseOrder__c>) selectSObjectsById(idSet);
    }

    public List<PurchaseOrder__c> getPaginatedOrders(Integer pageNumber, Integer pageSize) {
        return (List<PurchaseOrder__c>) Database.query(
            newQueryFactory()
            .addOrdering(PurchaseOrder__c.CreatedDate, fflib_QueryFactory.SortOrder.DESCENDING)
            .setLimit(pageSize)
            .setOffSet(((pageNumber - 1) * pageSize))
            .toSOQL()
        );
    }


    public Integer getOrderCount() {
        return [SELECT COUNT() FROM PurchaseOrder__c];
    }

    public List<PurchaseOrder__c> getOrderById(Id orderId) {
        return [SELECT Name FROM PurchaseOrder__c WHERE Id = :orderId LIMIT 1]; 
        // return (PurchaseOrder__c) Database.query(
            // newQueryFactory(false)
            // .selectField(PurchaseOrder__c.Name)
            // .setCondition('Id = :orderId')
            // .toSOQL()
 
            // );
    }


}