/**
* @author Amine SARBOUTE
* @date 27/07/2020
* @description  :WS08_UpsertContrat
* le web service d'entree qui est utilisé pour Créér/Modifier un Contrat dans SFDC repris depuis AZUR
*/
@RestResource(urlMapping = '/UpsertBdc/*')
Global class WS07_UpsertBDC {
    @HttpPost
    global static  Structure_BDC.MessageRetour upsertBDC(Structure_BDC.BDCWrapper bdcAZ) {        
        Structure_BDC.MessageRetour msgRetour= Gestion_BDC.CheckBDCExistWithExternalID(bdcAZ);
        return msgRetour;
    }
}

/*
---URL WS : /services/apexrest/UpsertBdc/Bdc

---Exemple JSON : 
 
{ "bdcAZ":{
"dateCreaAz":"2019-06-07",
"prestation":"EL100",
"noBDC":"24956",
"noElement":"960",
"libelle":"libellé long test",
"totalOffreHT":"9675",
"societe":"Topel",
"pole":"MOT",
"dateInsertion":"2019-09-07",
"dateEffet":"2019-10-07",
"dateFin":"2020-10-07",
"dateInsertResil":"2020-10-09",
"dateAccept":"2020-10-07",
"codeSite":"94250DEAV000001",
"statut":"C",
"dateEffetResil":"2020-10-20"
}} */