/**
 * Service class for retrieving weather details for a city via an external API.
 */
public with sharing class WeatherService {
    /**
     * Retrieves weather information for the provided city name.
     *
     * @param cityName The city name to look up.
     * @return A map containing the weather response from the API.
     */
    @AuraEnabled
    public static WeatherWrapper getWeather(String cityName){
        System.debug('Entered processCityName');
        System.debug(cityName);
        Boolean isValidName = false;
        isValidName = validateInput(cityName);
        if (isValidName) {
            cityName = processStringForAPI(cityName);
            return fetchWeatherInfo(cityName);
        } else {
            throw new AuraException('AuraException occurred: Book Name Invalid');
        }
    }

    /**
     * Validates the provided city name.
     *
     * @param cityName The city name to validate.
     * @return true if the city name is not blank.
     * @throws AuraHandledException If the input is invalid.
     */
    public static Boolean validateInput(String cityName){
        if (!String.isBlank(cityName)) {
            return true;
        } else {
            throw new AuraHandledException('Invalid city name');
        }
    }

    /**
     * Normalizes the city name for the API request.
     *
     * @param cityName The original city name.
     * @return The city name formatted for URL use.
     */
    public static String processStringForAPI(String cityName){
        if (cityName != null && cityName.indexOf('+') == -1 && cityName.trim().containsWhitespace()) {
            cityName = cityName.trim().replaceAll('\\s+', '+');
        }
        return cityName;
    }

    /**
     * Calls the external weather API and deserializes the response.
     *
     * @param cityName The city name to query.
     * @return A map containing the response data from the API.
     */
    public static WeatherWrapper fetchWeatherInfo(String cityName){

        //Get the access for this site:
        Weather_Config__c config = Weather_Config__c.getInstance();
        if(config == null || String.isBlank(config.API_Key__c)){
            throw new AuraHandledException ('Weather API Configuration is missing.');
        }
        String apiKey = config.API_Key__c;

        HttpRequest req = new HttpRequest();
        req.setEndpoint(
            'callout:WeatherAPI/data/2.5/weather?q=' +
            EncodingUtil.urlEncode(cityName, 'UTF-8')+'&appid='+apiKey+'&units=imperial') ;
        req.setMethod('GET');
        HttpResponse resp;

        try{
            resp = new Http().send(req);
        }catch(Exception ex){
            throw new AuraHandledException(' Callout failed '+ ex.getMessage());
        }
        if (resp.getStatusCode() == 200) {
            Map<String, Object> weatherData =  (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
           return new WeatherWrapper(weatherData);
        } else {
            throw new AuraHandledException('Error ' + resp.getStatusCode() + ':' + resp.getBody());
        }
    }
}