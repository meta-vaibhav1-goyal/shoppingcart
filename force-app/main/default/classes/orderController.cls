public with sharing class orderController {
    
    @AuraEnabled
    public static List<PurchaseOrder__c> getPrevoiusOrders() {
        System.debug('--- PurchaseOrder__c --- ' + PurchaseOrder__c.sObjectType); 
        return [SELECT Id, Name, OrderDate__c,  Status__c, TotalAmount__c FROM PurchaseOrder__c Order BY CreatedDate DESC] ;
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