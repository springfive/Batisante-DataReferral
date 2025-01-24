/**
* @author Amine SARBOUTE
* @date 11/10/2020
* @description  :Test_WS07_UpsertBDC
* la classe de test du web service WS06_UpsertBDC
*/
@isTest(SeeAllData = true)
public class Test_WS07_UpsertBDC{
    public static Structure_BDC.BDCWrapper getBDCWrapper() {
        Structure_BDC.BDCWrapper BDCWrapper  = new Structure_BDC.BDCWrapper();        
        BDCWrapper.dateCreaAz = '2019-02-12';
        BDCWrapper.prestation = 'EL100' ;
        BDCWrapper.noBDC = '1234' ;
        BDCWrapper.idElmtPropo = '635' ;
        BDCWrapper.libelle = 'test' ;
        BDCWrapper.montantHT = '3425' ;
        BDCWrapper.societe = 'société' ;
        BDCWrapper.pole = 'pole' ;
        BDCWrapper.dateInsertion = '2019-02-12';
        BDCWrapper.dateEffet = '2019-02-12' ;
        BDCWrapper.dateFin = '2019-02-12' ;
        BDCWrapper.dateInsertResil = '2019-02-12' ;
        BDCWrapper.dateEffetResil = '2019-02-12' ;
        BDCWrapper.dateAcception = '2019-02-12' ;
        BDCWrapper.codeSite = '5678' ;
        BDCWrapper.statut = 'O' ;
        
        return BDCWrapper;     
    }
    @isTest static void test_BDC_exist() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;
        BS_Devis_from_Lead__c propo = new BS_Devis_from_Lead__c(Name = 'propTest',  Contact_Soci_t__c='test');
        insert propo;
        String nProp = [Select Id, BS_N_Devis__c from BS_Devis_from_Lead__c where Id =: propo.Id limit 1].BS_N_Devis__c;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.idLeadCRM = nProp;
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            //system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
     @isTest static void test_champs_invalides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.statut='H';
            bdc.codeSite='6884';
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
     @isTest static void test_Exception() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.montantHT = '756858778' ;
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    
    @isTest static void test_champs_vides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.dateCreaAz='';
            bdc.codeSite='';
            bdc.montantHT='';
            bdc.dateInsertion='';
            bdc.dateEffet='';
            bdc.dateFin='';
            bdc.dateInsertResil='';
            bdc.dateEffetResil='';
            bdc.dateAcception='';
            bdc.statut='';
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_Creation_succes() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;BS_Devis_from_Lead__c propo = new BS_Devis_from_Lead__c(Name = 'propTest',    Contact_Soci_t__c='test');
        insert propo;
        String nProp = [Select Id, BS_N_Devis__c from BS_Devis_from_Lead__c where Id =: propo.Id limit 1].BS_N_Devis__c;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.noBDC = '56876' ;
            bdc.idLeadCRM = nProp;
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            //system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_Creation_Exception() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.montantHT = '756858778' ;
            bdc.noBDC = '56876' ;
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_Creation_champs_invalides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.noBDC = '56876';
            bdc.statut='H';
            bdc.codeSite='6884';
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_Creation_champs_manquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.noBDC = '56876' ;
            bdc.statut='';
            bdc.codeSite='';
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_idBDC_Manquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        Database.insert(NewAccount);
        Schema.Location newSite= new Schema.Location(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='5678', BS_Code_Postal__c=75008);
        insert newSite;
        BS_BDC__c newBdc = new BS_BDC__c(name='1234', BS_N_BDC__c='1234',BS_Client__c=newAccount.id);
        insert newBdc;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_BDC.BDCWrapper bdc =getBDCWrapper();
            bdc.noBDC = '' ;
            Structure_BDC.MessageRetour msg= WS07_UpsertBDC.upsertBDC(bdc);
            system.debug(msg.message);
            system.assert( msg.message=='Erreur(s): Le N° BDC est obligatoire');
            Test.stopTest();
        }
    }
}