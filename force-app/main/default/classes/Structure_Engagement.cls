/**
* @author Amine SARBOUTE
* @date 20/07/2020
* @description Structure_Engagement : Wrapper Engagement, Gestion des erreurs et requêtes
*/
global with sharing class Structure_Engagement {
    global virtual class MessageRetour {
        
        public  MessageRetour () {
            
        }
        
        //identifiant du compte Azur
        webservice String  idEngagement { get; set; }
        webservice integer codeErreur { get; set; }
        webservice String  message { get; set; }
        webservice String  IdSFDC { get; set; }
        webservice Structure_Engagement.EngagementWrapper engagement { get; set; }
        
    }
    global class EngagementWrapper{
        webservice String prestation { get; set; }//OK
        webservice String dateAcceptation { get; set; }//OK
        webservice String dateResiliation { get; set; }//OK
        webservice String idEngagement { get; set; }//OK
        webservice String creeLe { get; set; }//OK
        webservice String modifieLe { get; set; }//OK
        webservice String prixEstimeHt { get; set; }//OK
        webservice String societe { get; set; }//OK
        webservice String pole { get; set; }//OK
        webservice String codeSite { get; set; }
        webservice String dateCreaDevis { get; set; }//OK
        webservice String dateAcceptDevis { get; set; }//OK
        webservice String dateRefusDevis { get; set; }//OK
    }
    public static list<BS_Engagement__c> getEngagementByIdEngagement(Structure_Engagement.EngagementWrapper eng){
        List<BS_Engagement__c> engagements=[SELECT id, Name, BS_Prestation__c, BS_Type1__c, BS_Type2__c, BS_Date_acceptation__c, 
                                            BS_Date_de_resiliation__c, BS_Date_creation_Az__c, BS_Date_modification_Az__c,
                                            BS_Prix_estime_HT__c, BS_Societe__c, BS_Pole__c, BS_Date_creation_devis_Az__c,
                                            BS_Date_acceptation_Devis__c, BS_Date_refus_devis__c, BS_Code_site__c, BS_Client__c, 
                                            BS_Contact__c, BS_Site__c
                                            FROM BS_Engagement__c
                                            WHERE BS_ID_engagement_Az__c= :eng.idEngagement];
        return engagements;
    }
    public static List<BS_Type_engagement__mdt> transcoFromPrestation(Structure_Engagement.EngagementWrapper eng) {
        List<BS_Type_engagement__mdt> mdtTypeEng = [SELECT MasterLabel, QualifiedApiName, BS_N_Engagement__c, BS_Type1__c, BS_Type2__c	
                                                  	FROM BS_Type_engagement__mdt 
                                                  	WHERE BS_N_Engagement__c= :eng.prestation];
        return mdtTypeEng;
    }
    public static list<BS_Site__c> getSiteAndClientByCodeSite(String codeSite){
        List<BS_Site__c> site=[SELECT id, BS_Code_Site__c, BS_Client__c 
                               FROM BS_Site__c WHERE BS_Code_Site__c= :codeSite];
        return site;
    }
    public static list<Contact> getGestionnaireByIdClient(String idClient){
        List<Contact> contact=[SELECT id, AccountId, BS_Typologie__c, BS_Principal__c
                               FROM Contact WHERE AccountId= :idClient AND RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire'];
        return contact;
    }
    /*
    public static Structure_Engagement.MessageRetour clientManquant(Structure_Engagement.EngagementWrapper eng) {
        Structure_Engagement.MessageRetour messageRetour = new Structure_Engagement.MessageRetour();
        messageRetour.message = 'Client manquant: Le site n\'est associé à aucun client';
        messageRetour.idEngagement=eng.idEngagement;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }*/
    public static Structure_Engagement.MessageRetour codeSiteInvalide(Structure_Engagement.EngagementWrapper eng) {
        Structure_Engagement.MessageRetour messageRetour = new Structure_Engagement.MessageRetour();
        messageRetour.message = 'Le code site ne correspond à aucun site';
        messageRetour.idEngagement=eng.idEngagement;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Engagement.MessageRetour codeSiteManquant(Structure_Engagement.EngagementWrapper eng) {
        Structure_Engagement.MessageRetour messageRetour = new Structure_Engagement.MessageRetour();
        messageRetour.message = 'Le code site est obligatoire';
        messageRetour.idEngagement=eng.idEngagement;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Engagement.MessageRetour idEngagementManquant(Structure_Engagement.EngagementWrapper eng) {
        Structure_Engagement.MessageRetour messageRetour = new Structure_Engagement.MessageRetour();
        messageRetour.message = 'L\'id Engagement est obligatoire';
        messageRetour.idEngagement=eng.idEngagement;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    
}