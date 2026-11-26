String jsonString = '{' +
    '"city": "Tampa",' +
    '"temperature": 82.5,' +
    '"humidity": 65,' +
    '"conditions": {' +
        '"description": "Partly cloudy",' +
        '"windSpeed": 10' +
    '}' +
'}';
Map<String,Object> returnedObject = (Map<String,Object>)JSON.deserializeUnTyped(jsonString);
system.debug((String)returnedObject.get('city'));
system.debug(returnedObject.get('conditions'));
Map<String,Object> conditions = (Map<String,Object>)returnedObject.get('conditions');
system.debug((String)conditions.get('description'));
system.debug((Double)conditions.get('windSpeed'));