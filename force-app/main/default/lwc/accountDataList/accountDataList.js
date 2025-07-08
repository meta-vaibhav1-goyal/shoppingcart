import { LightningElement, wire} from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import AnnualRevenue from '@salesforce/schema/Account.AnnualRevenue';




export default class AccountData extends LightningElement {

    accounts;
     columns = [
        {label: 'Id', fieldName: 'Id'},
        { label: 'Name', fieldName: 'Name' },
        // { label: 'Annual Revenue', fieldName: 'AnnualRevenue', type: 'currency' },
        {label: 'Phone', fieldName: 'Phone' , type: 'phone'},
        
        // {label: 'NumberOfEmployees', fieldName: 'NumberOfEmployees', type: 'number'}
    ];

    @wire(getAccounts)
    handleAccountList(response) {
        const data = response.data;
        const error = response.error;

        if(error) {
            console.log("Error occurs", error);
        } else {
            this.accounts = data;
        }
    } 



    


}




