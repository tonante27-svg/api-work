Trigger CountryTrigger on Country__c (after insert){
	CountryTriggerHandler handler = new CountryTriggerHandler();
	handler.handleAfterInsert(Trigger.new);
	
}