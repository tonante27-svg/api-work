/*
* CountryCalloutUtilty
* Class called by AccountTrigger Handler to fetch other properties pertaining to country based on Name
*/
public with sharing class CountryCalloutUtility {
    
    public static List<CountryWrapper> getCountryByName(String countryName) {
        // 1. Validation: Don't even try if the name is blank
        if (String.isBlank(countryName)) {
            return new List<CountryWrapper>();
        }

        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            
            // 2. Encoding: Handle names with spaces like "South Africa"
            String encodedName = EncodingUtil.urlEncode(countryName, 'UTF-8');
            String endpoint = System.Label.Rest_Countries_Endpoint + encodedName;
            
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setTimeout(120000); // 120 seconds is the max Apex timeout

            HttpResponse resp = http.send(req);

            // 3. Status Check: Only parse if we got a 200 OK
            if (resp.getStatusCode() == 200) {
                return CountryWrapper.parseApiResponse(resp.getBody());
            } else {
                System.debug('API Error: ' + resp.getStatusCode() + ' ' + resp.getStatus());
                return new List<CountryWrapper>(); 
            }
        } catch (System.CalloutException ex) {
            // Handle Timeouts or "Unauthorized Endpoint"
            System.debug('Callout Failed: ' + ex.getMessage());
            return new List<CountryWrapper>();
        } catch (Exception ex) {
            System.debug('General Exception: ' + ex.getMessage());
            return new List<CountryWrapper>();
        }
    }
}