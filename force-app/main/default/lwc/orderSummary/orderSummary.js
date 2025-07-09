import { LightningElement, api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import placeOrder from '@salesforce/apex/orderController.placeOrder';


export default class OrderSummary extends LightningElement {

    @api cartItems = [];
    columns = [ 
        {label: 'Name', fieldName: 'Name'},
        // {label: 'Product Code', fieldName: 'Product__c'},
        {label: 'Price', fieldName: 'SellingPrice__c', type: 'currency'},
        {
            label: 'Units',
            fieldName: 'Quantity__c',
            type: 'number',
            
        },
        {label: 'Total', fieldName: 'TotalAmount__c', type: 'currency'}
    ];

    handlePlaceOrder() {

        console.log('Placed order starting');

        const order = { OrderDate__c: new Date(), Status__c: 'Placed', TotalAmount__c: this.total};
        
        const lineItems = this.cartItems.map(item => ({
            Product__c: item.Id,
            Quantity__c: item.Quantity__c,
            SellingPrice__c: item.SellingPrice__c

        }));

        placeOrder({order, lineItems})
        .then(() => {
            this.dispatchEvent(new CustomEvent('placeorder'));
            this.dispatchEvent(new ShowToastEvent({
                title: 'Order Placed',
                message: 'Your order has been placed successfully',
                variant: 'success',
            }));
        })
        .catch(error => {
            console.log('Order placement failed', error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body ? error.body.message: error.message,
                variant: 'error',
            }));
        });

        console.log('Placed order ending');
    }

   

    get total() {
        return this.cartItems.reduce((sum,item) => sum + item.SellingPrice__c * item.Quantity__c, 0);
    }   
    

}