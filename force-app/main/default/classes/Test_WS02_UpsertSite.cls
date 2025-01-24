/**
* @author Amine SARBOUTE
* @date 10/10/2020
* @description  :Test_WS02_UpsertSite
* la classe de test du web service WS02_UpsertSite
*/
@isTest(SeeAllData = true)
public class Test_WS02_UpsertSite{
    public static Structure_Site.SiteWrapper getSiteWrapper() {
        Structure_Site.SiteWrapper SiteWrapper  = new Structure_Site.SiteWrapper();        
        SiteWrapper.type = 'Site';
        SiteWrapper.idClientAzur = '12345' ;
        SiteWrapper.codeSiteAz = '13579' ;
        SiteWrapper.noVoie = '8' ;
        SiteWrapper.typeVoie = 'rue' ;
        SiteWrapper.nomVoie = 'Pourquoi Pas' ;
        SiteWrapper.complementAdr = 'Cedex 3' ;
        SiteWrapper.codePostal = '75009' ;
        SiteWrapper.ville = 'Paris' ;
        SiteWrapper.nomResidence = 'DOMAINE DU MOULIN OUEST' ;
        SiteWrapper.HAB = 'false' ;
        SiteWrapper.ERT = 'true' ;
        SiteWrapper.ERP = 'erp' ;
        SiteWrapper.IGH = 'false' ;
        SiteWrapper.ZAR = 'true' ;
        SiteWrapper.dateCreationAzur = '2019-02-12' ;
        SiteWrapper.acces = 'acces' ;
        SiteWrapper.dateChangSyndic = '2019-02-13' ;
        SiteWrapper.ancienClient = 'test' ;
        SiteWrapper.refClient = '8655' ;
        SiteWrapper.nbCagesEsc = '4' ;
        SiteWrapper.LOT = '4' ;
        SiteWrapper.niveau = '2' ;
        SiteWrapper.nbPlacesParking = '234' ;
        SiteWrapper.nbAcenseurs = '2' ;
        SiteWrapper.nomAscensoriste = 'Jean' ;
        SiteWrapper.montantResil = '4685' ;
        SiteWrapper.adresseLieu = '64 rue la boétie 75008 Paris' ;
        SiteWrapper.dateVisite = '2019-05-23' ;
        SiteWrapper.dateCreationVisite = '2019-02-12' ;
        SiteWrapper.datePrevueVisite = '2019-02-12' ;
        SiteWrapper.caChristal = '63537' ;
        SiteWrapper.caSagex = '7468' ;
        SiteWrapper.caStech = '758' ;
        SiteWrapper.CaDiag = '6475' ;
        SiteWrapper.montantOffresEnCours = '865799' ;
        SiteWrapper.portfeuilleContractuel = '547685' ; 
        SiteWrapper.nbContratsC = '456' ;
        SiteWrapper.nbContratsS = '345' ;
        SiteWrapper.nbContratsK = '57' ;
        SiteWrapper.nbContratsR = '89' ;
        SiteWrapper.nbContratsO = '46' ;
        return SiteWrapper;     
    }
    @isTest static void test_site_exist() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='13579';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }        
    }
     @isTest static void test_Exceptions() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='13579';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.nbContratsO='5387';
            site.type='Lieu';
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_typeSiteManquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='13579';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.nbContratsO='5387';
            site.idClientAzur = '' ;
            site.type='';
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_typeSiteInvalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='585759';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='13579';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.nbContratsO='5387';
            site.type='TED';
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_champsVides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='585759';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='13579';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.codePostal='';
            site.dateCreationAzur='';
            site.dateChangSyndic='';
            site.nbCagesEsc='';
            site.LOT='';
            site.niveau='';
            site.nbPlacesParking='';
            site.nbAcenseurs='';
            site.montantResil='';
            site.dateVisite='';
            site.datePrevueVisite='';
            site.dateCreationVisite='';
            site.caChristal='';
            site.CaDiag='';
            site.caStech='';
            site.caSagex='';
            site.montantOffresEnCours='';
            site.nbContratsC='';
            site.portfeuilleContractuel='';
            site.nbContratsS='';
            site.nbContratsK='';
            site.nbContratsR='';
            site.nbContratsO='';
            
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }        
    }
    @isTest static void test_creation_site() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='2342';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }        
    }
    @isTest static void test_creation_lieu() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='2342';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.type='Lieu';
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }        
    }
    @isTest static void test_creation_typeSiteManquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='2342';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.nbContratsO='5387';
            site.idClientAzur = '' ;
            site.type='';
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_creation_typeSiteInvalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='585759';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='2342';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.nbContratsO='5387';
            site.type='TED';
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_codeSiteManquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='585759';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='2342';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.codeSiteAz='';
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.message=='Erreur(s): Le code du site est obligatoire ');
            Test.stopTest();
        }        
    }
    @isTest static void test_creation_Exceptions() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        
        BS_Site__c NewSite= New BS_Site__c();
        NewSite.name='Test';
        NewSite.BS_Client__c=NewAccount.id;
        NewSite.BS_Code_Site__c='75688';
        Database.insert(NewSite);
        
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Site.SiteWrapper site =getSiteWrapper();
            site.nbContratsO='5387';
            site.type='Lieu';
            Structure_Site.MessageRetour msg= WS02_UpsertSite.upsertSite(site);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    
}