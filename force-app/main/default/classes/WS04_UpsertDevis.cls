/**
* @author Amine SARBOUTE
* @date 23/07/2020
* @description  :WS04_UpsertDevis
* le web service d'entree qui est utilisé pour Créér/Modifier un devis dans SFDC repris depuis AZUR
*/

@RestResource(urlMapping = '/UpsertDevis/*')
Global class WS04_UpsertDevis {
    @HttpPost
    global static  Structure_Devis.MessageRetour upsertDevis(Structure_Devis.DevisWrapper devisAZ) {
        //Gestion_Clients.MessageRetour messageRetour = new Gestion_Clients.MessageRetour();
        Structure_Devis.MessageRetour msgRetour= Gestion_Devis.CheckDevisExistWithExternalID(devisAZ);
        return msgRetour;
    }

}


//---URL WS : /services/apexrest/UpsertDevis/Devis

//---Exemple JSON : 
/*{"devisAZ":{
"nOpe":"3423",
"typeOpe":"3D_14",
"nTicket":"78587",
"societe" : "SocTest",
"pole":"CHRISTAL",
"origine":"Client_DET",
"tech":"",
"societeTech": "SOcTech",
"managerTech": "",
"creeLe": "2019-09-08",
"modifieLe": "2019-10-08",
"dateAnnul": "2019-12-08",
"datePerdu": "2019-12-08",
"dateAccord": "",
"montantTotal": "219",
"codeSite": "92200FRPA000100",
"designation": "designTest",
"statut": "Perdu"
}}*/