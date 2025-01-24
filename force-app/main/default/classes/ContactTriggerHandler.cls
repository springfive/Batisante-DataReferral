public class ContactTriggerHandler {
    
    public static void contactBeforeInsert(List<Contact> contactList){
        
        Map<Id, Account> clientMap = new Map<Id, Account>();
        Set<String> BS_Id_SourceSet = new Set<String>();
        List<Contact> contactForInsert= new List<Contact>();

        for(Contact con :contactList){
            BS_Id_SourceSet.add(con.BS_Id_Source__c);
        }
        
        List<Account> clients=[SELECT id, ownerId, ShippingStreet, ShippingPostalCode, ShippingCity, ShippingCountry FROM Account WHERE BS_Id_ClientAzur__c IN :BS_Id_SourceSet];
        
        List<Schema.Location> sites=[SELECT id, BS_Client__c, BS_Adresse_site__c, BS_Adresse_Lieu__c, BS_code_site__c FROM Location WHERE BS_code_site__c IN :BS_Id_SourceSet];
        
        // Populate the clientMap
        for (Account client : clients) {
            clientMap.put(client.Id, client);
        }
        
        Map<String, Schema.Location> siteMap = new Map<String, Schema.Location>();
        
        // Populate the siteMap
        for (Schema.Location site : sites) {
            siteMap.put(site.BS_code_site__c, site);
        }
        
        //Contact cont = new Contact();
        for(Contact con: contactList){
            
            if(con.BS_Code_source__c =='1' && clients.size()>0 && clientMap.containsKey(con.AccountId)){
                
                con.BS_Adresse_postale__c=(clientMap.get(con.AccountId).ShippingStreet!=NULL?clientMap.get(con.AccountId).ShippingStreet +' '+
                                           clientMap.get(con.AccountId).ShippingPostalCode +' '+clientMap.get(con.AccountId).ShippingCity:'');
                
            }else if (con.BS_Code_source__c =='2' && sites.size()>0 && siteMap.containsKey(con.BS_Id_Source__c) && siteMap.get(con.BS_Id_Source__c).BS_Adresse_site__c != null){

                con.BS_Adresse_postale__c= siteMap.get(con.BS_Id_Source__c).BS_Adresse_site__c;
    
            }else if (con.BS_Code_source__c=='4'  && sites.size()>0 && siteMap.containsKey(con.BS_Id_Source__c) && siteMap.get(con.BS_Id_Source__c).BS_Adresse_site__c != null){
                
                con.BS_Adresse_postale__c=siteMap.get(con.BS_Id_Source__c).BS_Adresse_Lieu__c;
            }

        }
    }
    
    public static void contactBeforeUpdate(List<Contact> contactList){
        
        Set<String> BS_Id_SourceSet = new Set<String>();
        Map<Id, Account> clientMap = new Map<Id, Account>();
        Map<String, Schema.Location> siteMap = new Map<String, Schema.Location>();
        List<Contact> contactForUpdate= new List<Contact>();

        for(Contact con :contactList){
            BS_Id_SourceSet.add(con.BS_Id_Source__c);
        }
        
        
        List<Account> clients=[SELECT id, ownerId, ShippingStreet, ShippingPostalCode, ShippingCity, ShippingCountry FROM Account WHERE BS_Id_ClientAzur__c IN :BS_Id_SourceSet];
        
        List<Schema.Location> sites=[SELECT id, BS_Client__c, BS_Adresse_site__c, BS_Adresse_Lieu__c, BS_code_site__c FROM Location WHERE BS_code_site__c IN :BS_Id_SourceSet];
        
        // Populate the clientMap
        for (Account client : clients) {
            clientMap.put(client.Id, client);
        }
        
        // Populate the siteMap
        for (Schema.Location site : sites) {
            siteMap.put(site.BS_code_site__c, site);
        }
        
        //Contact newContact = new Contact();
        for(Contact con: contactList){
            
             if(con.BS_Code_source__c =='1' && clients.size()>0 && clientMap.containsKey(con.AccountId)) {

                con.BS_Adresse_postale__c=(clientMap.get(con.AccountId).ShippingStreet!=NULL?clientMap.get(con.AccountId).ShippingStreet +' '+
                                           clientMap.get(con.AccountId).ShippingPostalCode +' '+clientMap.get(con.AccountId).ShippingCity:'');
            }
            else if (con.BS_Code_source__c =='2' && sites.size()>0 && siteMap.containsKey(con.BS_Id_Source__c) && siteMap.get(con.BS_Id_Source__c).BS_Adresse_site__c!=null){
                
                con.BS_Adresse_postale__c=siteMap.get(con.BS_Id_Source__c).BS_Adresse_site__c;

            }else if (con.BS_Code_source__c=='4'  && sites.size()>0 && siteMap.containsKey(con.BS_Id_Source__c) && siteMap.get(con.BS_Id_Source__c).BS_Adresse_Lieu__c!=null){
                
                con.BS_Adresse_postale__c=siteMap.get(con.BS_Id_Source__c).BS_Adresse_Lieu__c;
            }
        }
        
    } 
}