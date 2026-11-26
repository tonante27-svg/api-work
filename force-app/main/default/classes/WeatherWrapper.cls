/**
 * Represents weather data parsed from a weather API response.
 */
public with sharing class WeatherWrapper {
    @AuraEnabled public String cityName;
    @AuraEnabled public Decimal temperature;
    @AuraEnabled public String condition;
    @AuraEnabled public Decimal humidity;
    /**
     * Creates a weather wrapper from a parsed weather API response.
     * @param jsonMap Parsed weather response data.
     */
    public WeatherWrapper( Map<String,Object> jsonMap) {
        this.cityName =(String)jsonMap.get('name');
        Map<String,Object> main = (Map<String,Object>)jsonMap.get('main');
        this.humidity = (Decimal)main.get('humidity');
        this.temperature = (Decimal) main.get('temp');
        List<Object>weatherList = (List<Object>)jsonMap.get('weather');
        if (weatherList != null && !weatherList.isEmpty()) {
            Map<String,Object> weatherObj = (Map<String,Object>)weatherList[0];
            this.condition = (String)weatherObj.get('description');
        }
    }
    
}