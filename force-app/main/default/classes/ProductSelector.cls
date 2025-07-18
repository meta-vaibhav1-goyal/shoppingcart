public  class ProductSelector extends fflib_SObjectSelector implements IProductSelector  {

     public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Product2.Id,
            Product2.Name,
            Product2.Product__c, 
            Product2.Available_Units__c, 
            Product2.SellingPrice__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Product2.sObjectType;
    }

    
    public List<Product2> selectById(Set<ID> idSet) {
        return (List<Product2>) selectSObjectsById(idSet);
    }

    public List<Product2> searchProduct(String searchTerm) {
        return (List<Product2>)Database.query(
            newQueryFactory()
            .setCondition('Name LIKE :searchTerm')
            .toSOQL()
        );
    }

    public List<Product2> getPaginatedProducts(Integer pageNumber, Integer pageSize) {
        return (List<Product2> ) Database.query(
            newQueryFactory()
            .addOrdering(Product2.Name, fflib_QueryFactory.SortOrder.ASCENDING)
            .setLimit(pageSize)
            .setOffset(pageSize * (pageNumber - 1))
            .toSOQL()
        
        );
    }

    public Integer getProductCount() {
        return [SELECT COUNT() FROM Product2];
    }


    public List<Product2> getProductsByIdSet(Set<Id> idSet) {
        return selectById(idSet);
    }


   
}