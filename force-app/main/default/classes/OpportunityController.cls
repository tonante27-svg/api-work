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
            if (!Schema.sObjectType.Opportunity.isAccessible()) {
                throw new System.NoAccessException();
            }else{
                opportunities = [SELECT Id, Name, StageName, IqScore, Amount FROM Opportunity WHERE AccountId = :accountId WITH SECURITY_ENFORCED];
            }
        }catch(System.NoAccessException e){
            throw new AuraHandledException('You do not have access to view opportunities.');
        }catch(Exception e){
            throw new AuraHandledException('An error occurred while retrieving opportunities: ' + e.getMessage());
        }
        return opportunities;
    }
}