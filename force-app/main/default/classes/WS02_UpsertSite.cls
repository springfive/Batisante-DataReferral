/**
* @author Amine SARBOUTE
* @date 01/06/2020
* @description WS02_UpsertSite :
* le web service d'entree qui est utilisé pour Créér/Modifier un Site dans SFDC repris depuis AZUR
*/
@RestResource(urlMapping = '/UpsertSite/*')
global class WS02_UpsertSite {
    @HttpPost
    global static   Structure_Site.MessageRetour upsertSite(Structure_Site.SiteWrapper siteAZ) {
        //Gestion_Clients.MessageRetour messageRetour = new Gestion_Clients.MessageRetour();
        Structure_Site.MessageRetour msgRetour= Gestion_Sites.CheckSiteExistWithExternalID(siteAZ);
        return msgRetour;
    }
    
}
/*
---URL WS : /services/apexrest/UpsertSite/Site

---Exemple JSON : 

{"siteAZ":{
"type":"Lieu",
"IdClientAzur":"245600",
"codeSiteAz":"90760",
"noVoie":"5",
"typeVoie":"RUE",
"nomVoie":"la boétie",
"complementAdr":"bp5",
"codePostal":"75008",
"ville": "Paris",
"nomResidence": "resid",
"HAB": true,
"ERT":true,
"ERP" : "test",
"IGH":true,
"ZAR" : false,
"situation":"",
"CodeIRIS":"34343",
"origine":"",
"dateCreationAzur":"2019-12-19",
"auteur":"",
"acces":"91000",
"dateChangSyndic":"2019-12-19",
"ancienClient":"",
"refClient":"",
"representePar":"Jean Dubois",
"total":"8962",
"dateAttestation":"2019-11-18",
"nbCagesEsc":"2",
"LOT":"",
"niveau":"3",
"nbPlacesParking":"43",
"nbAcenseurs":"2",
"nomAscensoriste":"",
"montantImpayes":"765",
"montantAvoirs":"",
"montantResil":"",
"adresseLieu":"",
"dateVisite":"2019-12-30",
"dateCreationVisite":"2019-12-19",
"datePrevueVisite":""
}} 

*/