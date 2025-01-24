/**
* @author Amine SARBOUTE
* @date 09/10/2020
* @description  :Test_WS03_UpsertContact
* la classe de test du web service WS03_UpsertContact
*/
@isTest(SeeAllData = true)
public class Test_WS03_UpsertContact{public static Structure_Contact.ContactWrapper getContactWrapper() {
        Structure_Contact.ContactWrapper contactWrapper  = new Structure_Contact.ContactWrapper();        
        contactWrapper.prenom = 'Amine';
        contactWrapper.civilite = 'Monsieur' ;
        contactWrapper.mobile = '0763728198' ;
        contactWrapper.telephone = '0963728198' ;
        contactWrapper.fax = '0986758493' ;
        contactWrapper.nom = 'SAR' ;
        contactWrapper.qualite = 'Gestionnaire' ;
        contactWrapper.dateSortie = '2019-02-12' ;
        contactWrapper.adresseEmail = 'sar@test.Fr' ;
        contactWrapper.adressePostale = '10 rue la boétie 75008 Paris' ;
        contactWrapper.codeSource = '1' ;
        contactWrapper.idContactAzur = '123422' ;
        contactWrapper.creeLeAzur = '2019-02-12' ;
        contactWrapper.modifieLeAzur = '2019-02-12' ;
        contactWrapper.idSource = '12345' ;
        contactWrapper.principal = 'true' ;
        contactWrapper.Typologie = 'Assistant';
        
        return contactWrapper;     
    }
    
    @isTest static void test_contact_existCode1() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        //NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar Changed';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        System.debug(NewContact.id);
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
			contact.adresseEmail = 'test@test.com';
            msg = WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }        
    }
                                     
    @isTest static void test_contact_existCode2() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        //NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar Changed';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        System.debug(NewContact.id);
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
			contact.adresseEmail = 'test@test.com';
            contact.codesource = '2';
            msg = WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            //system.assert( msg.codeErreur==200);
            Test.stopTest();
        }        
    }
    @isTest static void test_idSourceManquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='';
            contact.codeSource = '2' ;
            contact.adressePostale='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_champs_manquants_invalides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='';
            contact.codeSource = '1' ;
            contact.nom = '' ;
            contact.dateSortie = null ;
            //contact.adressePostale = '';
            contact.creeLeAzur = '' ;
            contact.modifieLeAzur = '' ;
            
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_Exceptions() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.mobile='12344446576879809444452234327568799786565769878';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_adresseclientVide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }        
    }
    @isTest static void test_adresseSiteVide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='13242', BS_Code_Postal__c=75008);
        Database.insert(newSite);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='13242';
            contact.codeSource = '2' ;
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_adresseLieuVide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='13242', BS_Adresse_lieu_L1__c ='rue du bras de fer');
        Database.insert(newSite);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='13242';
            contact.codeSource = '4' ;
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_idSourceSiteinvalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='32453', BS_Adresse_lieu_L1__c ='rue du bras de fer');
        Database.insert(newSite);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='5746587';
            contact.codeSource = '2' ;
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
        @isTest static void test_CodeSourceInvalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.codeSource='6';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_CodeSourceManquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.codeSource='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
      
     @isTest static void test_nouveauContact() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='24242';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.codeSource='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_idAZContactManquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='24242';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idContactAzur='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message+msg.codeErreur);
            system.assert( msg.codeErreur!=200);
            Test.stopTest();
        }        
    }
    @isTest static void test_creation_Champs_Manquants_invalides() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='24242';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.adressePostale='';
            Contact.nom='';
            Contact.idSource='';
            Contact.codeSource='5';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_creation_adresseSiteVide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='13242', BS_Code_Postal__c=75008);
        Database.insert(newSite);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='765876';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='13242';
            contact.codeSource = '2' ;
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_creation_adresseLieuVide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='13242', BS_Adresse_lieu_L1__c ='rue du bras de fer');
        Database.insert(newSite);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='5432';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='13242';
            contact.codeSource = '4' ;
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }
    }
    @isTest static void test_creation_Exceptions() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='65768';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.mobile='12344446576879809444452234327568799786565769878';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
        @isTest static void test_creation_adresseclientVide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='43252';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==200);
            Test.stopTest();
        }        
    }
        @isTest static void test_creation_idSourceManquant() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='34543';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='';
            contact.codeSource = '1' ;
            contact.adressePostale='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }        
    }
    @isTest static void test_creationIdSourceSiteinvalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='32453', BS_Adresse_lieu_L1__c ='rue du bras de fer');
        Database.insert(newSite);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='47778';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='23421112';
            contact.codeSource = '4' ;
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }
    @isTest static void test_creationCodeSourceinvalide() {
        Account NewAccount= New Account();
        NewAccount.name='Test';
        NewAccount.BS_Id_ClientAzur__c='12345';
        NewAccount.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
        Database.insert(NewAccount);
        BS_Site__c newSite= new BS_Site__c(name='test',BS_Client__c=NewAccount.id, BS_Code_Site__c='32453', BS_Adresse_lieu_L1__c ='rue du bras de fer');
        Database.insert(newSite);
        Contact NewContact= New Contact();
        NewContact.lastname='Sar';
        NewContact.BS_Id_Contact_Azur__c='123422';
        NewContact.accountId=NewAccount.id;
        insert NewContact;
        User testUser = Test_Data_Factory.getUserWithProfilInterfaceAzur();
        System.runAs(testUser) {
            Test.startTest();
            Structure_Contact.ContactWrapper contact =getContactWrapper();
            contact.idSource='47658';
            contact.codeSource = '6' ;
            contact.dateSortie = '' ;
            contact.adressePostale ='';
            Structure_Contact.MessageRetour msg= WS03_UpsertContact.upsertContact(contact);
            system.debug(msg.message);
            system.assert( msg.codeErreur==401);
            Test.stopTest();
        }
    }                                
}