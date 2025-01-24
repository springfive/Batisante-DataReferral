@isTest(SeeAllData = true)
public class TestsAvantMEP {
    
    public static BS_Devis_from_Lead__c insertDp(Id recordType) {
        Schema.Location site = insertSite('Velvet Test', 'AZURid');
        BS_Devis_from_Lead__c dp = new BS_Devis_from_Lead__c();
        dp.Email_Prospect__c = 'test@test.com';
        dp.Ref_Client__c = 'testRef';
        dp.RecordTypeId = recordType;
        dp.Adresse_Site__c = '666 av Test';
        dp.Devis_g_n_r__c = false;
        dp.Name = 'Eloïse GUERIN - Devis Lead - n°201';
        dp.Etat2__c = 'Transmis';
        dp.Piste_del__c = insertLead().Id;
        dp.Contact_Soci_t__c = 'contact TEST';
        dp.Emplacement__c = site.Id;
        dp.Nom_Soci_t__c = 'Velvet Test';
        
        
        insertContact(site.BS_Client__c);
        updateContact();
        
        insert dp;
        return dp;
    }
    
    public static BS_Devis_from_Lead__c insertDpNull(Id recordType) {
        BS_Devis_from_Lead__c dp = new BS_Devis_from_Lead__c();
        dp.Email_Prospect__c = 'test@test.com';
        dp.RecordTypeId = recordType;
        dp.Devis_g_n_r__c = false;
        dp.Name = 'Eloïse GUERIN - Devis Lead - n°201';
        dp.Etat2__c = 'Transmis';
        dp.Piste_del__c = insertLead().Id;
        dp.Emplacement__c = insertSite('Test autre', 'azur autre').Id;
        dp.Nom_Soci_t__c = 'Velvet Test';
        
        insert dp;
        return dp;
    }
    static Lead insertLead() {
        Lead lead = new Lead();
       // lead.RecordTypeId = '0127Z000001IssrQAC'; //FOR SANDBOX
        lead.RecordTypeId = '0123X000000SP4OQAW'; //FOR PROD
        lead.Company = 'Test comp';
        lead.Fonction__c = 'DAF';
        lead.Status = 'Qualification';
        lead.Source__c = 'Appel entrant';
        lead.SIRET__c = '45132382811111';
        lead.LastName = 'TEST';
        
        
        insert lead;
        return lead;
    }
    
    public static List<Dictionnaire_Prestations__c> insertDicos() {
        List<Dictionnaire_Prestations__c> dicos = new List<Dictionnaire_Prestations__c>();
        Dictionnaire_Prestations__c dico = new Dictionnaire_Prestations__c();
        dico.Name = '2105 - Prévention - Surveillance rongeurs avec poste(s) d\'appâtage connecté(s)';
        dico.Description_courte__c = '- Traitement par insecticide selon protocole établi : pulvérisation ou nébulisation';
        dico.Lien_vers_description__c = 'www.google.com';
        dico.Titre_du_PDF__c = '2105 - Prévention - Surveillance rongeurs avec poste(s) d\'appâtage connecté(s)';
        dico.Coef_Min_Commerciaux__c = 0;
        dico.Coef_Min_Managers__c = 0;
        dico.Cout_de_l_installation__c = 0;
        dico.Nombre_de_passages_annuels__c = 1;
        dico.Nombre_de_mois_contractuel__c = 12;
        dico.Colonnes_Prestations_du_PDF__c = 'PERIODICITE;GARANTIE';
        insert dico;
        
        Parametre_de_lot__c lotParam = new Parametre_de_lot__c();
        lotParam.Dictionnaire_Prestations__c = dico.Id;
        lotParam.Equivalent_en_lots__c = 1;
        lotParam.Intitul_PDF__c = 'Lot';
        lotParam.Name = 'Cage';
        lotParam.Niveau_contrat__c = false;
        lotParam.Obligatoire__c = false;
        
        insert lotParam;
        
        Parametre_de_lot__c lotParam2 = new Parametre_de_lot__c();
        lotParam2.Dictionnaire_Prestations__c = dico.Id;
        lotParam2.Equivalent_en_lots__c = 1;
        lotParam2.Intitul_PDF__c = 'Chambre';
        lotParam2.Name = 'Chambre';
        lotParam2.Niveau_contrat__c = false;
        lotParam2.Obligatoire__c = true;
        
        insert lotParam2;
        dicos.add(dico);
        
        dico = new Dictionnaire_Prestations__c();
        dico.Name = 'Dératisation extérieure';
        dico.Description_courte__c = '- Traitement par insecticide selon protocole établi : pulvérisation ou nébulisation';
        dico.Lien_vers_description__c = 'www.google.com';
        
        dico.Titre_du_PDF__c = 'Dératisation extérieure';
        dico.Coef_Min_Commerciaux__c = 0;
        dico.Coef_Min_Managers__c = 0;
        dico.Cout_de_l_installation__c = 0;
        dico.Nombre_de_passages_annuels__c = 1;
        dico.Nombre_de_mois_contractuel__c = 12;
        
        insert dico;
        dicos.add(dico);
        
        dico = new Dictionnaire_Prestations__c();
        dico.Name = '2322 - Désinsectisation parties communes et parties privatives';
        
        insert dico;
        dicos.add(dico);
        
        return dicos;
    }
    
