/**
 * Controller for sending email messages through the Gmail API.
 * Note: 1) Make sure Principal uses all the scopes & ...
 * 2) your sender email is used in the google.cloud project not the recipeint
 * @see GmailSendController.sendEmail
 */
public with sharing class GmailSendController{
    
    /**
     * Sends an email using the configured Gmail API named credential.
     *
     * @param toAddress The recipient email address.
     * @param subject The email subject.
     * @param message The message body to send.
     * @return A success response string from the Gmail API call.
     */
    @AuraEnabled
    public static void sendEmail(String toAddress, String subject, String message){
        //Step 1: Build raw email in RFC 2822 format - Gmail expects this format
        String rawEmail = 'To: ' + toAddress + '\r\n'
                + 'Subject: ' + subject + '\r\n'
                + 'Content-Type: text/plain; charset=UTF-8\r\n'
                + '\r\n'
                + message;

        //Step 2: Base64 URL-safe encode
        String encoded = EncodingUtil.base64Encode(Blob.valueOf(rawEmail)).
        replace('+','_')
        .replace ('/','_')
        .replace('=','');

        //Step 3: HTTP POST callout 
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json');
        request.setEndpoint('callout:Gmail_API/gmail/v1/users/me/messages/send');
        Map<String, String> payload = new Map<String, String>{
                                        'raw' => encoded
                                    };
        request.setBody(JSON.serialize(payload));
        Httpresponse response = new Http().send(request);
        System.debug('HTTP STATUS: ' + response.getStatusCode());
        System.debug('RESPONSE: ' + response.getBody());
        //Step 4: Handle Errors
        if(response.getStatusCode() != 200){
            
            throw new AuraHandledException('Failed to send '+response.getBody());
            
        }
    }
}
