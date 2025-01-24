/**
* @author Amine SARBOUTE
* @date 21/07/2020
* @description Structure_Contrat : Wrapper Contrat, Gestion des erreurs et requêtes
*/
global with sharing class Structure_Contrat {
    global virtual class MessageRetour {
        
        public  MessageRetour () {
            
        }
        
        //identifiant du compte Azur
        webservice String  nContrat { get; set; }
        webservice integer codeErreur { get; set; }
        webservice String  message { get; set; }
        webservice String  IdSFDC { get; set; }
        webservice Structure_Contrat.ContratWrapper engagement { get; set; }
        
    }
    global class ContratWrapper{
        webservice String creeLe { get; set; }//OK
        webservice String noContrat { get; set; }//correspond à la prestation//OK
        webservice String noPosition { get; set; }//Correspond au N° de contrat (unique)//OK
        webservice String libelleContrat { get; set; }//OK
        webservice String montantHT { get; set; }//OK
        webservice String statut { get; set; }//OK
        webservice String dateInsertion { get; set; }//OK
        webservice String dateAcception { get; set; }//OK
        webservice String dateEffet { get; set; }//OK
        webservice String dateInsertResil { get; set; }//OK
        webservice String societe { get; set; }//OK
        webservice String pole { get; set; }//OK
        webservice String codeSite { get; set; }//OK
        webservice String dateEffetResil { get; set; }
        webservice String dateSuspension { get; set; } 
        webservice String DatePropo { get; set; }
        webservice String idLeadCRM {get; set;}//link to proposition
    }
    public static list<Contract> getContratByNcontrat(Structure_Contrat.ContratWrapper ctr){
        List<Contract> contrat=[SELECT id, name, BS_Date_creation_Azur__c, BS_Prestation__c, BS_N_contrat__c, BS_Libelle_du_contrat__c,
                                BS_Montant_total_HT__c, BS_Date_insertion__c, BS_Date_acceptation__c,BS_Date_effet__c,
                                BS_date_insertion_resiliation__c, BS_Societe__c, BS_Pole__c, BS_Code_site__c, AccountId, 
                                BS_Site__c, BS_Gestionnaire__c, BS_Date_effet_resiliation__c, BS_Date_suspension__c, BS_Date_propo__c
                                FROM Contract WHERE BS_N_contrat__c= :ctr.noPosition];
        return contrat;
    }
    public static List<BS_Typologie_Contrat__mdt> transcoFromNContrat(Structure_Contrat.ContratWrapper ctr) {
        List<BS_Typologie_Contrat__mdt> mdtContrat = [SELECT MasterLabel, QualifiedApiName, BS_N_contrat__c, BS_Ordre__c,
                                                      BS_Type_1__c, BS_Type_2__c	
                                                      FROM BS_Typologie_Contrat__mdt 
                                                      WHERE BS_N_contrat__c = :ctr.noContrat];
        return mdtContrat;
    }
    public static List<BS_statut_Contrat__mdt> transcoFromCodeStatut(Structure_Contrat.ContratWrapper ctr) {
        List<BS_statut_Contrat__mdt> mdtStatut = [SELECT MasterLabel, QualifiedApiName, BS_Code__c, BS_Statut__c	
                                                  FROM BS_statut_Contrat__mdt 
                                                  WHERE BS_Code__c = :ctr.statut];
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
    public static Structure_Contrat.MessageRetour codeStatutInvalide(Structure_Contrat.ContratWrapper ctr) {
        Structure_Contrat.MessageRetour messageRetour = new Structure_Contrat.MessageRetour();
        messageRetour.message = 'Le statut ne correspond à aucun statut dans Salesforce. Valeurs possibles : O, C, S, T, R, K';
        messageRetour.nContrat=ctr.noPosition;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contrat.MessageRetour codeStatutManquant(Structure_Contrat.ContratWrapper ctr) {
        Structure_Contrat.MessageRetour messageRetour = new Structure_Contrat.MessageRetour();
        messageRetour.message = 'Le statut est obligatoire. Valeurs possibles : O, C, S, T, R, K';
        messageRetour.nContrat=ctr.noPosition;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contrat.MessageRetour codeSiteInvalide(Structure_Contrat.ContratWrapper ctr) {
        Structure_Contrat.MessageRetour messageRetour = new Structure_Contrat.MessageRetour();
        messageRetour.message = 'Le code site ne correspond à aucun site';
        messageRetour.nContrat=ctr.noPosition;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contrat.MessageRetour codeSiteManquant(Structure_Contrat.ContratWrapper ctr) {
        Structure_Contrat.MessageRetour messageRetour = new Structure_Contrat.MessageRetour();
        messageRetour.message = 'Le code site est obligatoire';
        messageRetour.nContrat=ctr.noPosition;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    /*
    public static Structure_Contrat.MessageRetour clientManquant(Structure_Contrat.ContratWrapper ctr) {
        Structure_Contrat.MessageRetour messageRetour = new Structure_Contrat.MessageRetour();
        messageRetour.message = 'Client manquant: Le site n\'est associé à aucun client';
        messageRetour.nContrat=ctr.noPosition;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }*/
    public static Structure_Contrat.MessageRetour nContratManquant(Structure_Contrat.ContratWrapper ctr) {
        Structure_Contrat.MessageRetour messageRetour = new Structure_Contrat.MessageRetour();
        messageRetour.message = 'Le N de contrat est obligatoire';
        messageRetour.nContrat=ctr.noPosition;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    
    public static List<BS_Devis_from_Lead__c> getProposition(Structure_Contrat.ContratWrapper ctr) {
        List<BS_Devis_from_Lead__c> propo = [SELECT   Id, BS_N_Devis__c	
                                                      FROM 	BS_Devis_from_Lead__c 
                                                      WHERE BS_N_Devis__c = :ctr.idLeadCRM];
        return propo;
    }

    
}