import { LightningElement,wire,api} from 'lwc';
import NAME_FIELD from '@salesforce/schema/Opportunity.Name';
import AMOUNT_FIELD from '@salesforce/schema/Opportunity.Amount';
import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';


export default class AccountOppInliner extends LightningElement {

	@api recordId;
	fieldsArray = [NAME_FIELD,AMOUNT_FIELD,STAGE_FIELD]
	@wire(getOpportunities, {accountId :'$recordId'} )
	opportunities;
	
 }