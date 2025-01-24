/**
* @author Amine SARBOUTE
* @date 01/06/2020
* @description  :WS03_Upsertcontact
* le web service d'entree qui est utilisé pour Créér/Modifier un Contact dans SFDC repris depuis AZUR
*/
@RestResource(urlMapping = '/UpsertContact/*')
Global class WS03_UpsertContact {
	@HttpPost
    global static Structure_Contact.MessageRetour upsertContact(Structure_Contact.ContactWrapper contactAZ) {
        
        //Gestion_Clients.MessageRetour messageRetour = new Gestion_Clients.MessageRetour();
        Structure_Contact.MessageRetour msgRetour= Gestion_Contacts.CheckContactExistWithExternalID(contactAZ);
        return msgRetour;
    }
}


/*
---URL WS : /services/apexrest/UpsertContact/Contact
{ "contactAZ":{
"idContactAzur":"8778575",
"prenom":"Jean",
"civilite":"Mr",
"mobile": "0786477633",
"telephone":"0987654321",
"fax":"",
"nom":"Dupont",
"qualite":"Gestionnaire",
"dateSortie":"2019-08-10",
"codeSource":"1",
"adresseEmail":"jdupont@test.fr",
"creeLeAzur":"2018-06-10",
"modifieLeAzur":"2019-06-10",
"idSource":"16",
"adressePostale" : "64 rue la boetie 75008 Paris"
}}
*/