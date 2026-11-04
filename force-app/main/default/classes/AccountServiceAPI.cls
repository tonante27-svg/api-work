@RestResource(urlMapping='/AccountServiceAPI/*')
/** REST API for retrieving account summaries and creating accounts from Postman client. */
global with sharing class AccountServiceAPI {
    /**
     * Response wrapper containing an account's summary and request status.
     */
    global class AccountSummaryResponseWrapper{
       public String name;
       public integer contactCount;
       public String errorMessage;
       public Boolean isSuccess;
    }
/** Response wrapper containing the result of an account creation request both for erros and succeses. */
global class CreateAccountResponseWrapper{
       public String accountId;
       public String message;
    }
    global class UpdateAccountResponseWrapper{
       public String accountId;
       public String message;
    }

    @HttpGet
        global static AccountSummaryResponseWrapper getAccountSummary(){
             AccountSummaryResponseWrapper response = new AccountSummaryResponseWrapper();
            try{
                RestRequest req = RestContext.request;
                String acctId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
                Account acc= [select name,( select id from contacts ) from Account where id=:acctId limit 1];
                response.name = acc.name;
                response.contactCount = acc.Contacts.size();
                response.isSuccess = true;
                }catch(queryException e){
                    response.errorMessage = 'No Accountofund with this id, please check again: ' + e.getMessage();
                    response.isSuccess = false; 
                    RestContext.response.statusCode = 400;
                }catch(exception e){
                    response.errorMessage = 'Error while processing the request. please contact with admin: ' + e.getMessage();
                    response.isSuccess = false; 
                    RestContext.response.statusCode = 500;
                }
              return response;
        }
    @HttpPost
        global static CreateAccountResponseWrapper createAccount(){
             CreateAccountResponseWrapper response = new CreateAccountResponseWrapper();
             RestRequest req = RestContext.request;
            try{
                String body = req.requestBody.toString();
                Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(body);
                String name = (String) params.get('name');
                String industry = (String) params.get('industry');     
                if(string.isBlank(name) || string.isBlank(industry)){
                    response.message = 'Name and Industry are both required fields.';
                    RestContext.response.statusCode = 400;
                    return response;
                }
                Account acc = new Account(Name = name, Industry = industry);
                if (!Schema.sObjectType.Account.isCreateable()) {
                    response.message = 'You do not have permission to create accounts.';
                    RestContext.response.statusCode = 403;
                    return response;
                }
                insert acc;
                response.accountId = acc.id;
                response.message = 'Account created successfully.';
                }catch(exception e){
                    response.message = 'Error while processing the request. please contact your admin: ' + e.getMessage();
                    RestContext.response.statusCode = 500;
                }
              return response;
        }

        @HttpPatch /* 001ak0000480YKnAAM */
        global static UpdateAccountResponseWrapper updateAccountSummary(){
             UpdateAccountResponseWrapper response = new UpdateAccountResponseWrapper();
             RestRequest req = RestContext.request;
             String attributres = 'Select ';
             Account updateAccount =  new Account();
             try{
                //get endpoint
                String acctId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
                String body = req.requestBody.toString();
                Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(body);
                String name = (String) params.get('name');
                String industry = (String) params.get('industry'); 
                Account acc= new Account(Id = acctId);
                if (params.containsKey('name')) {
                    acc.Name = (string)params.get('name');
                }
                if(params.containsKey('industry')) {
                    acc.Industry = (string)params.get('industry');
                }
                if (!Schema.sObjectType.Account.isUpdateable()) {
                    response.message = 'You do not have permission to update accounts.';
                    response.accountId = null;
                    RestContext.response.statusCode = 403;
                    return response;
                }
                update acc;
                response.message = 'Name and Industry were both successfully updated.';
                response.accountId = acctId;
                RestContext.response.statusCode = 204;
                return response;
            }catch(Exception e){
                response.message = 'No Account found with this id, please check again: ' + e.getMessage();
                response.accountId = null;
                RestContext.response.statusCode = 500;
            } 
             return response;
        }

        @HttpDelete /* 001ak0000480YKnAAM */
        global static void deleteAccountSummary(){
             RestRequest req = RestContext.request;  
             try{
                //get endpoint
                String acctId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
                if(String.isBlank(acctId)){
                	RestContext.response.statusCode = 403;
                	return;
                }
                if (!Schema.sObjectType.Account.isDeletable()) {
                    system.debug('You do not have permission to delete accounts.');
                    RestContext.response.statusCode = 403;
                    return;
                }
                Account deleteAccount = new Account(Id=acctId);
                delete deleteAccount;
                 system.debug('Account '+acctId+' was deleted successfully');
             }catch(Exception e){
                RestContext.response.statusCode = 500;
             }
        }
}