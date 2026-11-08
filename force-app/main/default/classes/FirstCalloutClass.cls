public with sharing class FirstCalloutClass {
    public class DataWraper{
        public String name;
        public String industry;
        public Integer numberOfEmployees;
    }

    public static void makeCallout() {
        //create the HTTP hwy. W/O Named crednetials.
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:PostmanNC/Basic-auth');
        // EncodingUtil.urlEncode(cityName, 'UTF-8')+'&appid='+apiKey+'&units=imperial') ;);
        request.setMethod('GET');
        // String credentials = EncodingUtil.base64Encode(Blob.valueOf('postman:password'));
        // request.setHeader('Authorization', 'Basic ' + credentials);
        //Send request along the hwy
        HttpResponse response = http.send(request);
        system.debug('Status-code: ' + response.getStatusCode());
        system.debug('Response: ' + response.getBody());
    }
    public static void sendData(){
        Integer maxRetries = 3;
        Integer attempt = 0;
        //create the HTTP hwy. W/O Named credentials.
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:PostmanNC/Post');
        request.setMethod('POST');
        // String body = '{"name": "Tech Corp", "industry": "Technology"}';
       
        request.setHeader('Content-Type', 'application/JSON');
        // Map<String,Object> payload = new Map<String,Object>();
        // payload.put('name', 'Lean Machine Tech');
        // payload.put('industry', 'Technology');
        // payload.put('numberOfEmployees', 500);
        // Convert the payload to a JSON string
        // String body = JSON.serialize(payload);
        DataWraper dataWrapper = new DataWraper();
        dataWrapper.name = 'Uma\'s Styles';
        dataWrapper.industry = 'Apparel';
        dataWrapper.numberOfEmployees = 25;
        String body = JSON.serialize(dataWrapper);
        request.setBody(body);
        //Send request along the hwy
        while (attempt < maxRetries) {
            try{
                HttpResponse response = http.send(request);

                system.debug('Status-code: ' + response.getStatusCode());
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    system.debug('Successfuly Response: ' + response.getBody());
                    Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
                    return;
                } else if(response.getStatusCode() == 400){
                    system.debug('Bad Request: ' + response.getStatusCode() + ' - ' + response.getStatus());
                    return;
                } else if(response.getStatusCode() == 401){
                    system.debug('Unauthorized: ' + response.getStatusCode() + ' - ' + response.getStatus());
                    return;
                } else if(response.getStatusCode() == 404){
                    system.debug('Not Found: ' + response.getStatusCode() + ' - ' + response.getStatus());
                } else if(response.getStatusCode() == 429){
                    system.debug('Conflict - Too many Callouts: ' + response.getStatusCode() + ' - ' + response.getStatus());
                } else if(response.getStatusCode() == 500){
                    system.debug('Internal Server Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
                }else if(response.getStatusCode() == 503){
                    system.debug('Service Unavailable: ' + response.getStatusCode() + ' - ' + response.getStatus());
                }else{
                    system.debug('Unexpected Status Code Error: ' + response.getStatusCode() + ' - ' + response.getStatus());
                }
                attempt++;
                continue;
            } catch (Exception e) {
                system.debug('Error occurred during callout: ' + e.getMessage());
                attempt++;  
                if (attempt >= maxRetries) {
                    system.debug('Max retries reached. Aborting callout.');
                    throw e;
                }
            }
        }//WHILE
    }
}