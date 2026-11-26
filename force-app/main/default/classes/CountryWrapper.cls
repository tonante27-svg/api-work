/*
* CountryWrapper
*/
// 1. THE WRAPPER (Type-Safe for the API)
public class CountryWrapper {
    public NameWrapper name;
    public List<String> capital;
    public List<String> continents;
    public String region;
    public MapsWrapper maps;
    public FlagsWrapper flags;

    public class NameWrapper { public String common; }
    public class MapsWrapper { public String openStreetMaps; }
    public class FlagsWrapper { public String png; public String alt; }// Useful for the IMAGE() alt text!

    public static List<CountryWrapper> parseApiResponse(String jsonBody) {
        return (List<CountryWrapper>) JSON.deserialize(jsonBody, List<CountryWrapper>.class);
    }
}