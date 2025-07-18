public with sharing class orderController {


    @TestVisible
    static IPurchaseOrderSelector purchaseOrderSelector = new PurchaseOrderSelector();

    @TestVisible
    static IProductSelector productSelector = new ProductSelector();

    @TestVisible
    static fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new Schema.SObjectType[] {
            PurchaseOrder__c.SObjectType,
            PurchaseOrderLineItem__c.SObjectType,
            Product2.SObjectType
        }
    );


    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getPrevoiusOrders(Integer pageNumber, Integer pageSize) {
        Map<String, Object> response = new Map<String, Object>();

        // List<PurchaseOrder__c> orders = [SELECT Id, Name, OrderDate__c,  Status__c, TotalAmount__c FROM PurchaseOrder__c Order BY CreatedDate DESC
        // LIMIT :pageSize OFFSET :((pageNumber - 1) * pageSize)];

        List<PurchaseOrder__c> orders = purchaseOrderSelector.getPaginatedOrders(pageNumber, pageSize);

        // Integer totalRecords = [SELECT COUNT() FROM PurchaseOrder__c];

        Integer totalRecords = purchaseOrderSelector.getOrderCount();


        Integer totalPages = (totalRecords + pageSize - 1) / pageSize;

        response.put('records', orders);
        response.put('totalRecords', totalRecords);
        response.put('totalPages', totalPages);

        return response;
    }



    @AuraEnabled
    public static String placeOrder(PurchaseOrder__c order, List<PurchaseOrderLineItem__c> lineItems) {

       // insert order;

       uow.registerNew(order);

        for(PurchaseOrderLineItem__c item: lineItems) {
            //item.PurchaseOrder__c = order.Id;
            uow.registerNew(item, PurchaseOrderLineItem__c.PurchaseOrder__c, order);
        }
        
        //insert lineItems;

        
        // Update product quantities

        Set<Id> productIds = new Set<Id>();
        for(PurchaseOrderLineItem__c item: lineItems) {
            productIds.add(item.Product__c);
        }


        Map<Id,Product2> productMap = new Map<Id,Product2>(
            // [SELECT Id,Available_Units__c FROM Product2 WHERE Id IN: productIds]
            productSelector.getProductsByIdSet(productIds)
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

        // update productMap.values();

        uow.registerDirty(productMap.values());

        uow.commitWork();

        // PurchaseOrder__c o = [SELECT Name FROM PurchaseOrder__c WHERE Id =: order.Id];
        List<PurchaseOrder__c> o = purchaseOrderSelector.getOrderById(order.Id);
        return o[0].Name;
        
    } 
}