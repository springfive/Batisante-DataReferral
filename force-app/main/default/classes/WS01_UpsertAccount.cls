/**
* @author Amine SARBOUTE
* @date 01/06/2020
* @description  :WS01_UpsertAccount
* le web service d'entree qui est utilisé pour Créér/Modifier un Compte dans SFDC repris depuis AZUR
*/
@RestResource(urlMapping = '/UpsertAccount/*')
global class WS01_UpsertAccount {
    @HttpPost
    global static   Structure_Client.MessageRetour upsertAccount(Structure_Client.CompteWrapper accountAZ) {
        Structure_Client.MessageRetour msgRetour= Gestion_Clients.CheckAccountExistWithExternalID(accountAZ);
        return msgRetour;
    }
    
}
/*
---URL WS : /services/apexrest/UpsertAccount/Account

---Exemple JSON : 
CFE : 
{ "accountAZ":{
"IdClientAzur":"2457876",
"VendeurMP":"ASA",
"VendeurPE":"MNA",
"VendeurSolutionTech" : "LGE",
"nomClient":"TEST Azur CFE 34",
"ActiviteCFE":"hôtellerie",
"Mobile": "07875785763",
"CodeClient":"15YP1",
"TypeClient" : "CFE",
"ClientARisque":true,
"Groupe" : "test groupe",
"Region":"0",
"CodePostalAP":"91000",
"VilleAP":"Evry",
"Adr1AP":"64 rue la boétie",
"Adr2AP":"Batiment A",
"CodePostalAF":"91000",
"VilleAF":"evry",
"Adr1AF":"64 rue la boétie",
"Adr2AF":"Batiment B",
"CreeLeAzur":"2019-11-19",
"ModifieLeAzur":"2019-10-19",
"DateconvPEsignee":"2019-11-18",
"DateResiliationConvPE":"2019-10-09",
"DateConvASSsignee":"2019-11-20",
"DateResiliationConvASS":"2019-12-19"
}} 


ADB : 
{ "accountAZ":{
"IdClientAzur":"2457876",
"Actif":true,
"nomClient":"API Test from azur ADB",
"ActiviteADB":"Syndic;Transactions",
"Mobile": "0786477633",
"ClientReserve":"F",
"CodeClient":"15FD4",
"TypeClient" : "ADB"
}
}

*/