import { LightningElement, track, wire } from 'lwc';
import getPrevoiusOrders from '@salesforce/apex/orderController.getPrevoiusOrders';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class OrderHistory extends LightningElement {




    previousOrders = [];
    @track cartItems = [];
    showProductTable = false;
    showCart = false;
    showSummary = false;
    wiredResult;
    arr = [];
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

   

    totalRecords = 0;
    totalPages = 0;
    currentPage = 1;
    pageSize = 5; // Records per page

    showProductSection = false;
    showPurchaseOrderSection = true;
    showCartSection = false;
    showInvoiceSection = false;


    async loadPreviousOrders() {

        try {
            const result = await getPrevoiusOrders({ pageNumber: this.currentPage, pageSize: this.pageSize });
            this.wiredResult = result;
            this.previousOrders = result.records;
            this.totalRecords = result.totalRecords;
            this.totalPages = result.totalPages;
            
        } catch (error) {
              this.dispatchEvent(new ShowToastEvent({
                title: 'Unable to fetch orders',
                message: error.message,
                variant: 'error',
            }));
        }finally{
            refreshApex(this.wiredResult);
        }
       
    }

     previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.loadPreviousOrders();
        }
    }

     // Navigate to Next Page
    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.loadPreviousOrders();
        }
    }

    // Disable navigation buttons when needed
    get disablePrevious() {
        return this.currentPage === 1;
    }

    get disableNext() {
        return this.currentPage === this.totalPages;
    }



    handleStartOrder() {
        this.showProductTable = true;
        this.showProductSection = true;
        this.showPurchaseOrderSection = false;
    }

    handleAddToCart(event) {
        const productList = event.detail.productIds;
        
        for(const product of productList) {
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
            }
        }   
        
        this.cartItems = [...this.cartItems];


        if (this.cartItems.length > 0) {

            this.showCart = true;
            this.showCartSection = true;
        }

        console.log('Cart Items ', JSON.stringify(this.cartItems));

    }




    handleUpdateCart(event) {
        const updatedCartItems = [...event.detail];
        const oldCartItems = [...this.cartItems];
        console.log(JSON.stringify("old " + JSON.stringify(oldCartItems)));
        console.log(JSON.stringify("new " + JSON.stringify(updatedCartItems)));
        
        //arr = [oldCartItems, updatedCartItems];

        // Sync back to product table via custom event
        const productTable = this.template.querySelector('c-product-comp');
        
        if(productTable) {
            // productTable.dispatchEvent(new CustomEvent('productupdate', {detail: arr}));
            const arr = [oldCartItems, updatedCartItems];
            productTable.updateAvailableUnits(arr);
        }
        

        //this.dispatchEvent(new CustomEvent('productupdate', {detail: arr}));
       

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
        this.showInvoiceSection = false;
        this.showPurchaseOrderSection = true;
        this.loadPreviousOrders(); 
    }

    handleCheckout() {
        this.showSummary = true;
        this.recalculateCart();
        this.showProductSection = false;
        this.showCartSection = false;
        this.showInvoiceSection = true;
    }

    recalculateCart() {
        this.cartItems = this.cartItems.map(item => {
            const total = Number(item.SellingPrice__c) * Number(item.Quantity__c);
            return {...item, TotalAmount__c: total};
        
        });
    }





  




}