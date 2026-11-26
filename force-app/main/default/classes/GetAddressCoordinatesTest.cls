@IsTest
private with sharing class GetAddressCoordinatesTest {
    /**
     * Mock implementation of HttpCalloutMock for testing StockFitService callouts.
     */
    private class GeoApifyServiceCalloutMock implements HttpCalloutMock {
        private Integer statusCode = 200;
        private String body = '{"success": true}';

        /**
         * Constructor for ExternalServiceCalloutMock.
         * @param statusCode The HTTP status code to return
         * @param body The response body to return
         */
        public GeoApifyServiceCalloutMock(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }

        /**
         * Generates a mock HTTP response.
         * @param request The HTTP request
         * @return The mock HTTP response
         */
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();

            response.setStatusCode(this.statusCode);
            response.setBody(this.body);
            response.setHeader('Content-Type', 'application/json');

            return response;
        }
    }

    //========================== Test Methods ========================== }
    @IsTest
    static void testGetGeoCodeInfoSuccess() {
          // Arrange - Mock successful response
        String mockJson = 
        '{' +
            '"features": [' +
                '{' +
                    '"properties": {' +
                        '"lon": -122.4159922,' +
                        '"lat": 37.780315' +
                    '}' +
                '}' +
            ']' +
        '}';
        String endpointPath = '';
        String address = '200 Larkin Street, San Francisco, CA 94102, United States';
        Test.setMock(HttpCalloutMock.class, 
                     new GeoApifyServiceCalloutMock(200, mockJson));

        String result;
        Test.startTest();
        result = GetAddressCoordinates.getGeocodeInfo(address);
        Test.stopTest();
        
        // Assert
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(true, mockJson.contains('37.780315'), 'Stock symbol should match expected value');
    }
}