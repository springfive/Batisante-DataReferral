@isTest
private class GestionnaireTests {
    
    @testSetup
    static void setup() {
        Account a = new Account(Name='Test Gestionnaire',BS_Id_ClientAzur__c='123');
        insert a;
        
        Schema.Location site = new Schema.Location(BS_Code_Site__c='Code site 123',BS_Client__c=a.id,Name='Code Site Test');
        insert site;
        
        List<BS_BDC__c> bdc = new List<BS_BDC__c>();
        List<BS_Engagement__c> engagement = new List<BS_Engagement__c>();
        List<Contract> contract = new List<Contract>();
        List<BS_Devis__c> devis = new List<BS_Devis__c>();
        
        for (integer i = 0; i < 10; i++) {
            bdc.add(new BS_BDC__c(BS_Client__c=a.id,BS_Libelle__c='Test ' + i,N_de_devis__c='' + i,Name='Test BDC' + i,BS_N_BDC__c='' + i));
            engagement.add(new Bs_Engagement__c(BS_Client__c=a.id,Name='Test engagement ' + i,BS_ID_engagement_Az__c='' + i));
            contract.add(new Contract(AccountId=a.id,Name='Test contract ' + i,BS_N_contrat__c='' + i));
            devis.add(new BS_Devis__c(BS_Nom_Client__c=a.id, Name='Test devis ' + i,BS_Emplacement__c=site.id,BS_N_Ope__c='' + i));
        }
        
        insert bdc;
        insert engagement;
        insert contract;
        insert devis;
        
        Contact c = new Contact(AccountId=a.id, LastName='Doe',FirstName='Jane',BS_Id_Contact_Azur__c='123', BS_Typologie__c='Gestionnaire', BS_Principal__c=True, RecordTypeId='0123X0000015vK2QAI');
        insert c;
    }
    
    @isTest static void testBDC() {
        Test.startTest();
        GestionnaireBDC gb = new GestionnaireBDC();
        ID batchID = Database.executeBatch(gb);
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM BS_BDC__c WHERE BS_Contact__c=:null]);
    }
    
    @isTest static void testEngagement() {
        Test.startTest();
        GestionnaireEngagement ge = new GestionnaireEngagement();
        ID batchID = Database.executeBatch(ge);
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM BS_Engagement__c WHERE BS_Contact__c=:null]);
    }
    
    @isTest static void testContract() {
        Test.startTest();
        GestionnaireContract gc = new GestionnaireContract();
        ID batchID = Database.executeBatch(gc);
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM Contract WHERE BS_Gestionnaire__c=:null]);
    }
    
    @isTest static void testDevis() {
        Test.startTest();
        GestionnaireDevis gd = new GestionnaireDevis();
        ID batchID = Database.executeBatch(gd);
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM BS_Devis__c WHERE BS_Contact__c=:null]);
    }

}