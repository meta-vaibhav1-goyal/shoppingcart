import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CartItem extends LightningElement {
    @api cartItems = [];
    draftValues = [];

    columns = [
        { label: 'Product Name', fieldName: 'Name' },
        {
            label: 'Quantity',
            fieldName: 'Quantity__c',
            type: 'number',
            editable: true
        },
        { label: 'Price', fieldName: 'SellingPrice__c', type: 'currency' },
        {
            type: 'button-icon',
            typeAttributes: {
                iconName: 'utility:delete',
                name: 'delete',
                title: 'Remove',
                alternativeText: 'Remove'
            }
        }
    ];

    handleSave(event) {
        const drafts = event.detail.draftValues;

        console.log('Drafts', JSON.stringify(drafts));
        console.log('Cart before update', JSON.stringify(this.cartItems));
        
        

        let updatedCart = [...this.cartItems];
        

        for (let draft of drafts) {
            const index = updatedCart.findIndex(item => item.Id === draft.Id);
            if (index !== -1) {

                const maxAvaliableQty = updatedCart[index].totalAvaliableUnits; 
                
                // cases
                    const newQty = Number(draft.Quantity__c);
                    const item = updatedCart[index];
                    const maxQty = item.totalAvaliableUnits;

                    if (!Number.isFinite(newQty)) {
                        this.showToast('Invalid input', 'Quantity must be a number.', 'error');
                        return;
                    }

                    if (newQty <= 0) {
                        this.showToast('Invalid Quantity', 'Quantity must be greater than 0.', 'error');
                        return;
                    }

                    if (newQty > maxQty) {
                        this.showToast('Not Enough Stock', `Product units not  available`, 'error');
                        return;
                    }

                    const newAvailable =  maxQty - newQty;

                    updatedCart[index] = {
                        ...item,
                        Quantity__c: newQty,
                        Available_Units__c: newAvailable
                    };
            }
        }

        console.log("new values " + JSON.stringify(updatedCart));

        this.cartItems = [...updatedCart];

        this.dispatchEvent(new CustomEvent('updatecart', { detail: this.cartItems }));

        this.draftValues = [];
    }

    handleRowAction(event) {
        const row = event.detail.row;
        this.cartItems = this.cartItems.filter(item => item.Id !== row.Id);

        this.cartItems = [...this.cartItems];
        console.log("Deleting cart " + JSON.stringify(this.cartItems));
        

        this.dispatchEvent(new CustomEvent('remove', { detail: this.cartItems }));
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant
        }));
    }
}