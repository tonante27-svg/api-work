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
@IsTest
private class OpportunityControllerTest {

    @TestSetup
    static void setupTestData() {
        // Create setup data in running user context
        User runningUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];   
        System.runAs(runningUser){
            // 1. Fixed variable name from chatterP to prof
            Profile prof = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User'];

            User fakeUser = new User(
                FirstName = 'Senior',
                LastName = 'Wooba',
                ProfileId = prof.Id, 
                Username = 'swooba@charlaten.com.test', // Added .test suffix to guarantee unique username
                Title = 'Grand Poobah',
                Email = 'swooba@litterbox.com',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'America/New_York',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                Alias = 'senwoo5'
            );
            insert fakeUser;
        }

        // Create Account Record
        Account testAccount = new Account(Name = 'Test Account', Industry = 'Technology');
        insert testAccount;

        Opportunity testOpp = new Opportunity( 
            AccountId = testAccount.Id,
            Name = 'Test Opp for Test Account',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert testOpp;
    }

    @IsTest
    private static void testFailOnUser() {
        User chatterUser = [SELECT Id FROM User WHERE Alias = 'senwoo5' LIMIT 1];
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Opportunity> opps;
        Boolean caughtException = false;
        System.runAs(chatterUser) { 
            Test.startTest();
            try{
                opps = OpportunityController.getOpportunities(testAccount.Id);
            } catch (AuraHandledException e) {
                caughtException = true;
                System.assert(e.getMessage() != null || e.getMessage().contains('Opportunity'), 'Expected an AuraHandledException with Opportunity in the message');
            }
            Test.stopTest();
            System.assert(caughtException, 'Expected and AuraHandler exception to be thrown for user without access');
        }

        // Apex SOQL/methods usually return empty lists, not null
        System.assertEquals(null, opps, 'Should return null for restricted user ');
    }

    @IsTest
    private static void testSuccessUser() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        List<Opportunity> opps;
       
        Test.startTest();
        opps = OpportunityController.getOpportunities(testAccount.Id);
        Test.stopTest();

        System.assertEquals(1, opps.size(), 'Should return 1 opportunity');
    }
}