/**
* @author Amine SARBOUTE
* @date 27/07/2020
* @description  :WS06_UpsertEngagement
* le web service d'entree qui est utilisé pour Créér/Modifier un engagement dans SFDC repris depuis AZUR
*/
@RestResource(urlMapping = '/UpsertEngagement/*')
global class WS06_UpsertEngagement {
    @HttpPost
    global static   Structure_Engagement.MessageRetour upsertEngagement(Structure_Engagement.EngagementWrapper engAZ) {
        Structure_Engagement.MessageRetour msgRetour= Gestion_Engagements.CheckEngagemenExistWithExternalID(engAZ);
        return msgRetour;
    }
    
}
/*
---URL WS : /services/apexrest/UpsertEngagement/Engagement

---Exemple JSON : 
 
{ "engAZ":{
"prestation":"4444",
"dateAcceptation":"2019-10-19",
"dateResiliation":"2019-10-19",
"idEngagement":"75574",
"dateCreationAz":"2019-10-19",
"dateModifAz":"2019-10-19",
"prixEstimeHt":"3456.2",
"societe":"REG",
"pole":"SAGEX",
"codeSite":"92200FRPA000100",
"dateCreaDevis":"2019-10-19",
"dateAcceptDevis":"2019-10-19",
"dateRefusDevis":"2019-10-19"
}}  */