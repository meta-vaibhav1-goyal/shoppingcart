public with sharing class productSearch {
     @AuraEnabled(cacheable=true)
    public static List<Product2> searchProducts(String searchKey) {
        // Prevent SOQL injection by escaping special characters
        String searchTerm = '%' + String.escapeSingleQuotes(searchKey) + '%';
// Perform the SOQL query
        return [
            SELECT Id, Name, Product__c, Available_Units__c, SellingPrice__c
            FROM Product2
            WHERE Name LIKE :searchTerm
        ];
    }
}