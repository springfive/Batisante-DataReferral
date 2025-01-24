@isTest
public class test_addDevisProspect {
    
   
    @isTest
    static void testDevisProspectDevis() {
        Lead lead = new Lead();
       // lead.RecordTypeId = '0127Z000001IsshQAC';
        lead.Company = 'Test comp';
        lead.Fonction__c = 'DAF';
        lead.Status = 'Qualification';
        lead.Source__c = 'Appel entrant';
        lead.SIRET__c = '45132382811111';
        lead.LastName = 'TEST';        
        insert lead;
        
        BS_Devis_from_Lead__c Devislead =new BS_Devis_from_Lead__c();
        Devislead.name='Eloïse GUERIN - Devis Lead - n°201';
        //Devislead.BS_N_Devis__c='SF-000037';
        Devislead.Etat2__c='Transmis';
        Devislead.Statut__c='Devis';
        Devislead.Piste_del__c=lead.Id;
        Devislead.Contact_Soci_t__c='Eloïse GUERIN';
        insert Devislead;
        
        Account client = insertClient();
        
        list<BS_Devis_from_Lead__c> Devislead2=[select Id,BS_N_Devis__c from BS_Devis_from_Lead__c];
        BS_Devis__c Devis= new BS_Devis__c();
        Devis.Name='Dératisation parties communes - Ponctuelle';
        Devis.N_Devis_From_Lead__c=Devislead.BS_N_Devis__c;
        Devis.BS_Pole__c='Hygiène';
        Devis.BS_N_Ope__c='5729167';
        Devis.BS_Emplacement__c = insertSite(client).Id;
        Devis.BS_Nom_Client__c=client.Id;
        Insert Devis;
        
        Devis.N_Devis_From_Lead__c = Devislead2[0].BS_N_Devis__c;
         Devis.BS_Commentaires__c='Com test';
        
        Update Devis;
    }
    
    static Account insertClient() {
        Account acc = new Account();
        acc.Name = 'TE';
        acc.BS_Id_ClientAzur__c = '12345';
        
        insert acc;
        return acc;
    }
    
    static Schema.Location insertSite(Account client) {

        Schema.Location site = new Schema.Location();
        site.Name = 'Test';
        site.BS_Client__c = client.Id;
        
        insert site;
        return site;
    }
    
    @isTest
    static void testDevisProspectBDC() {
        Account client = insertClient();
        Schema.Location site = insertSite(client);
         Lead lead = new Lead();
        lead.Company = 'Test comp';
        lead.Fonction__c = 'DAF';
        lead.Status = 'Qualification';
        lead.Source__c = 'Appel entrant';
        lead.SIRET__c = '45132382811111';
        lead.LastName = 'TEST';        
        insert lead;
        
        BS_Devis_from_Lead__c Devislead = new BS_Devis_from_Lead__c();
        Devislead.name='Eloïse GUERIN - Devis Lead - n°201';
        //Devislead.BS_N_Devis__c='SF-000037';
        Devislead.Etat2__c='Transmis';
        Devislead.Statut__c='Devis';
        Devislead.Piste_del__c=lead.Id;
        Devislead.Contact_Soci_t__c='Eloïse GUERIN';
        insert Devislead;
        
        list<BS_Devis_from_Lead__c> Devislead2=[select Id,BS_N_Devis__c from BS_Devis_from_Lead__c];
        
        BS_BDC__c BDC= new BS_BDC__c();
        BDC.Name='Dératisation parties communes - Ponctuelle';
        BDC.N_Devis_From_Lead__c=Devislead.BS_N_Devis__c;
        BDC.BS_Pole__c='Hygiène';
        BDC.BS_Emplacement__c= site.Id;
        BDC.BS_Client__c= client.Id;
        BDC.BS_N_BDC__c = '5729167';
        Insert BDC;
                
        BDC.N_Devis_From_Lead__c = Devislead2[0].BS_N_Devis__c;
        Update BDC;
    }
    
    @isTest
    static void testDevisProspectProspect() {
          Lead lead = new Lead();
       // lead.RecordTypeId = '0127Z000001IsshQAC';
        lead.Company = 'Test comp';
        lead.Fonction__c = 'DAF';
        lead.Status = 'Qualification';
        lead.Source__c = 'Appel entrant';
        lead.SIRET__c = '45132382811111';
        lead.LastName = 'TEST';        
        insert lead;
        
       BS_Devis_from_Lead__c Devislead =new BS_Devis_from_Lead__c();
        Devislead.name='Eloïse GUERIN - Devis Lead - n°201';
        Devislead.Etat2__c='Transmis';
        Devislead.Statut__c='Devis';
        Devislead.Piste_del__c=lead.Id;
        Devislead.Contact_Soci_t__c='Eloïse GUERIN';
        insert Devislead;
        

        list<BS_Devis_from_Lead__c> Devislead2=[select Id,BS_N_Devis__c from BS_Devis_from_Lead__c];
        
        //System.debug(Devislead);
        
        Contract contrat= new Contract();
        contrat.AccountId = insertClient().Id;
        contrat.BS_N_contrat__c = 'COntrat';
        contrat.N_de_devis__c =  Devislead2[0].BS_N_Devis__c;
        Insert contrat;
        
        contrat.N_de_devis__c =  Devislead.BS_N_Devis__c;
        update contrat;
    }
    
}