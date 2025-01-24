/**
* @author Amine SARBOUTE
* @date 14/07/2020
* @description Structure_Contact : Wrapper Contat, Gestion des erreurs et requêtes
*/
global with sharing class Structure_Contact {
    global virtual class MessageRetour {
        
        public  MessageRetour () {
            
        }
        
        //identifiant du compte Azur
        webservice String  IdContactAZ { get; set; }
        webservice integer codeErreur { get; set; }
        webservice String  message { get; set; }
        webservice String  IdSFDC { get; set; }
        webservice Structure_Contact.ContactWrapper contact { get; set; }
    }
    
    global class ContactWrapper{
        //webservice String typeContact { get; set; }//inutile => on se base sur le codeSource pour définir le type du contact
        webservice String prenom { get; set; } //OK
        webservice String civilite { get; set; }//OK
        webservice String mobile { get; set; }//OK
        webservice String telephone { get; set; }//OK
        webservice String fax { get; set; }
        webservice String nom { get; set; }//OK
        webservice String qualite { get; set; }
        webservice String dateSortie { get; set; }//OK--- Formule Transco:Si Date_sortie = renseigné alors -> actif décoché. Si Date_sortie=vide alors > actif = coché
        webservice String adresseEmail { get; set; }//OK
        webservice String adressePostale { get; set; }
        webservice String codeSource { get; set; }//OK
        webservice String idClientAzur { get; set; } //=> doublon avec idSource? en attente retour Lakshami
        webservice String idContactAzur { get; set; }//OK
        webservice String creeLeAzur { get; set; }//OK
        webservice String modifieLeAzur { get; set; }//OK
        webservice String idSource { get; set; }//OK ==>on reçoit soit un code site ou un id client 
        webservice String principal { get; set; }
        webservice String Typologie {get;set;} //à tester => réception du type de contact Principal : Gestionnaire, Assistant, autre (picklist not restricted)
	}
    public static list<Contact> getContactByIdContactAzur(Structure_Contact.ContactWrapper ct){
        List<contact> contacts=[SELECT id, BS_Id_Contact_Azur__c, BS_Code_source__c, BS_Site__c, AccountId, RecordTypeId,
                                firstName, LastName, Salutation, MobilePhone, Phone, Fax, BS_Date_sortie__c,Email,
                                BS_Id_Source__c, BS_Principal__c,BS_Adresse_postale__c,BS_Typologie__c
                          		FROM Contact WHERE BS_Id_Contact_Azur__c= :ct.idContactAzur FOR UPDATE];
        return contacts;
    }
    public static list<Account> getClientByIdSource(Structure_Contact.ContactWrapper ct){
        List<Account> accounts=[SELECT id, ownerId, ShippingStreet, ShippingPostalCode, ShippingCity, ShippingCountry
                          		FROM Account WHERE BS_Id_ClientAzur__c= :ct.idSource];
        return accounts;
    }
    public static list<BS_Site__c> getSiteByIdSource(Structure_Contact.ContactWrapper ct){
        List<BS_Site__c> sites=[SELECT id, BS_Client__c, BS_Adresse_site__c, BS_Adresse_Lieu__c
                          		FROM BS_Site__c WHERE BS_code_site__c= :ct.idSource];
        return sites;
    }
    public static Structure_Contact.MessageRetour codeSourceInvalide(Structure_Contact.ContactWrapper ct) {
        Structure_Contact.MessageRetour messageRetour = new Structure_Contact.MessageRetour();
        messageRetour.message = 'Le code source ne correspond à aucun type de contact. Valeurs possibles : 1=>Contact client,2=>Contact Site; ';
        messageRetour.IdContactAZ=ct.idContactAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contact.MessageRetour idContactManquant(Structure_Contact.ContactWrapper ct) {
        Structure_Contact.MessageRetour messageRetour = new Structure_Contact.MessageRetour();
        messageRetour.message = 'L\'id Contact est obligatoire.; ';
        messageRetour.IdContactAZ=ct.idContactAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contact.MessageRetour codeSourceManquant(Structure_Contact.ContactWrapper ct) {
        Structure_Contact.MessageRetour messageRetour = new Structure_Contact.MessageRetour();
        messageRetour.message = 'Le code source est obligatoire. Valeurs possibles : 1=>Contact client,2=>Contact Site,4=>Contact Lieu; ';
        messageRetour.IdContactAZ=ct.idContactAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contact.MessageRetour idSourceClientInvalide(Structure_Contact.ContactWrapper ct) {
        Structure_Contact.MessageRetour messageRetour = new Structure_Contact.MessageRetour();
        messageRetour.message = 'L\'id source ne correspond à aucun client';
        messageRetour.IdContactAZ=ct.idContactAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contact.MessageRetour idSourceSiteInvalide(Structure_Contact.ContactWrapper ct) {
        Structure_Contact.MessageRetour messageRetour = new Structure_Contact.MessageRetour();
        messageRetour.message = 'L\'id source ne correspond à aucun site';
        messageRetour.IdContactAZ=ct.idContactAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contact.MessageRetour idSourceManquant(Structure_Contact.ContactWrapper ct) {
        Structure_Contact.MessageRetour messageRetour = new Structure_Contact.MessageRetour();
        messageRetour.message = 'L\'id source est obligatoire';
        messageRetour.IdContactAZ=ct.idContactAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }
    public static Structure_Contact.MessageRetour nomContactManquant(Structure_Contact.ContactWrapper ct) {
        Structure_Contact.MessageRetour messageRetour = new Structure_Contact.MessageRetour();
        messageRetour.message = 'Le nom du contact est obligatoire';
        messageRetour.IdContactAZ=ct.idContactAzur;
        messageRetour.IdSFDC='';
        messageRetour.codeErreur = 401;
        return messageRetour;
    }

}