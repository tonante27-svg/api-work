import { LightningElement,track} from 'lwc';
import getWeatherUpdate from "@salesforce/apex/WeatherService.getWeather";
import ToastMsg from 'lightning/toast';
export default class CityWeatherLookup extends LightningElement {

    cityName;
    errorMessage;
    @track weatherData;
    @track islLoading = false;
    isNotSubmitted = true;

    handleCity(event){
        this.cityName = event.target.value;
    }
    handleSearch() {
        // pass this.city as an argument // TODO: implement callout logic using this.city
        //console.log('Fetching weather for', this.cityName);
        // You must use a call to an asych function for calling the Apex backend
        // TODO: Call Apex method here using this.city using "wait" keyword 
        this.callWeatherService();
    }

    async callWeatherService() {
        try {
            this.isLoading = true;
            this.weatherData = await getWeatherUpdate({ cityName: this.cityName });
            //console.log('Weather Data:', this.weatherData);
            this.isLoading = false;
            this.isNotSubmitted = false;
            if (this.weatherData && typeof this.weatherData !== 'string') {
               // this.weatherData = JSON.stringify(this.weatherData, null, 2);
                this.handleToast('Weather data was retrieved','Weather for city: '+this.cityName+' was retrieved','success');
            }
        } catch (error) {
            console.error('Error fetching weather:', error);
            this.errorMessage = error.body && error.body.message ? error.body.message : error.message;
             handleToast('An Error has occured when retrieveing weather data.',this.errorMessage, 'error');
        }finally{
            this.isLoading = false;
        }
    }

    handleToast(a_label,a_message,a_variant){
        ToastMsg.show({
            label: a_label,
            message: a_message,
            variant: a_variant})

    }
}