import { LightningElement } from 'lwc';

export default class MyComp extends LightningElement {
    // name = 'John';
    // company = 'Salesforce';
    // designation = 'Manager';
    // salary = '$100000';

    greeting = "World";

    handleChange(event) {
        this.greeting = event.target.value;
    }
}
