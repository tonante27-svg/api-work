/**
 * GetAddressCoordinates
 *
 * Provides a server-side method to call an external geocoding API and
 * return the raw JSON response for a given address.
 */
public with sharing class GetAddressCoordinates {
    @AuraEnabled

    /**
     * Returns the raw JSON response from the configured geocoding API for the
     * given address string. Performs URL encoding on the address and issues a
     * HTTP GET callout to the callout endpoint named 'GeoApify_API'.
     *
     * @param address The address to geocode; may be null or empty.
     * @return The raw JSON response body from the geocoding API.
     * @throws AuraHandledException when the callout fails or returns a non-200 status.
     */
    public static String getGeocodeInfo(String address) {
        // Replace spaces with '+' for URL formatting
        String formattedAddress = address != null 
            ? EncodingUtil.urlEncode(address, 'UTF-8') 
            : '';

        // Example using Google Maps Geocoding API endpoint
        // (In real usage, store keys securely)
        //Set up requst object
            HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'callout:GeoApify_API/v1/geocode/search?text=' +
            formattedAddress +
            '&format=json'
        );

            //EncodingUtil.urlEncode(address, 'UTF-8'));
        req.setMethod('GET');
        try {
            HttpResponse resp = new Http().send(req);

            System.debug('Status Code = ' + resp.getStatusCode());
            System.debug('Status = ' + resp.getStatus());
            System.debug('Body = ' + resp.getBody());

            if (resp.getStatusCode() == 200) {
                //Do JSON parsing if needed (currently just returns raw body)return resp.getBody();
                Map<String,Object> results = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
                //In your LWC JS access the reusltslike this:
                // this.longiture = Features[0].proeprties.lon;
                // this.latitude = Features[0].proeprties.lat;
                return resp.getBody();
            }

            throw new AuraHandledException(
                'HTTP ' +
                resp.getStatusCode() +
                ' Body: ' +
                resp.getBody()
            );
        }catch (CalloutException ex) {
            System.debug('CALL OUT EXCEPTION: ' + ex.getMessage());
            throw new AuraHandledException(
                'CalloutException: ' + ex.getMessage()
            );

        }catch(Exception ex){
            if(ex instanceof AuraHandledException){
                throw ex;
            }
            throw new AuraHandledException(ex.getMessage());
        }
    }
        //return 'https://maps.googleapis.com/maps/api/geocode/json?address=' + formattedAddress +
    }
 