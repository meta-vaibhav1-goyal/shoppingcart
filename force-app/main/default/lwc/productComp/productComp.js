import { LightningElement, wire, api } from 'lwc';
import getPaginatedProducts from '@salesforce/apex/productList.getPaginatedProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchProducts from '@salesforce/apex/productSearch.searchProducts';
import Toast from 'lightning/toast';
//import addToCart from '@salesforce/apex/cartData.addToCart';

 

export default class ProductComp extends LightningElement {

    products; 
    @api cartitemarr;
    
    columns = [
        // {label: 'Id', fieldName: 'Id'},
        {label: 'Name', fieldName: 'Name'},
        {label: 'Product Code', fieldName: 'Product__c'},
        {label: 'Price', fieldName: 'SellingPrice__c', type: 'currency'},
        {label: 'Units Available', fieldName: 'Available_Units__c'},
        // {
        //     type:'button',
        //     typeAttributes: {
        //         label: 'Add to Cart',
        //         name: 'add',
        //         title: 'Add',
        //         disabled: {fieldName: 'disableAdd'},
        //         variant: 'brand'
        //     }
        // }
    ];


    productList;



    totalRecords = 0;
    totalPages = 0;
    currentPage = 1;
    pageSize = 10; // Records per page

    

    // Fetch paginated data from Apex
    connectedCallback() {
        this.loadProducts();
        // this.addEventListener('productupdate', this.handleProductUpdate.bind(this));
    }

    async loadProducts() {
        try {
            const result = await getPaginatedProducts({ pageNumber: this.currentPage, pageSize: this.pageSize });
            this.productList = result;
            this.products = result.records.map(p => ({
                ...p, totalAvaliableUnits: p.Available_Units__c
            }));
            this.totalRecords = result.totalRecords;
            this.totalPages = result.totalPages;
            
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    
    }

    // Navigate to Previous Page
    previousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.loadProducts();
        }
    }

    // Navigate to Next Page
    nextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.loadProducts();
        }
    }

    // Disable navigation buttons when needed
    get disablePrevious() {
        return this.currentPage === 1;
    }

    get disableNext() {
        return this.currentPage === this.totalPages;
    }




    
    noResults = false;
    async handleSearch(event) {
        const searchTerm = event.target.value;
        if (searchTerm&&(searchTerm!=='')) {
            try {
                const result = await searchProducts({ searchKey: searchTerm })
                this.products = result.map(p => ({
                    ...p, disableAdd: p.Available_Units__c === 0
                }));
                
                this.noResults = result.length === 0;
                
            } catch (error) {
                console.error('Error searching accounts: ', error);
                this.products = undefined;
                this.noResults = true;
            }
              
        } else {
            this.loadProducts();     
        }
    }


     handleAdd() {
        const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
        const products = []; 
        console.log("addd to cart"); 
        let noQuantityName = ""; 
        let isToast = false; 
        for (let i = 0; i < selectedRows.length; i++) {
            if(selectedRows[i].Available_Units__c <= 0){
                noQuantityName = noQuantityName + selectedRows[i].Name + ', ';
                isToast = true; 
            }else{
               products.push(selectedRows[i]);      
            }
        }
        console.log(noQuantityName); 
        if(isToast){

            this.dispatchEvent(new ShowToastEvent({
                title: 'Insufficient stock',
                message: `There is not enough stock of ${noQuantityName} to add to cart`,
                variant: 'error'
            }));
        }
        //const productId = selectedRows[0].Id;
        //console.log(products);
        this.dispatchEvent(new CustomEvent('addtocart', {
            detail: {
                productIds: products,
            },
            bubbles: true,
            composed: true
        }));

        for(const product of products) {
            this.products = this.products.map(p => {
                if(p.Id === product.Id) {
                    const updated = {
                        ...p,
                        Available_Units__c: p.Available_Units__c - 1
                    }; 
                    console.log('Product updated ' + JSON.stringify(updated));
                   
                    
                    return updated;
                }
                return p;
            });
        }

        
        
        
        

    }


    @api
    updateAvailableUnits(arr) {
        const [oldCartItems, updatedCartItems] = arr;
        console.log("Old Cart items inside product component" + JSON.stringify(oldCartItems));
        console.log("New Cart items inside product component" + JSON.stringify(updatedCartItems));

        updatedCartItems.forEach(updatedItem => {
            const index = this.products.findIndex(p => p.Id === updatedItem.Id);
            if(index !== -1) {
                this.products[index].Available_Units__c = updatedItem.Available_Units__c;
            }
        });

        this.products = [...this.products];
        
    }



    // handleProductUpdate(event) {
    //     const [oldCartItems, updatedCartItems] = event.detail;
    //     console.log(oldCartItems);
    //     console.log(newCartItems);
    //     console.log('Product update event');

    //     updatedCartItems.forEach(updatedItem => {
    //         const index = this.products.findIndex(p => p.Id === updatedItem.Id);
    //         if(index !== -1) {
    //             this.products[index].Available_Units__c = updatedItem.Available_Units__c;
    //         }
    //     });

    //     this.products = [...this.products];
        
    //     //updateAvailableUnitsFromCartDiff(arr[0],arr[1]);
    // }

    handleRemoveProduct(event) {
        const products = event.detail;
        console.log('pr' + JSON.stringify(products));
       
        
        this.restoreProducts(products);
    }

    // Called when quantity in cart is edited
updateAvailableUnitsFromCartDiff(oldCart, newCart) {
    newCart.forEach(newItem => {
        const oldItem = oldCart.find(o => o.Id === newItem.Id);
        const diff = (oldItem ? oldItem.Quantity__c : 0) - newItem.Quantity__c;

        this.products = this.products.map(p => {
            if (p.Id === newItem.Id) {
                const updatedQty = p.Available_Units__c + diff;
                return {
                    ...p,
                    Available_Units__c: updatedQty,
                    
                };
            }
            return p;
        });
    });
}

// Called when a product is removed from cart
restoreProducts(removedProducts) {
    this.products = this.products.map(p => {
        const removed = removedProducts.find(r => r.Id === p.Id);
        console.log("The removed qty " + removed.Quantity__c);
        
        if (removed) {
            const restoredQty = p.Available_Units__c + removed.Quantity__c;
            return {
                ...p,
                Available_Units__c: restoredQty,
                disableAdd: restoredQty === 0
            };
        }
        return p;
    });
}


    get filteredProducts() {
        return this.products;
    }

}