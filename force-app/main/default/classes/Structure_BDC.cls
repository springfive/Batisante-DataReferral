/**
* @author Amine SARBOUTE
* @date 21/07/2020
* @description Structure_BDC : Wrapper BDC, Gestion des erreurs et requêtes
*/
global with sharing class Structure_BDC {
    global virtual class MessageRetour {
        
        public  MessageRetour () {
            
        }
        
        //identifiant du compte Azur
        webservice String  nBDC { get; set; }
        webservice integer codeErreur { get; set; }
        webservice String  message { get; set; }
        webservice String  IdSFDC { get; set; }
        webservice Structure_BDC.BDCWrapper BDC { get; set; }
        
    }
    global class BDCWrapper{
        webservice String dateCreaAz { get; set; }//OK
        webservice String prestation { get; set; }//OK +Transco type1 et type2
        webservice String noBDC { get; set; }//OK
        webservice String idElmtPropo { get; set; }//OK
        webservice String libelle { get; set; }//OK
        webservice String montantHT { get; set; }//OK
        webservice String societe { get; set; }//OK
        webservice String pole { get; set; }//OK
        webservice String dateInsertion { get; set; }//OK
        webservice String dateEffet { get; set; }//OK
        webservice String dateFin { get; set; }//OK
        webservice String dateInsertResil { get; set; }//OK
        webservice String dateEffetResil { get; set; }//OK
        webservice String dateAcception { get; set; }//OK
        webservice String codeSite { get; set; }//OK
        webservice String statut { get; set; }//OK
        webservice String idLeadCRM {get; set;}//link to proposition
    }
    public static list<BS_BDC__c> getBDCByNoBDC(Structure_BDC.BDCWrapper bdc){
        List<BS_BDC__c> bdcs=[SELECT id, name, BS_N_BDC__c, BS_Date_creation_Az__c, BS_Prestation__c, BS_Type1__c, BS_Type2__c, BS_Statut__c,
                              BS_N_element__c, BS_Libelle__c, BS_Prix_HT__c, BS_Societe__c, BS_Pole__c,BS_Date_insertion__c,
                              BS_Date_effet__c, BS_Date_de_fin__c, BS_Date_insertion_resiliation__c, BS_Date_effet_resiliation__c,
                              BS_Date_acceptation__c, BS_Client__c, BS_Code_Site__c, BS_Site__c,
                              BS_Adresse_du_site__c, BS_Ref_client__c, BS_Contact__c
                              FROM BS_BDC__c WHERE BS_N_BDC__c= :bdc.noBDC];
        return bdcs;
    }
    public static List<TypeBDC__mdt> transcoFromPrestation(Structure_BDC.BDCWrapper bdc) {
        List<TypeBDC__mdt> mdtBDC = [SELECT MasterLabel, QualifiedApiName, BS_Prestation__c, BS_Type1__c, BS_Type2__c	
                                     FROM TypeBDC__mdt 
                                     WHERE BS_Prestation__c = :bdc.prestation];
        return mdtBDC;
    }
    public static List<BS_statut_Contrat__mdt> transcoFromCodeStatut(Structure_BDC.BDCWrapper bdc) {
        List<BS_statut_Contrat__mdt> mdtStatut = [SELECT MasterLabel, QualifiedApiName, BS_Code__c, BS_Statut__c	
                                                  FROM BS_statut_Contrat__mdt 
                                                  WHERE BS_Code__c = :bdc.statut];
        return mdtStatut;
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
    
     public static list<BS_BDC_Site__c> getBdcSiteById(String codeSite, Structure_BDC.BDCWrapper bdc){
        List<BS_Site__c> sites= Structure_BDC.getSiteAndClientByCodeSite(codeSite);
        List<BS_BDC__c> bdcs= Structure_BDC.getBDCByNoBDC(bdc);
        List<BS_BDC_Site__c> bdcSites=[SELECT id, BS_Site__c, BS_BDC__c
                                      FROM BS_BDC_Site__c WHERE BS_Site__c= :sites[0].id AND BS_BDC__c= :bdcs[0].id];
        return bdcSites;
     }
	
    public static Structure_BDC.MessageRetour clientManquant(Structure_BDC.BDCWrapper bdc) {
        Structure_BDC.MessageRetour messageRetour = new Structure_BDC.MessageRetour();
        messageRetour.message = 'Client manquant: Le site n\'est associé à aucun client';
        messageRetour.nBDC=bdc.noBDC;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_BDC.MessageRetour codeSiteManquant(Structure_BDC.BDCWrapper bdc) {
        Structure_BDC.MessageRetour messageRetour = new Structure_BDC.MessageRetour();
        messageRetour.message = 'Le code site est obligatoire';
        messageRetour.nBDC=bdc.noBDC;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_BDC.MessageRetour codeSiteInvalide(Structure_BDC.BDCWrapper bdc) {
        Structure_BDC.MessageRetour messageRetour = new Structure_BDC.MessageRetour();
        messageRetour.message = 'Le code site ne correspond à aucun site';
        messageRetour.nBDC=bdc.noBDC;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_BDC.MessageRetour nBDCManquant(Structure_BDC.BDCWrapper bdc) {
        Structure_BDC.MessageRetour messageRetour = new Structure_BDC.MessageRetour();
        messageRetour.message = 'Le N° BDC est obligatoire';
        messageRetour.nBDC=bdc.noBDC;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_BDC.MessageRetour codeStatutInvalide(Structure_BDC.BDCWrapper bdc) {
        Structure_BDC.MessageRetour messageRetour = new Structure_BDC.MessageRetour();
        messageRetour.message = 'Le statut ne correspond à aucun statut dans Salesforce. Valeurs possibles : O, C, S, T, R, K';
        messageRetour.nBDC=bdc.noBDC;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_BDC.MessageRetour codeStatutManquant(Structure_BDC.BDCWrapper bdc) {
        Structure_BDC.MessageRetour messageRetour = new Structure_BDC.MessageRetour();
        messageRetour.message = 'Le statut est obligatoire. Valeurs possibles : O, C, S, T, R, K';
        messageRetour.nBDC=bdc.noBDC;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    
    public static List<BS_Devis_from_Lead__c> getProposition(Structure_BDC.BDCWrapper bdc) {
        List<BS_Devis_from_Lead__c> propo = [SELECT   Id, BS_N_Devis__c	
                                                      FROM 	BS_Devis_from_Lead__c 
                                                      WHERE BS_N_Devis__c = :bdc.idLeadCRM];
        return propo;
    }
    
}