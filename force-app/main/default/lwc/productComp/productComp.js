import { LightningElement, wire } from 'lwc';
import getPaginatedProducts from '@salesforce/apex/productList.getPaginatedProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchProducts from '@salesforce/apex/productSearch.searchProducts';
import Toast from 'lightning/toast';
//import addToCart from '@salesforce/apex/cartData.addToCart';

 

export default class ProductComp extends LightningElement {

    products; 
    
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
    }

    async loadProducts() {
        try {
            const result = await getPaginatedProducts({ pageNumber: this.currentPage, pageSize: this.pageSize });
            this.productList = result;
            this.products = result.records.map(p => ({
                ...p, disableAdd: p.Available_Units__c === 0
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



    // async handleClickEdit() {
    //     // this is to select rows from the UI from DataTable
    //     const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
    //     console.log(selectedRows);
    //     if(selectedRows.length != 1){
    //         this.dispatchEvent(new ShowToastEvent({
    //             title: 'Please select a row',
    //             message: 'Please select a row to edit',
    //             variant: 'error'
    //         }));
    //     }else{
    //         const contactId = selectedRows[0].Id;     
    //         console.log(contactId);
    //         const result = await ContactModal.open({
    //             size: 'large',
    //             recordId: contactId,
    //             label: 'Edit Contact Modal'
    //         });
            
    //         if(result === 'Success') {
    //            await refreshApex(this.wiredResult);
    //         }
           
    //         console.log(result);
    //     }
    
    // }

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
        console.log(products);
        this.dispatchEvent(new CustomEvent('addtocart', {
            detail: {
                // Id: productId,
                // Name: selectedRows[0].Name,
                // Available_Units__c: selectedRows[0].Available_Units__c,
                // SellingPrice__c: selectedRows[0].SellingPrice__c,
                // Original_Stock__c: selectedRows[0].Available_Units__c
                productIds: products
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
                    return updated;
                }
                return p;
            });
        }
            

    }



    // handleRowAction(event) {
    //     const action = event.detail.action.name;
    //     const row = event.detail.row;
    //     if(action === 'add') {
    //         this.dispatchEvent(new CustomEvent('addtocart', {
    //             detail: {
    //                  Id: row.Id,
    //                 Name: row.Name,
    //                 Available_Units__c: row.Available_Units__c,
    //                 SellingPrice__c: row.SellingPrice__c,
    //                 Original_Stock__c: row.Available_Units__c

    //             },
    //             bubbles: true,
    //             composed: true
    //         }));

    //         // Decrease available units in the product table
    //         this.products = this.products.map(p => {
    //             if(p.Id === row.Id) {
    //                 const updated = {
    //                     ...p,
    //                     Available_Units__c: p.Available_Units__c - 1
    //                 };
    //                 updated.disableAdd = updated.Available_Units__c === 0;
    //                 return updated;
    //             }
    //             return p;
    //         });
    //     } 
    // }


    handleProductUpdate(event) {
        const arr = event.detail;
        updateAvailableUnitsFromCartDiff(arr[0],arr[1]);
    }

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
                    disableAdd: updatedQty === 0
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