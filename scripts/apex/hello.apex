// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);
Datetime dt = Datetime.newInstance(
               Date.newInstance(
                  2011, 3, 22),
               Time.newInstance(
                  1, 15, 18, 0)); 
    String str = JSON.serialize(dt); 
    Assert.areEqual(
       '"2011-03-22T08:15:18.000Z"',
       str);