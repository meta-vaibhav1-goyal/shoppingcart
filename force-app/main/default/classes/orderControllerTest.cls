@isTest
private class orderControllerTest {

    @isTest
    static void testGetPrevoiusOrders() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IPurchaseOrderSelector mockSelector = (IPurchaseOrderSelector) mocks.mock(IPurchaseOrderSelector.class);


        // Sample Mock data

        List<PurchaseOrder__c> responseOrders = new List<PurchaseOrder__c> {
            new PurchaseOrder__c()
        };


        // Stubbing
        mocks.startStubbing();
        mocks.when(mockSelector.getPaginatedOrders(1,2)).thenReturn(responseOrders);
        mocks.when(mockSelector.getOrderCount()).thenReturn(1);
        mocks.stopStubbing();


        // start Test

        Test.startTest();
        orderController.purchaseOrderSelector = mockSelector;
        Map<String,Object> result = orderController.getPrevoiusOrders(1,2);
        Integer totalRecords = (Integer)result.get('totalRecords');
        Integer totalPages = (Integer)result.get('totalPages');
        List<PurchaseOrder__c> records = (List<PurchaseOrder__c>)result.get('records');
        Test.stopTest();


        // Assertion

        System.assertEquals(1, records.size());
        System.assertEquals(1, totalRecords);
        System.AssertEquals(1, totalPages);
    }



    @isTest
    static void testPlaceOrder() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IProductSelector mockSelector = (IProductSelector) mocks.mock(IProductSelector.class);
        IPurchaseOrderSelector mockSelectorPurchase = (IPurchaseOrderSelector) mocks.mock(IPurchaseOrderSelector.class);
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);

        // Sample Mock Data
        
        Id fakeOrderId = fflib_IdGenerator.generate(PurchaseOrder__c.SObjectType);
        Id fakeProductId = fflib_IdGenerator.generate(Product2.SObjectType);
        Id fakeOrderItemId = fflib_IdGenerator.generate(PurchaseOrderLineItem__c.SObjectType);

        List<PurchaseOrder__c> order = new List<PurchaseOrder__c>{
            new PurchaseOrder__c (
                Id = fakeOrderId
            
            )
            //Id = fakeOrderId
        };

        List<Product2> products = new List<Product2> {
            new Product2(
                Id = fakeProductId,
                Name = 'Product1',
                Available_Units__c = 100
            )
        };

        List<PurchaseOrderLineItem__c> orderLineItems = new List<PurchaseOrderLineItem__c> {
            new PurchaseOrderLineItem__c (
                Id = fakeOrderItemId,
                
                Product__c = products[0].Id,
                Quantity__c = 5
            )
        };


        Set<Id> idSet = new Set<Id>();
        idSet.add(products[0].Id);


        // Stubbing
        mocks.startStubbing();
        mocks.when(mockSelector.getProductsByIdSet(idSet)).thenReturn(products);
        mocks.when(mockSelectorPurchase.getOrderById(fakeOrderId)).thenReturn(order);
        mocks.stopStubbing();


        Test.startTest();
        orderController.productSelector = mockSelector;
        orderController.purchaseOrderSelector = mockSelectorPurchase;
        orderController.uow  = mockUow;
        String OrderName = orderController.placeOrder(order[0], orderLineItems);
        //PurchaseOrder__c o = (PurchaseOrder__c) orderController.getOrderById(fakeOrderId);
        Test.stopTest();

        // Assertions 
        System.assertEquals(95, products[0].Available_Units__c , 'Available Units should be reduced');
        // System.assertEquals(order.Name, OrderName , 'Order Name should match');

        



    }
   
}