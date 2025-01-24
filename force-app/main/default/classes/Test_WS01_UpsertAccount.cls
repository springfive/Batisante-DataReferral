/**
* @author Amine SARBOUTE
* @date 06/10/2020
* @description  :Test_WS01_UpsertAccount
* la classe de test du web service WS01_UpsertAccount
*/
@isTest(SeeAllData = true)
public class Test_WS01_UpsertAccount {
    
    public static Structure_Client.CompteWrapper getCompteWrapper() {
        Structure_Client.CompteWrapper compteWrapper  = new Structure_Client.CompteWrapper();        
        compteWrapper.IdClientAzur = '12345';
        compteWrapper.VendeurMP = 'ASA' ;
        compteWrapper.nomClient = 'nom client' ;
        compteWrapper.ActiviteADB = 'Syndic' ;
        compteWrapper.Mobile = '0986758493' ;
        compteWrapper.ClientReserve = 'U' ;
        compteWrapper.CodeClient = '2453' ;
        compteWrapper.TypeClient = 'ADB' ;
        compteWrapper.Groupe = 'Groupe' ;
        compteWrapper.NbImmeubleGeres = '10' ;
        compteWrapper.Region = '0' ;
        compteWrapper.CodePostalAP = '75008' ;
        compteWrapper.CodePostalAF = '75008' ;
        compteWrapper.VilleAF = 'Paris' ;
        compteWrapper.VilleAP = 'Paris' ;
        compteWrapper.Telephone = '0986758493' ;
        compteWrapper.Fax = '0986758493' ;
        compteWrapper.NSiret = '636289294809' ;
        compteWrapper.AdresseMail = 'test@test.Fr' ;
        compteWrapper.ClientARisque = 'false' ;
        compteWrapper.VendeurSolutionTech = 'MAB';
        compteWrapper.VendeurPE = 'MAB' ;
        compteWrapper.Adr1AF = 'test@test.Fr' ;
        compteWrapper.Adr2AF = 'test@test.Fr' ;
        compteWrapper.Adr1AP = 'test@test.Fr' ;
        compteWrapper.Adr2AP = 'test@test.Fr' ;
        compteWrapper.CreeLeAzur = '2019-11-19' ;
        compteWrapper.ModifieLeAzur = '2019-11-19' ;
        compteWrapper.DateconvPEsignee = '2020-10-02';
        compteWrapper.DateResiliationConvPE = '2019-11-19';
        compteWrapper.DateConvASSsignee = '2019-11-19' ;
        compteWrapper.DateResiliationConvASS = '2019-11-19' ;
        compteWrapper.idAdresse = 'idAdresse' ;
        compteWrapper.MontantImpayes = '233' ;
        compteWrapper.MontantAvoirs = '245' ;
        return compteWrapper;     
    }
         
    @isTest static void test_client_exist_admin() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.BS_Code_client__c='53637';
        NewAccount.BS_Client_reserve__c='FNAIM';
        NewAccount.Phone='0783728192';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        User testUser = Test_Data_Factory.getUserWithProfilAdmin();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.ClientReserve='R';
            compte.TypeClient='ADB';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
     }
    @isTest static void test_client_exist_interface() {
        
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.BS_Code_client__c='53637';
        NewAccount.BS_Client_reserve__c='FNAIM';
        NewAccount.Phone='0783728192';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        /*NewAccount.BS_PDS__c=true;            
NewAccount.BS_Activite__c='Syndic';
NewAccount.BS_Region__c='Monsieur';
NewAccount.BillingStreet='Monsieur';
NewAccount.BillingCity='Monsieur';
NewAccount.OwnerId=testUser.id;
NewAccount.BS_Code_Vendeur__c='Monsieur';
NewAccount.BillingPostalCode='75003';
NewAccount.ShippingStreet='RUE LA BOETIE';
NewAccount.ShippingCity='PARIS';
NewAccount.BS_Groupe__c='';
NewAccount.ShippingPostalCode='75008';
NewAccount.BS_Telephone_2__c='';*/
        Database.insert(NewAccount);
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.ClientReserve='F';
            compte.TypeClient='ADB';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_idClientAz_manquant() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.IdClientAzur='';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.message=='Erreur(s): L\'id client Azur est obligatoire; ');
            Test.stopTest();
        }
    }
    @isTest static void test_exception_longueur_MAJ() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.CodeClient='234567876';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_typeClient_manquant() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.TypeClient = '' ;
            compte.ClientReserve = 'U' ;
            compte.Region = '1' ;
            compte.DateconvPEsignee = '2020-10-06';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_clientReserv() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.TypeClient = 'ADB' ;
            compte.ClientReserve = 'U' ;
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_typeClient_Invalide() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.TypeClient = 'CFI' ;
            compte.DateconvPEsignee = '2020-10-04';
            compte.Region = '2' ;
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_champs_manquants_errones() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        
        System.runAs(testUser) {
            //ADB
            Account NewAccount= New Account();
            NewAccount.name='Test';
            NewAccount.BS_Id_ClientAzur__c='2345';
            NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_CFE;
            Database.insert(NewAccount);
            Test.startTest();
            Structure_Client.CompteWrapper compte =new Structure_Client.CompteWrapper();
            compte.VendeurMP='AZE';
            compte.VendeurSolutionTech='MAB';
            compte.VendeurPE='ATE'; 
            compte.IdClientAzur='2345';
            compte.ClientReserve='E';
            compte.ClientARisque=null;
            compte.Region = '4' ;
            compte.TypeClient='CFE';
            compte.CreeLeAzur='';
            compte.ModifieLeAzur='';
            compte.DateconvPEsignee='';
            compte.DateResiliationConvPE='';
            compte.DateConvASSsignee='';
            compte.DateResiliationConvASS='';
            compte.MontantImpayes='';
            compte.MontantAvoirs='';
            compte.nomClient = '' ;
            compte.ActiviteCFE='Administration';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug('$$$$$$$$'+msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    
    
    @isTest static void test_insert_success() {
    User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.IdClientAzur='OO2329329';
            compte.ClientReserve='F';
            compte.TypeClient='ADB';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
     }
    @isTest static void test_insert_failed() {
    User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.IdClientAzur='OO2329329';
            compte.ClientReserve='U';
            compte.TypeClient='CFE';
            compte.VendeurSolutionTech = 'MAB';
            compte.VendeurPE = 'TYR';
            compte.VendeurMP='TRE';
            compte.nomClient=null;
            compte.Region = '5' ;
            compte.ActiviteCFE='Administration';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
     }
    @isTest static void test_typeClientInvalide() {
    User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.IdClientAzur='OO2329329';
            compte.ClientReserve='T';
            compte.TypeClient='CFI';
            compte.Region = '2' ;
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
     }
    @isTest static void test_TypeClientManquant() {
    User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.IdClientAzur='OO2329329';
            compte.ClientReserve='F';
            compte.Region = '1' ;
            compte.TypeClient=null;
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
     }
    @isTest static void test_exception_longueur_Creation() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.IdClientAzur='O78329329';
            compte.CodeClient='23456787654';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_MAJ_creation_tache_relance() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.DateconvPEsignee = String.valueOf(system.today().addDays(-1)) ;
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_insert_creation_tache_relance() {
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Client.CompteWrapper compte =getCompteWrapper();
            compte.DateconvPEsignee = String.valueOf(system.today().addDays(-1)) ;
            compte.IdClientAzur='O29329';
            Structure_Client.MessageRetour msg= WS01_UpsertAccount.upsertAccount(compte);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    
}