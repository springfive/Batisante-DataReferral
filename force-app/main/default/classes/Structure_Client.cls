/**
* @author Amine SARBOUTE
* @date 14/06/2020
* @description Structure_Client : Wrapper Compte, Gestion des erreurs et requêtes
*/
global with sharing class Structure_Client {
    
    global virtual class MessageRetour {
        
        public  MessageRetour () {
            
        }
        
        //identifiant du compte Azur
        webservice String  IdClientAZ { get; set; }
        webservice integer codeErreur { get; set; }
        webservice String  message { get; set; }
        webservice String  IdSFDC { get; set; }
        webservice Structure_Client.CompteWrapper compte { get; set; }
        
    }
    
    global class CompteWrapper{
        webservice String nomClient { get; set; } //OK
        webservice Boolean PDS{ get; set; } //OK
        webservice String ActiviteADB { get; set; } //OK
        //webservice String Segment { get; set; } //géré dans SFDC
        webservice String Mobile { get; set; } //OK
        webservice String ClientReserve { get; set; } //OK
        webservice String CodeClient { get; set; } //OK
        webservice String TypeClient { get; set; } //OK Record Type (ADB,CFE)
        webservice String ActiviteCFE { get; set; } //OK
        webservice String IdClientAzur { get; set; } //OK
        //New fields
        //webservice String Type { get; set; } //Client ou prospect Géré dans SFDC
        webservice String Groupe { get; set; } //OK
        //webservice String NbGardiensEmployesImmeuble { get; set; }//Géré dans SFDC
        webservice String NbImmeubleGeres { get; set; } //Géré dans SFDC
        webservice String Region { get; set; } //OK
        webservice String CodePostalAP { get; set; }//OK
        webservice String VilleAP { get; set; }//OK
        webservice String CodePostalAF { get; set; }//OK
        webservice String VilleAF { get; set; }//OK
        webservice String Telephone { get; set; }//OK
        webservice String Fax { get; set; }//OK
        webservice String AdresseMail { get; set; }//OK
        webservice String NSiret { get; set; }//OK
        webservice String ClientARisque { get; set; } //OK
        webservice String VendeurMP { get; set; }// OK + gestionnaire clientèle associé			
        webservice String VendeurSolutionTech { get; set; } //En attente retour BS
        webservice String VendeurPE { get; set; } //OK
        webservice String Adr1AF { get; set; } // correspond à champ 'Rue de facturation' dans sfdc //OK
        webservice String Adr2AF { get; set; } // Complément à concaténer avec Adr1AF //OK
        webservice String Adr1AP { get; set; } // correspond à champ 'Rue d'expédition' dans sfdc //OK
        webservice String Adr2AP { get; set; } // Complément à concaténer avec Adr1AP //OK
        webservice String CreeLeAzur { get; set; } //OK
        webservice String ModifieLeAzur { get; set; } //OK
        webservice String DateconvPEsignee { get; set; }//OK 
        webservice String DateResiliationConvPE { get; set; }//OK
        webservice String DateConvASSsignee { get; set; } //OK
        webservice String DateResiliationConvASS { get; set; }//OK
        webservice String idAdresse { get; set; }//OK
        webservice String MontantImpayes { get; set; }
        webservice String MontantAvoirs { get; set; }
        //webservice String MontantResil { get; set; }
        /*webservice String caChristal { get; set; }
        webservice String caSagex { get; set; }
        webservice String caStech { get; set; }
        webservice String caDiag { get; set; }
        webservice String caGlobal { get; set; }*/
        // webservice String GestionnaireClientele { get; set; } //inutile correspondance user CO =>gestionnaire
    } 
    
    
    public static List<Account> getClientByIdClientAzur(Structure_Client.CompteWrapper cpte) {
        
        List<Account> comptes=[SELECT id,name, BS_Id_ClientAzur__c, BS_Code_client__c, BS_Activite__c, BS_Segment__c, 
                               BS_Client_reserve__c, Phone, BS_PDS__c, BS_Region__c, BillingStreet, BillingCity, BS_Activite_ADB__c,
                               OwnerId, BS_Code_Vendeur__c,BS_Code_Vendeur_ind__c,/*LMS Ajout code vendeur tech*/ BillingPostalCode, ShippingStreet, ShippingCity, BS_Groupe__c,
                               ShippingPostalCode, BS_Telephone_2__c, BS_Fax__c, BS_Adresse_mail__c, BS_N_SIRET__c,
                               BS_Client_a_risque__c, BS_Cree_le_Azur__c, BS_Modifie_le_Azur__c, BS_Vendeur_PE__c, 
                               BS_Vendeur_Solution_technique__c, BS_Date_convention_PE_signee__c, RecordTypeId,
                               BS_Date_resiliation_convention_ASS__c, BS_Date_resiliation_convention_PE__c,
                               BS_Date_convention_ASS_signee__c, BS_ID_Adresse__c, BS_Montant_des_impayes__c, 
                               BS_Montant_des_avoirs__c/*, BS_Montant_des_resiliations__c, BS_Chiffre_affaires_Christal__c,
                               BS_Chiffre_affaires_global__c, BS_Chiffre_affaires_Sagex__c, BS_Chiffre_affaires_Solutions_techniques__c,
                               BS_CA_Diagnotics_controles__c*/
                               FROM account 
                               WHERE BS_Id_ClientAzur__c= :cpte.IdClientAzur];
        
        return comptes;
    }
    
    public static List<user> getVendeurMPByTrigramme(String codeVendeur) {
        if (String.isBlank(codeVendeur) || String.isEmpty(codeVendeur))
            return new List<User>();
        
        List<user> VendeursMP=[SELECT id, name, BS_Gestionnaire_de_clientele__c, BS_Trigramme__c 
                               FROM user 
                               WHERE BS_Trigramme__c= :codeVendeur
                               AND IsActive = true ];
        return VendeursMP;
    }
    
    public static List<user> getVendeurPEByTrigramme(Structure_Client.CompteWrapper cpte) {
        if (String.isBlank(cpte.VendeurPE) || String.isEmpty(cpte.VendeurPE))
            return new List<User>();
        
        List<user> VendeursPE=[SELECT id, name, BS_Trigramme__c 
                               FROM user 
                               WHERE BS_Trigramme__c= :cpte.VendeurPE
                               AND IsActive = true];
        return VendeursPE;
    }
    
    public static List<user> getVendeurSTByTrigramme(Structure_Client.CompteWrapper cpte) {
        if (String.isBlank(cpte.VendeurSolutionTech) || String.isEmpty(cpte.VendeurSolutionTech))
            return new List<User>();
        
        List<user> VendeursST=[SELECT id, name, BS_Trigramme__c 
                               FROM user 
                               WHERE BS_Trigramme__c= :cpte.VendeurSolutionTech
                               AND IsActive = true];
        return VendeursST;
    }
    //avoir le gestionnaire du vendeur indispensable
    public static List<user> getVendeurSTGestinnaireByTrigramme(Structure_Client.CompteWrapper cpte) {
      if (String.isBlank(cpte.VendeurSolutionTech) || String.isEmpty(cpte.VendeurSolutionTech))
            return new List<User>();
        
        List<user> VendeursSTgestionnaire=[SELECT id, name, BS_Gestionnaire_de_clientele__c, BS_Trigramme__c 
                               FROM user 
                               WHERE BS_Trigramme__c= :cpte.VendeurSolutionTech
                               AND IsActive = true ];
        
        
        System.debug('lynda bug nnnnnnnn'+VendeursSTgestionnaire.size());
        return VendeursSTgestionnaire;  
    }
    
    public static List<ActivitesSegments__mdt> transcoFromActiviteAzur(Structure_Client.CompteWrapper cpte) {
        List<ActivitesSegments__mdt> mdtActivSeg = [SELECT MasterLabel, QualifiedApiName, Activite_Azur__c,
                                                    Activite_SFDC__c,Segment_SFDC__c
                                                    FROM ActivitesSegments__mdt 
                                                    WHERE Activite_Azur__c = :cpte.ActiviteCFE];
        return mdtActivSeg;
    }
    
    public static Structure_Client.MessageRetour idClientAzurManquant(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'L\'id client Azur est obligatoire; ';
        messageRetour.IdClientAZ='';
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Client.MessageRetour nomClientmanquant(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Le nom du client est obligatoire; ';
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    /*
    public static Structure_Client.MessageRetour codeVendeurMPManquant(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Le code Vendeur MP est obligatoire; ';
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Client.MessageRetour codeVendeurMPInvalide(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Code Vendeur MP non reconnu; ';
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Client.MessageRetour codeVendeurSTManquant(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Le code Vendeur ST est obligatoire; ';
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Client.MessageRetour codeVendeurSTInvalide(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Code Vendeur ST non reconnu; ';
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }*/
    public static Structure_Client.MessageRetour typeClientInvalide(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Type client=> Valeurs possibles : ADB, CFE, CFE IMMO, B2C; ';
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Client.MessageRetour typeClientmanquant(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Le type du client est obligatoire; ';
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
   /* public static Structure_Client.MessageRetour formatMobileInvalide(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Mobile: Le format n\'est pas valide; ' ;
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur =401;
        return messageRetour;
    }
    public static Structure_Client.MessageRetour formatTelephoneInvalide(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Telephone: Le format n\'est pas valide; ' ;
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur =401;
        return messageRetour;
    }
    public static Structure_Client.MessageRetour formatEmailInvalide(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'AdresseMail: Le format n\'est pas valide; ' ;
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur =401;
        return messageRetour;
    }*/
    public static Structure_Client.MessageRetour codeClientReserveInvalide(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'ClientReserve => Valeurs possibles :F, U; ' ;
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur =401;
        return messageRetour;
    }
    public static Structure_Client.MessageRetour codeRegionInvalide(Structure_Client.CompteWrapper cpte) {
        Structure_Client.MessageRetour messageRetour = new Structure_Client.MessageRetour();
        messageRetour.message = 'Region=> Valeurs possibles :0, 1, 2, 3 ' ;
        messageRetour.IdClientAZ=cpte.IdClientAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur =401;
        return messageRetour;
    }
    
}