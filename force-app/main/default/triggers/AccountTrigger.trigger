trigger AccountTrigger on Account (before insert, after insert) {
    System.debug('Trigger.new size: ' + Trigger.new.size());

    if(Trigger.isBefore && Trigger.isInsert){
        accountType();
        updateBillingAddress();
        setRatingToHot();  
         
    }

    if(Trigger.isAfter && Trigger.isInsert){
        createContact();  
    }

    public static void accountType(){
        for ( Account acc : Trigger.new){
                if(acc.Type == null){
                acc.Type = 'Prospect';
            }
        }   
    }

    public static void updateBillingAddress(){
        for(Account acc : Trigger.new) {
            if(acc.ShippingAddress == null){
                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;
            }
        }
    }

    public static void setRatingToHot(){
        for(Account acc : Trigger.new){
            if(acc.Phone != null && acc.Website != null && acc.Fax != null){
                acc.Rating = 'Hot';
            }
        }
    }

    public static void createContact(){
       List<Contact> contactsToInsert = new List<Contact>();
        for (Account acc : Trigger.new){   
            Contact cont = new Contact(
            AccountId = acc.Id,   
            LastName = 'DefaultContact',
            Email = 'default@email.com'
            );
            
        contactsToInsert.add(cont);
    } 
    if(!contactsToInsert.isEmpty()) {
        insert contactsToInsert;
    } System.debug('Just inserted these::: ' + contactsToInsert);
    }
}