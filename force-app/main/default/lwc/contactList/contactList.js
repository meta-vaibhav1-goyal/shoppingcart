import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import ContactModal from 'c/contactModal';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {RefreshEvent } from 'lightning/refresh';
import { refreshApex } from '@salesforce/apex';
import Visibility from '@salesforce/schema/ContentDocumentLink.Visibility';


export default class ContactList extends LightningElement {

    contacts;
    wiredResult;

    connectedCallback(){
        console.log('version 2.0');
    }
   
    
    fields = [
        {
            label: 'Name',
            fieldName: 'ConName',
            type: 'url',
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}
        }, 
        
        { label: 'Email', fieldName: 'Email', type:'email' },
        { label: 'Phone', fieldName: 'Phone', type: 'phone' }
       ]

       @wire(getContacts)
       handleContact(respone) {
        this.wiredResult = respone;
        const data = respone.data;
        const error = respone.error;
        //let tempConList = [];


        if(error) {
            console.log("Error occurs", error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'Something went wrong contacts is not fetched properly',
                variant: 'error'
            }));
        }
        else {
            if(data && Array.isArray(data)) {
                this.contacts = data.map(row => ({
                    ...row,
                    Name: `${row.FirstName} ${row.LastName}`,
                    ConName: '/' + row.Id
                }));
                this.error = undefined;
            }
        }
     }   


       async handleClick() {
               const result = await ContactModal.open({
                   size: 'large',
                   label: 'Create Contact Modal'
       
               });
               if(result === 'Success') {
                    await refreshApex(this.wiredResult);
                }
          
               console.log(result);
        }


     async handleClickEdit() {
        // this is to select rows from the UI from DataTable
        const selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
        console.log(selectedRows);
        if(selectedRows.length != 1){
            this.dispatchEvent(new ShowToastEvent({
                title: 'Please select a row',
                message: 'Please select a row to edit',
                variant: 'error'
            }));
        }else{
            const contactId = selectedRows[0].Id;     
            console.log(contactId);
            const result = await ContactModal.open({
                size: 'large',
                recordId: contactId,
                label: 'Edit Contact Modal'
            });
            
            if(result === 'Success') {
               await refreshApex(this.wiredResult);
            }
           
            console.log(result);
        }
    
    }


}