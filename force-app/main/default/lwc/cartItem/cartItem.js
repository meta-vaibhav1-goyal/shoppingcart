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
                const newQty = Number(draft.Quantity__c);
                console.log(newQty);
                const item = updatedCart[index];
                console.log(JSON.stringify(item));
                const maxQty = item.Original_Stock__c;
                console.log(maxQty);
                //const available = item.Available_Units__c + item.Quantity__c; // old + returned stock

                //  Validation
                if (!Number.isFinite(newQty)) {
                    this.showToast('Invalid input', 'Quantity must be a number.', 'error');
                    return;
                }
                if (newQty <= 0) {
                    this.showToast('Invalid Quantity', 'Quantity must be greater than 0.', 'error');
                    return;
                }
                if (newQty > maxQty) {
                    this.showToast('Not Enough Stock', `Only ${maxQty} units available`, 'error');
                    return;
                }

                //  Update item quantity
                const newAvailable = maxQty - newQty;

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