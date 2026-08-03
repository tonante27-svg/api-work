/**
 * Controller for managing opportunities.
 */
public with sharing class OpportunityController {
   
    /**
     * Retrieves opportunities for the specified account.
     *
     * @param accountId The Id of the account to retrieve opportunities for.
     * @return A list of opportunities associated with the specified account.
     */
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities(Id accountId) {
         List<Opportunity> opportunities = new List<Opportunity>();
        try{
           
            opportunities = [SELECT Id, Name, StageName,Amount FROM Opportunity WHERE AccountId = :accountId WITH USER_MODE];
        }catch(Exception e){
            AuraHandledException ex = new AuraHandledException('You do not have access to view opportunities.');
            System.debug('Error: ' + e.getMessage());
            ex.setMessage('An unexpected error occurred while retrieving opportunities: ' + e.getMessage());
            throw ex;
        }
        return opportunities;
    }
}