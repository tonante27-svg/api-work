/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CountryWrapperTest {

    @isTest
    static void testWrapperParsing() {
        // 1. Manually create the JSON that looks like the API response
        String mockJson = '[{"name":{"common":"France"}, "capital":["Paris"], "region":"Europe", "maps":{"openStreetMaps":"link"}, "flags":{"png":"url"}}]';
        
        // 2. Run the code
        Test.startTest();
        List<CountryWrapper> results = CountryWrapper.parseApiResponse(mockJson);
        Test.stopTest();
        
        // 3. ASSERT: This is where you get the "Points"
        System.assertEquals(1, results.size(), 'Should have parsed one country');
        System.assertEquals('France', results[0].name.common, 'Country name should be France');
        System.assertEquals('Paris', results[0].capital[0], 'Capital should be Paris');
    }
}