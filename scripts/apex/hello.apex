// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// Account testAccount = new Account(Name = 'Test Account', Industry = 'Banking');
//         insert testAccount;

// List<Opportunity> oppList = [SELECT Id, StageName, IsDeleted, AccountId  FROM Opportunity WHERE Id IN :Trigger.old];

List<Account> accountsToInsert = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            Account testAccount = new Account(Name = 'Test Account ' + i);
            accountsToInsert.add(testAccount);
        }
        
        insert accountsToInsert;

        List<Contact> contactsToInsert = new List<Contact>();
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
        for (Account acc : accountsToInsert) {            
            for (Integer i = 0; i < 3; i++) {
                Contact con = new Contact(
                    FirstName = String.valueOf(i),
                    LastName = 'Last Name ' + i,
                    AccountId = acc.Id
                );
                if (i == 0) {
                    con.Title = 'CEO';
                    con.FirstName = 'Big Boss';
                }
                contactsToInsert.add(con);
            }  
            
            for (Integer i = 0; i < 3; i++) {
                Opportunity opp = new Opportunity(
                    Name = 'Test Opportunity ' + i,
                    CloseDate = Date.today().addDays(i),
                    StageName = 'Prospecting',
                    Amount = 6000,
                    AccountId = acc.Id,
                    Primary_Contact__c = null
                );
                opportunitiesToInsert.add(opp);
            }
            
        }

        insert contactsToInsert;
        insert opportunitiesToInsert;

        for (Opportunity opp : opportunitiesToInsert) {
            opp.Primary_Contact__c = null;
        }
        update opportunitiesToInsert;


        
            
        
        
     