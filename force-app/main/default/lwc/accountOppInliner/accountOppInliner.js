import { LightningElement,wire,api} from 'lwc';
import NAME_FIELD from '@salesforce/schema/Opportuity.Name';
import AMOUNT_FIELD from '@salesforce/schema/Opportuity.Amount';
import STAGE_FIELD from '@salesforce/schema/Opportuity.StageName';
import IQSCORE_FIELD from '@salesforce/schema/Opportuity.IqScore';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';


export default class AccountOppInliner extends LightningElement {

	@api recordId
	fieldArray = [NAME_FIELD,AMOUNT_FIELD,STAGE_FIELD,IQSCORE_FIELD]
	@wire(getOpportunities, {accountId :$recordId} )
	opportunities;
	
 }