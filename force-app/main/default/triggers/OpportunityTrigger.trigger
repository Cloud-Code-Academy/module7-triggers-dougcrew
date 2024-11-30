trigger OpportunityTrigger on Opportunity (before insert, before update, after update, before delete, after delete) {
    System.debug('OpportunityTrigger');

    if(Trigger.isBefore && Trigger.isUpdate){
            overFiveThousand();
            setPrimaryContact();
    }

    else if(Trigger.isDelete && Trigger.isBefore){
            dontDeleteBanking();
    } 

    public static void overFiveThousand(){
        for(Opportunity opp : Trigger.new){
            if(opp.Amount <= 5000){
              opp.addError('Opportunity amount must be greater than 5000');  
            }
        }
    }

    public static void dontDeleteBanking(){
        List<Opportunity> oppsWithAccounts = [SELECT Id, StageName, Account.Industry 
                                                FROM Opportunity 
                                                WHERE Id IN :Trigger.oldMap.keySet()];
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(oppsWithAccounts);

        for(Opportunity oldOpp : Trigger.old) {
            Opportunity oppWithAccount = oppMap.get(oldOpp.id);

            if(oppWithAccount.StageName == 'Closed Won' && 
                oppWithAccount.Account.Industry == 'Banking') {
                oldOpp.addError('Cannot delete closed opportunity for a banking account that is won');
            }            
        }     
    }

    public static void setPrimaryContact(){
       
        Set<Id> accIds = new Set<Id>();  
         
            for(Opportunity opp : Trigger.new) {    
                    accIds.add(opp.AccountId);  
            } 
       
        Map<Id, Contact> accToCEOMap = new Map<Id, Contact>();

            for(Account acc : [SELECT Id, (SELECT Id FROM Contacts WHERE Title = 'CEO' LIMIT 1)
            FROM Account WHERE Id IN :accIds]){
                if(!acc.Contacts.isEmpty()) {
                    accToCEOMap.put(acc.Id, acc.Contacts);
                }
            
            }

            for(Opportunity opp : Trigger.new) {    
                if(accToCEOMap.containsKey(opp.AccountId)) {
                    opp.Primary_Contact__c = accToCEOMap.get(opp.AccountId).Id;
                }                    
            }            
        }          
    }
