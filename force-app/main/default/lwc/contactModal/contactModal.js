import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningModal from 'lightning/modal';
import Contact_Object from '@salesforce/schema/Contact';
import Name_Field from '@salesforce/schema/Contact.Name';
import Email_Field from '@salesforce/schema/Contact.Email';
import Phone_Field from '@salesforce/schema/Contact.Phone';
import Title_Field from '@salesforce/schema/Contact.Title';
import Account_Field from '@salesforce/schema/Contact.AccountId';
import {RefreshEvent } from 'lightning/refresh';
export default class ContactModal extends LightningModal {
    
     contactObject = Contact_Object;
     myfields = [Name_Field,Email_Field,Phone_Field,Title_Field,Account_Field];
    
    @api
    recordId;

    modalHeading;
    
    

      handleContactCreated(event) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Record is created successfully!',
                    message: event.detail.message,
                    variant: 'success',
                }),
            );
            this.dispatchEvent(new RefreshEvent());

            this.close('Success'); 
        }

        handleError(event) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something went wrong!',
                    message: event.detail.message,
                    variant: 'error',
                }),
            );
        }

}