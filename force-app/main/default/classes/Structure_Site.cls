/**
* @author Amine SARBOUTE
* @date 14/07/2020
* @description Structure_Site : Wrapper Site, Gestion des erreurs et requêtes
*/
global with sharing class Structure_Site{
    global virtual class MessageRetour {
        
        public  MessageRetour () {
            
        }
        
        //identifiant du compte Azur
        webservice String  IdSiteAZ { get; set; }
        webservice integer codeErreur { get; set; }
        webservice String  message { get; set; }
        webservice String  IdSFDC { get; set; }
        webservice Structure_Site.SiteWrapper site { get; set; }
        
    }
    global class SiteWrapper{
        webservice String  type { get; set; }//recordtype : site, lieu =>OK
        webservice String  idClientAzur { get; set; } //=>OK + nom client par transco OK
        webservice String  codeSiteAz { get; set; }//external id =>OK
        webservice String  noVoie{ get; set; } // =>OK
        webservice String  typeVoie{ get; set; } // =>OK
        webservice String  nomVoie{ get; set; } //=>OK
        webservice String  complementAdr{ get; set; }//=>OK
        webservice String  codePostal{ get; set; }//=>OK
        webservice String  ville{ get; set; }//=>OK
        webservice String  nomResidence{ get; set; }//=>OK
        webservice String  HAB{ get; set; }//=>OK
        webservice String  ERT{ get; set; }//=>OK
        webservice String  ERP{ get; set; }//=>OK
        webservice String  IGH{ get; set; }//=>OK
        webservice String  ZAR{ get; set; }//=>OK
       // webservice String  situation{ get; set; }//=>OK
       // webservice String  CodeIRIS{ get; set; }//=>OK
       // webservice String  origine{ get; set; }//=>OK
       // webservice String  pole{ get; set; }//=>OK
        webservice String  dateCreationAzur{ get; set; }//=>OK
       // webservice String  auteur{ get; set; }//=>OK
        webservice String  acces{ get; set; }//=>OK
        webservice String  dateChangSyndic{ get; set; }//=>OK
        webservice String  ancienClient{ get; set; }//=>OK
        webservice String  refClient{ get; set; }//=>OK
       // webservice String  representePar{ get; set; }//=>OK
       // webservice String  total{ get; set; }//=>OK
       // webservice String  dateAttestation{ get; set; }//=>OK
        webservice String  nbCagesEsc{ get; set; }//=>OK
        webservice String  LOT{ get; set; }//=>OK
        webservice String  niveau{ get; set; }//=>OK
        webservice String  nbPlacesParking{ get; set; }//=>OK
        webservice String  nbAcenseurs{ get; set; }//=>OK
        webservice String  nomAscensoriste{ get; set; }//=>OK
        //webservice String  montantImpayes{ get; set; }//=>OK
        //webservice String  montantAvoirs{ get; set; }//=>OK
        webservice String  montantResil{ get; set; }//=>OK
        webservice String  adresseLieu{ get; set; }//=>OK
        webservice String  dateVisite{ get; set; }//=>OK
        webservice String  dateCreationVisite{ get; set; }//=>OK
        webservice String  datePrevueVisite{ get; set; }//=>OK
        //webservice String  siteParent{ get; set; }
        webservice String  caChristal{ get; set; }//=>OK
        webservice String  caSagex{ get; set; }//=>OK
        webservice String  caStech{ get; set; }//=>OK
        webservice String  CaDiag{ get; set; }//=>OK
        webservice String  montantOffresEnCours{ get; set; }//=>OK
        webservice String  portfeuilleContractuel{ get; set; }//=>OK 
        webservice String  nbContratsC{ get; set; }
        webservice String  nbContratsS{ get; set; }
        webservice String  nbContratsK{ get; set; }
        webservice String  nbContratsR{ get; set; }
        webservice String  nbContratsO{ get; set; }
        //webservice String  caGlobal{ get; set; }//=>OK
    }
    
    public static list<BS_Site__c> getSiteByCodeSite(Structure_Site.SiteWrapper ste){
        List<BS_Site__c> sites=[SELECT id, RecordTypeId, BS_Id_Client_Azur__c,BS_Client__c, BS_Code_Site__c, BS_N__c,
                                BS_Type_voie__c, BS_Nom_voie__c, BS_Complement__c, BS_Code_Postal__c, BS_Ville__c,
                                BS_Nom_residence__c, BS_HAB__c, BS_ERT__c, BS_ERP__c, BS_IGH__c, BS_ZAR__c, BS_Situation__c,
                                BS_Code_IRIS__c, BS_Origine__c, BS_Date_creation_Azur__c, BS_Auteur_Azur__c, BS_Acces__c,
                                BS_Date_changement_Syndic__c, BS_Ancien_client__c, BS_Ref_Client__c, BS_Facture_represente_par__c,
                                BS_Date_attestation__c, BS_LOT__c, BS_Niveau__c, BS_Nb_places_parking__c, BS_Nb_ascenseurs__c,
                                BS_Nom_ascensoriste__c, BS_Montant_resiliations_3M__c, BS_Adresse_lieu_L1__c, BS_Total__c, BS_nb_cages_escaliers__c,
                                BS_Date_visite__c, BS_Date_prevue_visite__c, BS_Date_creation_visite__c, BS_Client__r.name,
                                BS_CA_Christal__c, BS_CA_Diag__c, BS_CA_Sagex__c, BS_CA_ST__c, BS_Montant_offres_en_cours__c,
                                BS_Nombre_de_contrats_en_C__c, BS_Nombre_de_contrats_en_K__c, BS_Nombre_de_contrats_en_O__c,
                                BS_Nombre_de_contrats_en_R__c, BS_Nombre_de_contrats_en_S__c,
                                BS_Portfeuille_Contractuel__c/*, BS_Chiffre_affaires_global__c*/
                          		FROM BS_Site__c WHERE BS_code_site__c= :ste.codeSiteAz];
        return sites;
    }
    /*public static list<BS_Site__c> getSiteParentByCodeSiteAzur(Structure_Site.SiteWrapper ste){
        List<BS_Site__c> sitesParent=[SELECT id, BS_Code_Site__c
                                FROM BS_Site__c WHERE BS_code_site__c= :ste.siteParent];
        return sitesParent;
    }*/
    public static list<Account> getClientByIdClientAzur(Structure_Site.SiteWrapper ste){
        List<Account> comptes=[SELECT id FROM Account WHERE BS_Id_ClientAzur__c= :ste.idClientAzur];
        return comptes;
    }
    public static Structure_Site.MessageRetour typeSiteInvalide(Structure_Site.SiteWrapper ste) {
        Structure_Site.MessageRetour messageRetour = new Structure_Site.MessageRetour();
        messageRetour.message = 'Le Type Site est erronné. Valeurs possibles : Lieu, Site; ';
        messageRetour.IdSiteAZ=ste.codeSiteAz;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Site.MessageRetour idClientAzInvalide(Structure_Site.SiteWrapper ste) {
        Structure_Site.MessageRetour messageRetour = new Structure_Site.MessageRetour();
        messageRetour.message = 'L\'id Client Azur ne correspond à aucun client dans SFDC; ';
        messageRetour.IdSiteAZ=ste.codeSiteAz;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Site.MessageRetour idClientAzurManquant(Structure_Site.SiteWrapper ste) {
        Structure_Site.MessageRetour messageRetour = new Structure_Site.MessageRetour();
        messageRetour.message = 'L\'id client Azur est obligatoire; ';
        messageRetour.IdSiteAZ=ste.codeSiteAz;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Site.MessageRetour typeSiteManquant(Structure_Site.SiteWrapper ste) {
        Structure_Site.MessageRetour messageRetour = new Structure_Site.MessageRetour();
        messageRetour.message = 'Le Type du site est obligatoire. Valeurs possibles: Site, Lieu; ';
        messageRetour.IdSiteAZ=ste.codeSiteAz;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Site.MessageRetour codeSiteManquant(Structure_Site.SiteWrapper ste) {
        Structure_Site.MessageRetour messageRetour = new Structure_Site.MessageRetour();
        messageRetour.message = 'Le code du site est obligatoire ';
        messageRetour.IdSiteAZ=ste.codeSiteAz;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    
    

}