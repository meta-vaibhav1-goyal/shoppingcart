@IsTest

private class productSearchTest {

    @IsTest

    static void testSearchProductWithMock() {
        // Creating a mock

        fflib_ApexMocks mocks = new fflib_ApexMocks();
        IProductSelector mockSelector = (IProductSelector) mocks.mock(IProductSelector.class);
        
        // Sample mock data 

        List<Product2> responseProducts = new List<Product2> {
            new Product2(Name = 'Product 1')
            // new Product2(Name = 'Product 2')
            
        };


        // Stubbing

        mocks.startStubbing();
        // Selector Ka searchProduct() method call kr rhe h apn yaah pr jo ki apn ne ProductSelector class mein
        // apn nee implement kiya h 
        mocks.when(mockSelector.searchProduct('%Product%'))
        .thenReturn(responseProducts);
        mocks.stopStubbing();



        // Start Test

        Test.startTest();

        //  yaah pe apn productSearch ke selector ko mock selector se replace kr rhe h
        productSearch.productSelector = mockSelector;

        // aur yaah pe apn class ka method call kr rhe h productSearch ka searchProducts() method call kr rahna h
        List<Product2> result = productSearch.searchProducts('Product');
        Test.stopTest();


        // Assertion

        System.assertEquals(1, result.size());
        System.assertEquals('Product 1', result[0].Name);


    }



   
}