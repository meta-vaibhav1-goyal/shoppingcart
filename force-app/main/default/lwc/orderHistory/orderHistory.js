import { LightningElement, track, wire } from 'lwc';
import getPrevoiusOrders from '@salesforce/apex/orderController.getPrevoiusOrders';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class OrderHistory extends LightningElement {




    previousOrders = [];
    @track cartItems = [];
    showProductTable = false;
    showCart = false;
    showSummary = false;
    orderColumns = [
        // {label: 'Id', fieldName: 'Id'},
        { label: 'Order Number', fieldName: 'Name' },
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Total Amount', fieldName: 'TotalAmount__c', type: 'currency' },
        { label: 'Order Date', fieldName: 'OrderDate__c', type: 'date' },

    ]


    connectedCallback() {
        this.loadPreviousOrders();
    }

    loadPreviousOrders() {
        getPrevoiusOrders().then(data => {
            this.previousOrders = data;
        }).catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Unable to fetch orders',
                message: error.message,
                variant: 'error',
            }));
        });
    }

    handleStartOrder() {
        this.showProductTable = true;
    }

    handleAddToCart(event) {
        console.log('Product added to the cart', JSON.stringify(event.detail));
        const product = event.detail;
        console.log(product);
        
        const existing = this.cartItems.find(p => p.Id === product.Id);
        if (existing) {
            console.log('Existing product found');
            console.log(existing.Quantity__c);
            
            if (existing.Quantity__c <= product.Available_Units__c) {
                existing.Quantity__c++;
                this.cartItems = [...this.cartItems];
                console.log("updated cart items"  + JSON.stringify(this.cartItems));
            }
        }
        else {
            this.cartItems.push({ ...product, Quantity__c: 1 });
            //this.cartItems = [...this.cartItems];
        }


        if (this.cartItems.length > 0) {

            this.showCart = true;
        }

        console.log('Cart Items ', JSON.stringify(this.cartItems));

    }




    handleUpdateCart(event) {
        const updatedCartItems = [...event.detail];
        const oldCartItems = [...this.cartItems];
        console.log(JSON.stringify("old " + JSON.stringify(oldCartItems)));
        console.log(JSON.stringify("new " + JSON.stringify(updatedCartItems)));

        // Sync back to product table via custom event
        const productTable = this.template.querySelector('c-product-comp');

        const arr = [oldCartItems, updatedCartItems];

        this.dispatchEvent(new CustomEvent('productupdate', {detail: arr}));
       

        this.cartItems = updatedCartItems;
    }

  


    handleRemoveFromCart(event) {
        const updatedCart = [...event.detail];

        // Figure out what was removed
        const removedProducts = this.cartItems.filter(
            item => !updatedCart.some(u => u.Id === item.Id)
        );

        this.dispatchEvent(new CustomEvent('removeproduct', {detail: removedProducts}));

 

        this.cartItems = updatedCart;
        this.showCart = this.cartItems.length > 0;
    }

    handlePlaceOrder() {
        this.cartItems = [];
        this.showProductTable = false;
        this.showCart = false;
        this.showSummary = false;
        this.loadPreviousOrders();
    }

    handleCheckout() {
        this.showSummary = true;
        this.recalculateCart();
    }

    recalculateCart() {
        this.cartItems = this.cartItems.map(item => {
            const total = Number(item.SellingPrice__c) * Number(item.Quantity__c);
            return {...item, TotalAmount__c: total};
        
        });
    }





  




}