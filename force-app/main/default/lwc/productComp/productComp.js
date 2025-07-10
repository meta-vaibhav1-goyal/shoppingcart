import { LightningElement, wire, api, track } from 'lwc';
import getPaginatedProducts from '@salesforce/apex/productList.getPaginatedProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchProducts from '@salesforce/apex/productSearch.searchProducts';
import Toast from 'lightning/toast';
//import addToCart from '@salesforce/apex/cartData.addToCart';

 

export default class ProductComp extends LightningElement {

    products = [];
    @api cartitemarr;
    
    columns = [
        // {label: 'Id', fieldName: 'Id'},
        {label: 'Name', fieldName: 'Name', sortable: true},
        {label: 'Product Code', fieldName: 'Product__c'},
        {label: 'Price', fieldName: 'SellingPrice__c', type: 'currency', sortable: true},
        {label: 'Units Available', fieldName: 'Available_Units__c', sortable: true},
       
    ];


    productList;

    @track sortBy;
    @track sortDirection;


    totalRecords = 0;
    totalPages = 0;
    currentPage = 1;
    pageSize = 10; // Records per page

    

    // Fetch paginated data from Apex
    connectedCallback() {
        this.loadProducts();
        // this.addEventListener('productupdate', this.handleProductUpdate.bind(this));
    }



    handleSort(event) {
        const {fieldName: sortedBy, sortDirection} = event.detail;
        const cloneData = [...this.products];
        cloneData.sort((a,b) => {
            let valA = a[sortedBy] || "";
            let valB = b[sortedBy] || "";
            return sortDirection === 'asc' ? valA > valB ? 1 : -1 : valA < valB ? 1 : -1;
        });

        this.sortBy = sortedBy;
        this.sortDirection = sortDirection;
        this.products = [...cloneData]; 
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

        if(selectedRows.length != 1){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Please select a row',
                message: 'Please select a row to add to cart',
                variant: 'error'
            }));
        }

        const products = []; 
        console.log("addd to cart"); 
        let noQuantityName = ""; 
        let isToast = false; 
        for (let i = 0; i < selectedRows.length; i++) {
            if(selectedRows[i].Available_Units__c <= 0 || !Number.isFinite(selectedRows[i].Available_Units__c)){
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




    // @api 
    // handleRemoveProduct(removeProductsFromCart) {
        
    //     //console.log("removedProductsFromCart" + JSON.stringify(removeProductsFromCart));
    //     const removedProducts = removeProductsFromCart;
    //     console.log('pr' + JSON.stringify(removedProducts));

    //     if(!Array.isArray(this.products)) {
    //         console.error(" this.products is not initialized properly", this.products);
    //         this.products = [];
    //         return ;
    //     }
       
        
    //     this.products = this.products.map(p => {

    //         if(!p || !p.Id) {
    //             console.warn(" Skipping invalid product entry ", p);
    //             return p;
    //         }

    //         const removed = removedProducts.find(r => r.Id === p.Id);
    //         console.log("The removed qty " + removed.Quantity__c);
            
    //         if (removed) {
    //             const removedQty = Number(removed.Quantity__c || 0);
    //             console.log("The removed qty " + removedQty);
    //             const availableQty = Number(p.Available_Units__c || 0);
    //             const restoredQty = availableQty + removedQty;
    //             console.log("The restored qty " + restoredQty);
    //             return {
    //                 ...p,
    //                 Available_Units__c: restoredQty
    //             };
    //         }
    //         return p;
    //     });

    //     //this.products = [...this.products];

    //     console.log("Updated Products list ", JSON.stringify(this.products));

    // }


    @api
    handleRemoveProduct(removedProductsFromCart) {
        console.log(' Received removedProductsFromCart:', removedProductsFromCart);

        // Safe extract
        const removedProducts = Array.isArray(removedProductsFromCart) ? removedProductsFromCart : [];
        console.log('removedProducts:', JSON.stringify(removedProducts));

        //  Check this.products before .map()
        if (!Array.isArray(this.products)) {
            console.error(' this.products is not an array:', this.products);
            return;
        }

        console.log(' Existing products:', JSON.stringify(this.products));

        try {
            this.products = this.products.map(p => {
                if (!p || typeof p !== 'object') {
                    console.warn(' Skipping invalid product:', p);
                    return p;
                }

                if (!p.Id) {
                    console.warn(' Product has no Id:', p);
                    return p;
                }

                const removed = removedProducts.find(r => r.Id === p.Id);
                if (removed) {
                    const removedQty = Number(removed.Quantity__c || 0);
                    const availableQty = Number(p.Available_Units__c || 0);

                    if (isNaN(removedQty) || isNaN(availableQty)) {
                        console.error(` Invalid quantity values: removedQty=${removedQty}, availableQty=${availableQty}`);
                        return p;
                    }

                    const restoredQty = availableQty + removedQty;
                    console.log(`Restoring qty: ${removedQty} → product Id ${p.Id}, new total: ${restoredQty}`);

                    return {
                        ...p,
                        Available_Units__c: restoredQty
                    };
                }

                return p;
            });

            console.log('Final updated products:', JSON.stringify(this.products));
        } catch (err) {
            console.error(' Error during products.map:', err);
        }
    }

 



    get filteredProducts() {
        return this.products;
    }

}