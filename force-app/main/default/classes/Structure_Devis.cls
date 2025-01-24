/**
* @author Amine SARBOUTE
* @date 20/07/2020
* @description Structure_Devis : Wrapper Devis, Gestion des erreurs et requêtes
*/
global with sharing class Structure_Devis {

    global virtual class MessageRetour {
        
        public  MessageRetour () {
            
        }
        
        //identifiant du compte Azur
        webservice String  nOpe { get; set; }
        webservice integer codeErreur { get; set; }
        webservice String  message { get; set; }
        webservice String  IdSFDC { get; set; }
        webservice Structure_Devis.DevisWrapper devis { get; set; }
        
    }
    global class DevisWrapper{
        webservice String nOpe { get; set; } //clé externe =>OK
        webservice String typeOpe { get; set; }//=>OK (transco typeOpé en Type1 et Type2)
        webservice String nTicket { get; set; }//OK
        webservice String societe { get; set; }//OK
        webservice String pole { get; set; }//OK
        webservice String origine { get; set; }//OK
        webservice String tech { get; set; }//OK
        webservice String managerTech { get; set; }//OK
        webservice String societeTech { get; set; }//OK
        webservice String creeLe { get; set; }//OK
        webservice String modifieLe { get; set; }//OK
        webservice String dateAnnul { get; set; }//OK
        webservice String datePerdu { get; set; }//OK
        webservice String dateAccord { get; set; }//OK
        webservice String montantTotal { get; set; }//OK
        webservice String codeSite { get; set; }//OK + Alimentation Champ site
        webservice String designation { get; set; } //OK
        webservice String creePar { get; set; }
        webservice String InfoCom { get; set; }
        webservice String AuteurRapport { get; set; }
        webservice String idLeadCRM {get; set;}//to test, link to proposition
        //webservice String statut { get; set; }=> plus besoin de ce champ.Statut Calculé dans SFDC en se basant sur les différentes dates.
    }
    public static list<BS_Devis__c> getDevisByNOpe(Structure_Devis.DevisWrapper dv){
        List<BS_Devis__c> devis=[SELECT id, BS_N_Ope__c, BS_Type_Ope__c, BS_Type1__c, BS_Type2__c, BS_N_Ticket__c, Name,
                                 BS_Societe__c, BS_Pole__c, BS_Origine1__c, BS_Origine__c, BS_DET__c, BS_Tech__c, BS_Manager_Tech__c,
                                 BS_Societe_Tech__c, BS_Cree_le_Azur__c, BS_Modifie_le_Azur__c, BS_Date_Perdu__c, BS_Date_Annul__c,
                                 BS_Date_Accord__c, BS_Total_HT__c, BS_Code_Site__c, BS_Nom_Client__c, BS_Contact__c, BS_Emplacement__c,
                                 BS_Cree_par_Azur__c, BS_Devis_cree_par_Azur__c, BS_Info_Com__c, Auteur_Rapport__c
                                 FROM BS_Devis__c WHERE BS_N_Ope__c= :dv.nOpe];
        return devis;
    }
    public static list<user> getUserByCreePar(String creePar){
        List<user> OwnerDevis=[SELECT id,Profile.name
                               FROM user WHERE BS_Trigramme__c= :creePar];
        return OwnerDevis;
    }
    public static list<Schema.Location> getSiteAndClientByCodeSite(String codeSite){
        List<Schema.Location> site=[SELECT id, BS_Code_Site__c, BS_Client__c 
                               FROM Location WHERE BS_Code_Site__c= :codeSite];
        return site;
    }
    public static list<Contact> getGestionnaireByIdClient(String idClient){
        List<Contact> contact=[SELECT id, AccountId, BS_Typologie__c, BS_Principal__c
                               FROM Contact WHERE AccountId= :idClient AND RecordType.DeveloperName='BS_Contact_Client' AND BS_Principal__c=True AND BS_Typologie__c = 'Gestionnaire'];
        return contact;
    }
    public static List<BS_Typologie_Devis__mdt> transcoFromTypOpe(Structure_Devis.DevisWrapper dv) {
        List<BS_Typologie_Devis__mdt> mdtTypeOpe = [SELECT MasterLabel, QualifiedApiName, BS_Type_ope__c, BS_Type1__c, BS_Type2__c
                                                    FROM BS_Typologie_Devis__mdt 
                                                    WHERE BS_Type_ope__c = :dv.typeOpe];
        return mdtTypeOpe;
    }
    public static List<BS_Origine__mdt> transcoFromOrigineAz(Structure_Devis.DevisWrapper dv) {
        List<BS_Origine__mdt> mdtOrigine = [SELECT MasterLabel, QualifiedApiName, BS_DET__c, BS_Origine__c, BS_Origine1__c  
                                            FROM BS_Origine__mdt 
                                            WHERE BS_Origine1__c = :dv.origine];
        return mdtOrigine;
    }
    public static Structure_Devis.MessageRetour codeSiteInvalide(Structure_Devis.DevisWrapper dv) {
        Structure_Devis.MessageRetour messageRetour = new Structure_Devis.MessageRetour();
        messageRetour.message = 'Le code site ne correspond à aucun site';
        messageRetour.nOpe=dv.nOpe;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Devis.MessageRetour codeSiteManquant(Structure_Devis.DevisWrapper dv) {
        Structure_Devis.MessageRetour messageRetour = new Structure_Devis.MessageRetour();
        messageRetour.message = 'Le code site est obligatoire';
        messageRetour.nOpe=dv.nOpe;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Devis.MessageRetour nOpeManquant(Structure_Devis.DevisWrapper dv) {
        Structure_Devis.MessageRetour messageRetour = new Structure_Devis.MessageRetour();
        messageRetour.message = 'Le n° Opé est obligatoire';
        messageRetour.nOpe=dv.nOpe;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    
    public static List<BS_Devis_from_Lead__c> getProposition(Structure_Devis.DevisWrapper dv) {
        List<BS_Devis_from_Lead__c> propo = [SELECT   Id, BS_N_Devis__c 
                                                      FROM  BS_Devis_from_Lead__c 
                                                      WHERE BS_N_Devis__c = :dv.idLeadCRM];
        return propo;
    }
    
}