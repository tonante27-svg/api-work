/*
* CountryCalloutQueueable
* Class called by AccountTrigger Handler to fetch other properties pertaining to country based on Name
*/
public class CountryCalloutQueueable implements Queueable, Database.AllowsCallouts {
    private Set<Id> countryIds;

    public CountryCalloutQueueable(Set<Id> ids) {
        this.countryIds = ids;
    }

    public void execute(QueueableContext context) {
        List<Country__c> countriesToUpdate = new List<Country__c>();
        
        // 1. Fetch the freshest data
        List<Country__c> scope = [SELECT Id, Name,Capital__c  FROM Country__c WHERE Id IN :countryIds];
         
        for (Country__c c : scope) {
            // 2. Use your Utility class
            List<CountryWrapper> results = CountryCalloutUtility.getCountryByName(c.Name);
            
            if (!results.isEmpty()) {
                CountryWrapper data = results[0];
                c.Capital__c = data.capital != null ? data.capital[0] : 'N/A';
                c.Region__c = data.region;
                // Using the Wrapper structure we discussed
                c.Location__c = data.maps.openStreetMaps; 
                if(data.flags != null && data.flags.png != null){
                	c.Flag__c = data.flags.png;
                }
                countriesToUpdate.add(c);
            }
        }
        
        // 3. Final DML update
        if (!countriesToUpdate.isEmpty()) {
            update countriesToUpdate;
        }
    }
}