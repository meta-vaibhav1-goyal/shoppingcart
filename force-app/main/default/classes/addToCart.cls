public with sharing class addToCart {
    @AuraEnabled
    public static void addCart(Set<Id> productIds) {
        System.debug('--- Product ID --- ' + productIds); 

        

        

}