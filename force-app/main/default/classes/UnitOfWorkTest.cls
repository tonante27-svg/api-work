
/**
 * Test class using Unit of Work Apex Pattern to create 100 Accounts, 500 Contacts and 500 Notes in a single transaction.
 * Note: You must have the fflib_SObjectUnitOfWork class in your org to run this test.
 */
@IsTest
private with sharing class UnitOfWorkTest {
    @IsTest
    static void challengeComplete(){

      fflib_SObjectUnitOfWork uow =
            new fflib_SObjectUnitOfWork(
                new List<Schema.SObjectType>{
                    Account.SObjectType,
                    Contact.SObjectType,
                    Note.SObjectType
                }
            );

     Integer conatctAndNote = 0;
     for(Integer a = 0; a < 100; a++){

       Account acct = new Account(Name = 'UoW Test Account Name '+a);
       uow.registerNew(acct);

       for(Integer c = 0; c < 5; c++){
        
         Contact cont = new Contact(
                       FirstName = 'Wooba',
                       LastName = 'Tester'+conatctAndNote,
                       Email = 'woobtest'+conatctAndNote+'@gmail.com'
                       );
         uow.registerNew(cont,Contact.AccountId, acct);
         Note nota = new Note(
                       Title = 'Note For Contact '+conatctAndNote,
                       Body  = 'This is a test note for '+conatctAndNote,
                       ParentId = cont.Id
                       );
         uow.registerNew(
             nota,
             Note.ParentId,
             cont
         );
         conatctAndNote++;  
       }
     }
     // Commit the work to the database!
     uow.commitWork();  
     System.assertEquals(100, [Select Id from Account].size(),'100 Accounts Created');
     System.assertEquals(500, [Select Id from Contact].size(),'500 Contacts Created');
     System.assertEquals(500, [Select Id from Note].size(),'500 Notes Created');
    }
}