import { LightningElement, api } from 'lwc';
import ContactModal from 'c/contactModal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Contact_Object from '@salesforce/schema/Contact';
import Name_Field from '@salesforce/schema/Contact.Name';
import Email_Field from '@salesforce/schema/Contact.Email';
import Phone_Field from '@salesforce/schema/Contact.Phone';
import Title_Field from '@salesforce/schema/Contact.Title';
import Account_Field from '@salesforce/schema/Contact.AccountId';




export default class ContactComp extends LightningElement {
    //contactObject = Contact_Object;
 

    async handleClick() {
        const result = await ContactModal.open({
            size: 'large',

        });

        console.log(result);
    }
    
    




   //myfields = [Name_Field,Email_Field,Phone_Field,Title_Field,Account_Field];





    // handleContactCreated(event) {
    //     this.dispatchEvent(
    //         new ShowToastEvent({
    //             title: 'Record is created successfully!',
    //             message: event.detail.message,
    //             variant: 'success',
    //         }),
    //     );
    // }


   
    
}