    static Account insertAccount(String Name, String IdAzur) {
        
        Account account = new Account();
        account.name = Name;
        account.BS_Id_ClientAzur__c = IdAzur;
        
        insert account;
        return account;
    }
    
    static Schema.Location insertSite(String Name, String IdAzur) {
        Schema.Location site = new Schema.Location();
        site.BS_Code_Site__c = Name;
        site.BS_Ref_Client__c = IdAzur;
        Site.name='TestTestTestTest';
        site.BS_Client__c = insertAccount(Name, IdAzur).Id;
        
        insert site;
        return site;
    }
    
    static Contact insertContact(Id accountId) {
        Contact contact = new contact();
        contact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact Client').getRecordTypeId(); //0123X0000015vK2QAI
        contact.BS_Principal__c = True;
        contact.AccountId = accountId;
        contact.LastName = 'Test';
        contact.BS_Id_Contact_Azur__c = 'TestAZURID';
        
        insert contact;
        return contact;
    }
    
    static list<Contact> updateContact(){
        list<Contact> listecontact=[select id, name from Contact where name='JIREL'];
        update listecontact;
        return listecontact;
        
    }
    
    @isTest static void testinsertProp() {
        ID nullDP = insertDpNull(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
    }
    
    @isTest
    static void testTRG_presta() {
        ID dpID = insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        List<Dictionnaire_Prestations__c> dicos = insertDicos();
        Prestation__c presta = new Prestation__c();
        presta.Libell__c = 'Désinsectisation - Insectes volants';
        presta.Prix_Unitaire_HT__c = 120;
        presta.Devis_Pistes__c = dpID;
        presta.P_le__c = 'Hygiène';
        
        Prestation__c presta2 = new Prestation__c();
        presta2.Libell__c = 'Dératisation extérieure';
        presta2.Prix_Unitaire_HT__c = 120;
        presta2.Devis_Pistes__c = dpID;
        presta2.P_le__c = 'Hygiène';
       // presta2.Dictionnaire_Prestations__c = dicos[1].Id;
        
        List<Prestation__c> prestas = new List<Prestation__c>();
        prestas.add(presta); 
        prestas.add(presta2);
        insert prestas;
    }
        
    @isTest
    static void testTRG_presta2() {
        Prestation__c presta = new Prestation__c();
        presta.Libell__c = 'Dératisation extérieure';
        presta.Prix_Unitaire_HT__c = 120;
        presta.Devis_Pistes__c = insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        presta.P_le__c = 'Hygiène';
        
        insert presta;
    }
    @isTest
    static void testTRG_presta3() {
        
        Prestation__c presta2 = new Prestation__c();
        presta2.Libell__c = 'Dératisation extérieure';
        presta2.Prix_Unitaire_HT__c = 120;
        presta2.Devis_Pistes__c = insertDp(Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId()).Id; //0127a000001UsahAAC
        presta2.P_le__c = 'Hygiène';
      //  presta2.Dictionnaire_Prestations__c = 'a0s7Z000007qY1wQAE';
        insert presta2;
    }
    
    @isTest
    static void testTRG_Task() {
        Task task = new Task();
        task.RecordTypeId = '0123X000000SP4sQAG'; //FOR PROD
       // task.RecordTypeId = '0127Z000001Iu1LQAS'; //FOR SANDBOX
        task.subject = 'Email TEST';
        task.ActivityDate = Date.newInstance(2021, 11, 4);
        //task.OwnerId = '0053X00000D3llsQAB';
        task.Status = 'Ouvert';
        insert task;
    }
    
    
        @isTest
    static void testTRG_Task2() {
        Task task = new Task();
        //task.RecordTypeId = '0127Z000001Iu1LQAS'; //FOR SANDBOX
        task.RecordTypeId = '0123X000000SP4sQAG'; //FOR PROD
        task.subject = 'TEST'; 
        task.Status = 'Ouvert';
       
        insert task;
    }
    /*
    @isTest
    static void testEnrichData() {
        Lead lead = new Lead();
        lead.RecordTypeId = '0127Z000001IsshQAC';
        lead.Company = 'Test comp';
        lead.Fonction__c = 'DAF';
        lead.Status = 'Qualification';
        lead.Type__c = 'Suspect';
        lead.Source__c = 'Appel entrant';
        lead.SIRET__c = '45132382811111';
        lead.LastName = 'TEST';        
        insert lead;
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        
        ApexPages.StandardController stdLead = new ApexPages.StandardController(lead);
        
        EnrichCompaniesDatas e = new EnrichCompaniesDatas(stdLead);
       
        e.getBearer();
        
        e.getCompaniesDataFromInsee();
        e.enrichCompanyFromSiret();
        e.updateCompanyInfoFromSiret();
        e.initCompaniesList();
        e.updateCompanyInfoFromName();
        e.goToChooseField();
        e.getCompanies();
        e.getFields();
        
        System.assert(e.getLeadId() == lead.Id);
        
        
    }*/
    
   /* @isTest
    static void testSaveDevisPDF() {
        BS_Devis_from_Lead__c dp = new BS_Devis_from_Lead__c();
        dp.Email_Prospect__c = 'test@test.com';
        dp.Contact_Soci_t__c = 'test';
        dp.Adresse_Site__c = '666 av Test';
        dp.Devis_g_n_r__c = false;
        dp.Name = 'Eloïse GUERIN - Devis Lead - n°201';
        dp.Etat2__c = 'Transmis';
        dp.Statut__c = 'Devis';
        dp.Piste_del__c = '00Q7Z000009vFuwUAE';
        dp.Contact_Soci_t__c = 'contact TEST';
        
        insert dp;
          
        ApexPages.StandardController stdDevisProspect= new ApexPages.StandardController(dp);
        
        saveDevisPDF save = new saveDevisPDF(stdDevisProspect);
        
        System.assert(save.getDevisId() == dp.Id);
        
        save.savePDF();
        
    }
    */
        @isTest
    static void testDevisLeadExt() {
        BS_Devis_from_Lead__c dp = new BS_Devis_from_Lead__c();
        dp.Email_Prospect__c = 'test@test.com';
        dp.P_le__c = 'Sécurité incendie';
        dp.Contact_Soci_t__c = 'test';
        dp.Adresse_Site__c = '666 av Test';
        dp.Devis_g_n_r__c = false;
        dp.Name = 'Eloïse GUERIN - Devis Lead - n°201';
        dp.Etat2__c = 'Transmis';
        dp.Statut__c = 'Devis';
        dp.Piste_del__c = insertLead().Id;
        dp.Contact_Soci_t__c = 'contact TEST';
        
        insert dp;
          
        ApexPages.StandardController stdDevisProspect= new ApexPages.StandardController(dp);
        
        devisLeadExtention save = new devisLeadExtention(stdDevisProspect);
        
        System.assert(save.getPrestasSize() == 0);
        
        save.getPrestas();
        save.getPrestaDico();
        System.assert(save.getImageHeight() == 54);
        
    }
    
    
        
        @isTest
    static void testDevisLeadExtWithPresta() {
      Lead lead = insertLead();
        List<Dictionnaire_Prestations__c> dicos = insertDicos();
        
        BS_Devis_from_Lead__c dp = new BS_Devis_from_Lead__c();
        dp.Email_Prospect__c = 'test@test.com';
        dp.P_le__c = 'Hygiène';
        dp.Contact_Soci_t__c = 'test';
        dp.Adresse_Site__c = '666 av Test';
        dp.Devis_g_n_r__c = false;
        dp.Name = 'Eloïse GUERIN - Devis Lead - n°201';
        dp.Etat2__c = 'Transmis';
        dp.Statut__c = 'Devis';
        dp.Piste_del__c =  lead.Id;
        dp.Contact_Soci_t__c = 'contact TEST';
        insert dp;
          
        Prestation__c presta2 = new Prestation__c();
        presta2.Libell__c = dicos[0].Name;
        presta2.Name = dicos[0].Name;
        presta2.Prix_Unitaire_HT__c = 120;
        presta2.Devis_Pistes__c = dp.Id;
        presta2.P_le__c = 'Hygiène';
       // presta2.Dictionnaire_Prestations__c = dicos[0].Id;
        presta2.Option__c = false;
        insert presta2;
        
        ApexPages.StandardController stdDevisProspect= new ApexPages.StandardController(dp);
        
        devisLeadExtention save = new devisLeadExtention(stdDevisProspect);
        
        System.assert(save.getrefClient());
        System.assert(save.getImageHeight() == 45.5);
        System.assert(save.getPrestasSize() == 1);
        save.getPrestaDico();
        
    }
    
    @isTest static void deleteProp() {
        BS_Devis_from_Lead__c dp = new BS_Devis_from_Lead__c();
        dp.Email_Prospect__c = 'test@test.com';
        dp.Contact_Soci_t__c = 'test';
        dp.Adresse_Site__c = '666 av Test';
        dp.Devis_g_n_r__c = false;
        dp.Name = 'Eloïse GUERIN - Devis Lead - n°201';
        dp.Etat2__c = 'Transmis';
        dp.Statut__c = 'Devis';
        dp.Contact_Soci_t__c = 'contact TEST';
        dp.RecordTypeId = Schema.SObjectType.BS_Devis_from_Lead__c.getRecordTypeInfosByName().get('Contrat').getRecordTypeId();
        insert dp;
        ApexPages.StandardController stdDevisProspect= new ApexPages.StandardController(dp);
        deletePropositionExt dlt = new deletePropositionExt(stdDevisProspect);
        dlt.deleteProp();
        dlt.DeletePropAfterConfirm();
        dlt.getEtat();
        dlt.getPropId();
        dlt.getPropName();
    }
}