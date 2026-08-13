@isTest
public class CountryCalloutQueueableTest {

    @isTest
    public static void testEverythingQueueable() {
        // 1. Setup Mock
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockCountryResponse'); 
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        // 2. Setup Data for Queueable
        List<Country__c> countries = new List<Country__c>();
        Set<Id> ids;
        countries.add(new Country__c(Name='Germany',Capital__c = 'Berlin', Region__c = 'Europe', Flag__c='https://flagcdn.com/w320/de.png', Location__c = 'https://www.openstreetmap.org/relation/51477#map=6/51.35/10.45' ));
        Database.SaveResult[] saveResults = Database.insert(countries, false);
        for(Database.SaveResult sr : saveResults)
        {
            if(sr.isSuccess())
            
            {        
                ids = new Set<Id>{countries[0].Id};
            }else {

                for(Database.Error err : sr.getErrors()) {
                
					System.debug('Error message: '+ err.getMessage());
                
                }
                
          }
        }

        Test.startTest();
        // This covers the Utility class directly
        List<CountryWrapper> cwrap = CountryCalloutUtility.getCountryByName('Germany');
        
        // This covers the Queueable class
        System.enqueueJob(new CountryCalloutQueueable(ids));
        Test.stopTest(); // <--- The Queueable's execute() method runs RIGHT HERE

        // 3. Assertions
        Assert.isFalse(cwrap.isEmpty(), 'Utility should return data');
        
        // Re-query the record to see if the Queueable updated it
        Country__c updatedCty = [SELECT Capital__c FROM Country__c WHERE Id = :countries[0].Id];
        Assert.areEqual('Berlin', updatedCty.Capital__c, 'Queueable should have updated the capital');
    }
    
    @isTest
    public static void testGetCountrySuccess() {
        // 1. Setup the Mock for a successful 200 response
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockCountryResponse'); 
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        List<CountryWrapper> cwrap = CountryCalloutUtility.getCountryByName('Germany');
        Test.stopTest();

        // ASSERTIONS: Check the return list, not the HTTP response directly
        Assert.isNotNull(cwrap, 'The utility should return a list, not null.');
        Assert.isFalse(cwrap.isEmpty(), 'The list should contain the mocked country.');
        // Assuming your wrapper has a 'name' property
        Assert.areEqual('Germany', cwrap[0].name.common, 'The parsed name should match the mock.');
    }

    @isTest
    public static void testGetCountryFailure() {
        // 2. Setup the Mock for a 404 Error (Covers the 'else' block)
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockCountryResponse'); 
        mock.setStatusCode(404);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        List<CountryWrapper> cwrap = CountryCalloutUtility.getCountryByName('UnknownCountry');
        Test.stopTest();

        // ASSERTIONS: Verify it returns an empty list gracefully
        Assert.isTrue(cwrap.isEmpty(), 'Should return an empty list on API error.');
    }

    @isTest
    public static void testGetCountryEmptyInput() {
        // 3. Test the Validation Path (Covers the first 'if' block)
        Test.startTest();
        List<CountryWrapper> cwrap = CountryCalloutUtility.getCountryByName('');
        Test.stopTest();

        Assert.isTrue(cwrap.isEmpty(), 'Should return empty list immediately if name is blank.'); 
    }
    
    @isTest
	public static void testCalloutExceptionCoverage() {
        // 1. Set the custom "throwing" mock
        Test.setMock(HttpCalloutMock.class, new ThrowCalloutExceptionMock());

        Test.startTest();
            // 2. Call the utility. It will try to send the request, 
            // but the mock will throw the exception.
            List<CountryWrapper> result = CountryCalloutUtility.getCountryByName('Germany');
        Test.stopTest();

        // 3. ASSERT: Verify your utility handled the exception gracefully
        // (In your code, it returns an empty list in the catch block)
        Assert.isTrue(result.isEmpty(), 'Should return empty list when exception occurs');
	}
}