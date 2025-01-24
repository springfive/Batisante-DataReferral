global class scheduleGestionnaire implements Schedulable {
    
    global static void execute(SchedulableContext SC) {
        GestionnaireBDC();
        GestionnaireEngagement();
        GestionnaireContrat();
        GestionnaireDevis();
    }
    
    public static void GestionnaireBDC() {
        List<BS_BDC__c> bdcList = [SELECT BS_Client__c FROM BS_BDC__c WHERE BS_Contact__c=:null];
        List<Contact> contactsBdc = new List<Contact>([SELECT Id, AccountId FROM Contact where RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire' AND Accountid in (SELECT BS_Client__c from BS_BDC__c where BS_Contact__c=:null)]);
        if (contactsBdc.size() > 0) {
            for (BS_BDC__c bdc : bdcList) {
                for (Contact c : contactsBdc) {
                    if (bdc.BS_Client__c == c.AccountId) {
                        bdc.BS_Contact__c = c.Id;
                        update bdc;
                        break;
                    }
                }
            }
        }
    }
    
    public static void GestionnaireEngagement() {
        List<BS_Engagement__c> engagementList = [SELECT BS_Client__c FROM BS_Engagement__c WHERE BS_Contact__c=:null];
        List<Contact> contactsBdc = new List<Contact>([SELECT Id, AccountId FROM Contact where RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire' AND Accountid in (SELECT BS_Client__c from BS_Engagement__c where BS_Contact__c=:null)]);
        if (contactsBdc.size() > 0) {
            for (BS_Engagement__c eng : engagementList) {
                for (Contact c : contactsBdc) {
                    if (eng.BS_Client__c == c.AccountId) {
                        eng.BS_Contact__c = c.Id;
                        update eng;
                        break;
                    }
                }
            }
        }
    }
    
    public static void GestionnaireContrat() {
        List<Contract> bdcList = [SELECT AccountId FROM Contract WHERE BS_Gestionnaire__c=:null];
        List<Contact> contactsBdc = new List<Contact>([SELECT Id, AccountId FROM Contact where RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire' AND Accountid in (SELECT AccountId from Contract where BS_Gestionnaire__c=:null)]);
        if (contactsBdc.size() > 0) {
            for (Contract bdc : bdcList) {
                for (Contact c : contactsBdc) {
                    if (bdc.AccountId == c.AccountId) {
                        bdc.BS_Gestionnaire__c = c.Id;
                        update c;
                        break;
                    }
                }
            }
        }
    }
    
    public static void GestionnaireDevis() {
        List<BS_Devis__c> bdcList = [SELECT BS_Nom_Client__c FROM BS_Devis__c WHERE BS_Contact__c=:null];
        List<Contact> contactsBdc = new List<Contact>([SELECT Id, AccountId FROM Contact where RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire' AND Accountid in (SELECT BS_Nom_Client__c from BS_Devis__c where BS_Contact__c=:null)]);
        if (contactsBdc.size() > 0) {
            for (BS_Devis__c bdc : bdcList) {
                for (Contact c : contactsBdc) {
                    if (bdc.BS_Nom_Client__c == c.AccountId) {
                        bdc.BS_Contact__c = c.Id;
                        update bdc;
                        break;
                    }
                }
            }
        }
    }    
}