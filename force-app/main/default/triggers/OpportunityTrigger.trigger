trigger OpportunityTrigger on Opportunity (before insert, after update) {
    System.debug('OpportunityTrigger');

    if(Trigger.isAfter && Trigger.isUpdate){
            overFiveThousand();
    }

    public static void overFiveThousand(){
        for(Opportunity opp : Trigger.new){
            if(opp.Amount <= 5000){
              opp.addError('Opportunity amount must be greater than 5000');  
            }
        }
    }
}