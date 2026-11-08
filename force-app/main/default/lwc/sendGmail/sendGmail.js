import { LightningElement,wire,track,api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import CONTACT_EMAIL from '@salesforce/schema/Contact.Email';
import { getRecord,getFieldValue } from 'lightning/uiRecordApi';
import sendEmail from '@salesforce/apex/GmailSendController.sendEmail';
import Toast from 'lightning/toast';
export default class SendGmail extends LightningElement {

    toAddress='';
    subject='';
    message='';
    error='';
    isSending = false;
    @api recordId;
    succes = false;

    @wire(getRecord, { recordId: '$recordId', fields: [CONTACT_EMAIL] })
    wiredContact({ data, error }) {
        if (data) {
            this.toAddress = getFieldValue(data, CONTACT_EMAIL) || '';
            console.log('TO ADDRESS '+this.toAddress);
        } else if (error) {
            this.error = 'Failed to load contact email.';
        }
    }
    
    handleChange(event) {
        const field = event.target.dataset.field;
        //this[field] = event.target.value;
        // Map HTML data-field attributes to your JS properties safely
        if (field === 'toAddress') {
            this.toAddress = event.target.value;
        } else if (field === 'message') {
            this.message = event.target.value;
        } else if (field === 'subject') {
            this.subject = event.target.value;
        }
    }
    
    handleCancel() {
        // Close modal without saving
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    async handleSendEmail() {
        console.log('IN HANDLE SEND EMAIL');
        console.log(this.toAddress);
        console.log(this.subject);
        console.log(this.message);
        if (!this.toAddress || !this.subject || !this.message) {
            this.error = 'Please fill in all the fields';
            this.notificationToast('Email Not Sent', 'Please enter values for To, Subject, and Message.', 'error');
            return;
        }

        console.log('Sending email...');
        this.isSending = true;
        this.error = '';
        this.success = false;

        try {
            // Await the Apex call cleanly inside an async function
            await sendEmail({ 
                toAddress: this.toAddress, 
                subject: this.subject, 
                message: this.message 
            });

            this.success = true;
            this.notificationToast('Email Sent', 'Your email has been sent successfully.', 'success');
            
            // Automatically close the quick action modal on success
            this.dispatchEvent(new CloseActionScreenEvent());
        } catch (error) {
            console.error('Error sending email:', error);
            this.error = error.body?.message || 'Unknown error occurred';
            this.notificationToast('Error Sending Email', this.error, 'error');
        } finally {
            this.isSending = false; // Always reset loading state
        }
    }
    notificationToast(title, message, variant){
        Toast.show({
            label: title,
            message: message,
            variant: variant,
            mode:'dismissible'
        });
    }
}