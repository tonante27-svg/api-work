@isTest
public class CountryTriggerHandlerTest {

    @isTest
    public static void testGoodCountryEntries(){
        List<Country__c> countries = new List<Country__c>();
        countries.add(new Country__c(Name='Germany', Region__c='Europe',Flag__c='https://flagcdn.com/w320/de.png',Location__c ='https://www.openstreetmap.org/relation/51477#map=6/51.35/10.45' ));
        countries.add(new Country__c(Name='Philippines', Capital__c = 'Manila', Region__c='Asia',Flag__c='https://flagcdn.com/w320/ph.png',Location__c ='https://www.openstreetmap.org/relation/443174#map=5/13.00/120.45' )) ;   
    	Database.insert(countries,false);   
        System.assertEquals(2,countries.size(), 'There should be only 2 countries in this list');
    }
    
    public static void testBadlag(){
        List<Country__c> countries = new List<Country__c>();
        countries.add(new Country__c(Name='Germany', Region__c='Europe',Flag__c='https://flagcdn.com/w320/de.png',Location__c ='https://www.openstreetmap.org/relation/51477#map=6/51.35/10.45' ));
        //1. Look for bad Flag URL 
        countries.add(new Country__c(Name='Madagascar', Capital__c = 'Antananarivo', Region__c='Africa',Flag__c='https://flagcdn1.com/w320/ph.png',Location__c ='https://www.openstreetmap.org/relation/443174#map=5/13.00/120.45' )) ;   
        Integer ctyIdx = 0;
        Integer originalSize = countries.size();
        //2. Need to save a backup of countries which will contain  countries having valid flag urls only.
        List<Country__c> countriesBkUp = new List<Country__C>();
        countriesBkUp = countries;
        for(Country__c cty : countries){
            if(!cty.Flag__c.contains('https://flagcdn.com')){
               countriesBkUp.remove(ctyIdx); 
            }
        }
        //3. Check if the list was totally bad and there are no valid countries in thelist.
        Integer difference = originalSize -ctyIdx;
        if(!countriesBkUp.isEmpty()){ 
            countries = countriesBkUp;
        	System.debug('<< countries >> '+countries);
        	Database.insert(countries,false); 
         }
         System.assertEquals(difference,countries.size(), 'There should be only original size - bad number of countries in this list');
    }
    
     public static void testBadRegionCapital(){
        List<Country__c> countries = new List<Country__c>();
        countries.add(new Country__c(Name='Germany',Flag__c='https://flagcdn.com/w320/de.png',Location__c ='https://www.openstreetmap.org/relation/51477#map=6/51.35/10.45' ));
        //1. Look for Missing or null Capital and Region fields
        countries.add(new Country__c(Name='Madagascar',Flag__c='https://flagcdn1.com/w320/ph.png',Location__c ='https://www.openstreetmap.org/relation/443174#map=5/13.00/120.45' )) ;   
        Integer ctyIdx = 0;
        Integer originalSize = countries.size();
        //2. Need to save a backup of countries which will contain  countries having valid flag urls only.
        List<Country__c> countriesBkUp = new List<Country__C>();
        countriesBkUp = countries;
        for(Country__c cty : countries){
            if(cty.Capital__c == null || cty.Capital__c.isWhitespace() || 
              	cty.Region__c == null || cty.Region__c.isWhitespace() ){
               countriesBkUp.remove(ctyIdx); 
            }
        }
        //3. Check if the list was totally bad and there are no valid countries in thelist.
        Integer difference = originalSize -ctyIdx;
        if(!countriesBkUp.isEmpty()){ 
            countries = countriesBkUp;
        	System.debug('<< countries >> '+countries);
        	Database.insert(countries,false); 
         }
         System.assertEquals(difference,countries.size(), 'There should be only original size - bad number of countries in this list');
    }
    
}