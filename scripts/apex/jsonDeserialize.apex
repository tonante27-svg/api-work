String jsonStr = '{' +
  '"Name":"Acme Corp",' +
  '"Industry":"Technology",' +
  '"AnnualRevenue":5000000,' +
  '"Phone":"415-555-0100"' +
'}';

// deserialize
Account acc = (Account) JSON.deserialize(jsonStr, Account.class);
System.debug(acc.Name);           // Acme Corp
System.debug(acc.Industry);       // Technology
System.debug(acc.AnnualRevenue);  // 5000000
System.debug(acc.Phone);          // 415-555-0100
// deserializeStrict — throws JSONException if JSON has unknown fields
//String jsonWithExtra = '{"Name":"Acme","UnknownField":"oops"}';// Takes the unknown field and the standard Name field
//Account safe   = (Account) JSON.deserialize(jsonWithExtra, Account.class);       // OK
//Account strict = (Account) JSON.deserializeStrict(jsonWithExtra, Account.class); // throws

String jsonStr2 = '[' +
    '{"Name":"Ace Corp","Industry":"Technology","AnnualRevenue":5000000},' +
    '{"Name":"Globex Inc","Industry":"Manufacturing","AnnualRevenue":125000000},' +
    '{"Name":"Initeche Corp","Industry":"Finance","AnnualRevenue":35000000}' +
']';

List<Account> accts = (List<Account>) JSON.deserialize(jsonStr2, List<Account>.class);
System.debug('===== ACCTS ==== ' + accts);
System.debug('===== ACCTS ==== ' + accts[0].Industry);

String jsonStr3 = '[' +
    '{"Name":"Ace Corp","Industry":"Technology","AnnualRevenue":5000000,"Active":"Yes"},' +
    '{"Name":"Globex Inc","Industry":"Manufacturing","AnnualRevenue":125000000},' +
    '{"Name":"Initeche Corp","Industry":"Finance","AnnualRevenue":35000000}' +
']';

//List<Account> acctsStrict = (List<Account>) JSON.deserializeStrict(jsonStr3, List<Account>.class);// Throws and Error
//DeserializeUnTyped - object dynamically changes
String jsonStrUT = '{' +
  '"Name":"Acme Corp",' +
  '"Industry":"Technology",' +
  '"AnnualRevenue":5000000,' +
  '"Active":true,' +
  '"Phone":"415-555-0100",' +
   '"Tags":["CRM","ERR","Cloud"]' +
'}';
Map<String, Object> result = (Map<String, Object>)JSON.deserializeUntyped(jsonStrUT);

List<Object> tags = (List<Object>)result.get('Tags');
for(Object tag : tags){
    system.debug('=== CONTENT TAGS === '+tag);
}
//system.debug('=== CONTENT === '+(List<String>)result.get('Tags'));
System.debug('==== PHONE ===='+result.get('Phone'));
System.debug('==== NAME ===='+result.get('Name'));
System.debug('==== ACIVE ===='+result.get('Active'));
System.debug('==== ANNUAL REVENUE ===='+result.get('AnnualRevenue'));
System.debug('==== INDUSTRY ===='+result.get('Industry'));