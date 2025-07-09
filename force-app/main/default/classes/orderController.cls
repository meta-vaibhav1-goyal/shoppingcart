public with sharing class orderController {



    // @AuraEnabled(cacheable=true)
    // public static Map<String, Object> getPaginatedProducts(Integer pageNumber, Integer pageSize){ 

    //     Map<String, Object> response = new Map<String, Object>();

    //     List<Product2> products =  [SELECT  Id,Name, Product__c, SellingPrice__c,	Available_Units__c FROM Product2 
    //     ORDER BY Name LIMIT :pageSize OFFSET :((pageNumber - 1) * pageSize)];    
        
        
    //      // Get total record count (for pagination)
    //     Integer totalRecords = [SELECT COUNT() FROM Product2];

    //     // Calculate total pages
    //     Integer totalPages = (totalRecords + pageSize - 1) / pageSize;


    //     // Add data to response map
    //     response.put('records', products);
    //     response.put('totalRecords', totalRecords);
    //     response.put('totalPages', totalPages);
        
    //     return response;
    // }
    
    // @AuraEnabled
    // public static List<PurchaseOrder__c> getPrevoiusOrders() {
    //     System.debug('--- PurchaseOrder__c --- ' + PurchaseOrder__c.sObjectType); 
    //     return [SELECT Id, Name, OrderDate__c,  Status__c, TotalAmount__c FROM PurchaseOrder__c Order BY CreatedDate DESC] ;
    // }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getPrevoiusOrders(Integer pageNumber, Integer pageSize) {
        Map<String, Object> response = new Map<String, Object>();
        List<PurchaseOrder__c> orders = [SELECT Id, Name, OrderDate__c,  Status__c, TotalAmount__c FROM PurchaseOrder__c Order BY CreatedDate DESC
        LIMIT :pageSize OFFSET :((pageNumber - 1) * pageSize)];

        Integer totalRecords = [SELECT COUNT() FROM PurchaseOrder__c];

        Integer totalPages = (totalRecords + pageSize - 1) / pageSize;

        response.put('records', orders);
        response.put('totalRecords', totalRecords);
        response.put('totalPages', totalPages);

        return response;
    }



    @AuraEnabled
    public static void placeOrder(PurchaseOrder__c order, List<PurchaseOrderLineItem__c> lineItems) {
        insert order;
        for(PurchaseOrderLineItem__c item: lineItems) {
            item.PurchaseOrder__c = order.Id;
        }

        insert lineItems;

        
        // Update product quantities

        Set<Id> productIds = new Set<Id>();
        for(PurchaseOrderLineItem__c item: lineItems) {
            productIds.add(item.Product__c);
        }


        Map<Id,Product2> productMap = new Map<Id,Product2>(
            [SELECT Id,Available_Units__c FROM Product2 WHERE Id IN: productIds]
        );

        for(PurchaseOrderLineItem__c line: lineItems) {
            Product2 p = productMap.get(line.Product__c);
            if(p.Available_Units__c < line.Quantity__c ) {
                throw new AuraHandledException('Not enough stock for product ' + p.Name);
            }
            
            if(p != null) {
                p.Available_Units__c -= line.Quantity__c;
            }
        }

        update productMap.values();
    } 
}