/**
* @author Amine SARBOUTE
* @date 24/07/2020
* @description  :WS05_UpsertContrat
* le web service d'entree qui est utilisé pour Créér/Modifier un Contrat dans SFDC repris depuis AZUR
*/
@RestResource(urlMapping = '/UpsertContrat/*')
global class WS05_UpsertContrat {
    @HttpPost
    global static  Structure_Contrat.MessageRetour upsertContrat(Structure_Contrat.ContratWrapper contratAZ) {        
        Structure_Contrat.MessageRetour msgRetour= Gestion_Contrats.CheckContratExistWithExternalID(contratAZ);
        return msgRetour;
    }
}

/*
---URL WS : /services/apexrest/UpsertContrat/Contrat

---Exemple JSON : 
 
{ "contratAZ":{
"noContrat":"1110",
"dateCreation":"2019-06-07",
"noPosition":"24956",
"libelleContrat":"désign test",
"montantHT":"769",
"statutContrat":"R",
"dateInsertion":"2019-06-07",
"dateAcceptation":"2019-06-07",
"dateEffet":"2019-06-07",
"dateInsertResil":"2019-09-07",
"societe":"tegex",
"pole":"sagex",
"codeSite":"94250DEAV000001"
}} */