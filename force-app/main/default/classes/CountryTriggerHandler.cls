public	with sharing class CountryTriggerHandler{
	public static Boolean isFirstRun = true;

  //Get newly inserted Country
  public void handleAfterInsert(List<Country__c> countries){  
	  if(isFirstRun){
	    isFirstRun = false;
	    Set<Id> countryIds = new Map<Id,Country__c>(countries).keySet();
	  	System.enqueueJob(new CountryCalloutQueueable(countryIds));
	  }
  
	
	}
}