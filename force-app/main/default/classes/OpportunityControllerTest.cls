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
private class OpportunityControllerTest {

    @TestSetup
    static void setupTestData() {
        Profile prof = [SELECT Id from Profile  WHERE Name = 'Chatter User'];
User fakeUser = new User(
        FirstName='Senior',
        Lastname= 'Wooba',
        ProfileId=chatterP.Id,
        Username='swooba@charlaten.com',
        Title = 'Grand Poobah',
        Email='swooba@litterbox.com',
        LocaleSidKey = 'en_US',
        TimeZoneSidKey='America/New_York',
        EmailEncodingKey='UTF-8',
        LanguageLocaleKey='en_US',
        Alias='senwoo5');
        insert fakeUser;

        // Creat eand Acocunt Record
        Account testAccount = new Account(Name='Test Account', Industry='Technology');
        insert testAccount;

        Opportunity testOpp = new Opportunity( 
        			AccountId = testAccount.Id,
        			Name = 'Test Opp for Test Account'
        			);
        insert testOpp;
    }

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        List<Opportunity> opps  = new List<Opportunity>();
        User u = [SELECT Id FROM User WHERE Alias='senwoo5' LIMIT 1];
        Account testAccount = [SELECT Id FROM Account WHERE Name='Test Account' LIMIT 1];
         System.runAs(u) {
            Test.startTest();
            // Perform test logic or call methods here
            oppsOpportunityController.getOpportunities(testAccount.Id);
            Test.stopTest();
        }
    }
}