public with sharing class productList {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getPaginatedProducts(Integer pageNumber, Integer pageSize){ 

        Map<String, Object> response = new Map<String, Object>();

        List<Product2> products =  [SELECT  Id,Name, Product__c, SellingPrice__c,	Available_Units__c FROM Product2 
        ORDER BY Name LIMIT :pageSize OFFSET :((pageNumber - 1) * pageSize)];    
        
        
         // Get total record count (for pagination)
        Integer totalRecords = [SELECT COUNT() FROM Product2];

        // Calculate total pages
        Integer totalPages = (totalRecords + pageSize - 1) / pageSize;


        // Add data to response map
        response.put('records', products);
        response.put('totalRecords', totalRecords);
        response.put('totalPages', totalPages);
        
        return response;
    }
}