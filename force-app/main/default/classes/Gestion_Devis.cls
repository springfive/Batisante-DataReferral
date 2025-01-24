/**
* @author Amine SARBOUTE
* @date 22/07/2020
* @description Gestion_Devis : Gestion du flux Devis AZUR=>SFDC
*/
Global with sharing class Gestion_Devis {

    public static Structure_Devis.MessageRetour CheckDevisExistWithExternalID(Structure_Devis.DevisWrapper dv) {
        Structure_Devis.MessageRetour messageRetour= new Structure_Devis.MessageRetour();
        Structure_Devis.MessageRetour messageRetourindiv= new Structure_Devis.MessageRetour();
        integer nbErr=0;
        messageRetour.message ='Erreur(s): ';
        List<BS_Devis__c> DevisForUpsert= new List<BS_Devis__c>();
        List<BS_Devis__c> devis=Structure_Devis.getDevisByNOpe(dv);
        //Récupérer les valeurs Activité et segment transcodées dans la métadonné "ActivitesSegments__mdt"
        List<BS_Typologie_Devis__mdt> mdtTypeDevis=Structure_Devis.transcoFromTypOpe(dv);
        List<BS_Origine__mdt> mdtOrigine=Structure_Devis.transcoFromOrigineAz(dv);
        List<Schema.Location> sites=Structure_Devis.getSiteAndClientByCodeSite(dv.codeSite);
        List<user> ownerDevis=Structure_Devis.getUserByCreePar(dv.creePar);
        
        /********************************************************************************************************************
* DEBUT MAJ
*********************************************************************************************************************/

        if (devis.size()>0 && dv.nOpe!=null && dv.nOpe!='' ){
            
            if(dv.nOpe!=null)               devis[0].BS_N_Ope__c=dv.nOpe;
            
            if(dv.typeOpe!=null && dv.typeOpe!='') {
                devis[0].BS_Type_Ope__c=dv.typeOpe;
                if(mdtTypeDevis.size()>0){
                        devis[0].BS_Type1__c=mdtTypeDevis[0].BS_Type1__c;
                        devis[0].BS_Type2__c=mdtTypeDevis[0].BS_Type2__c;
                }Else{
                        //Si le type opé reçu d'azur ne correspond à rien dans sfdc(pas de correspondance dans les métadata)
                        // on fait quoi?
                }
            }
            if(dv.InfoCom!=null)          devis[0].BS_Info_Com__c=dv.InfoCom;
            if(dv.AuteurRapport!=null)    devis[0].Auteur_Rapport__c=dv.AuteurRapport;
            if(dv.nTicket!=null)          devis[0].BS_N_Ticket__c=dv.nTicket;
            if(dv.designation!=null)      devis[0].Name=dv.designation;
            if(dv.societe!=null)          devis[0].BS_Societe__c=dv.societe;
            if(dv.pole!=null)             devis[0].BS_Pole__c=dv.pole;
            if(dv.tech!=null)             devis[0].BS_Tech__c=dv.tech;
            if(dv.managerTech!=null)      devis[0].BS_Manager_Tech__c=dv.managerTech;
            if(dv.societeTech!=null)      devis[0].BS_Societe_Tech__c=dv.societeTech;
            if(dv.creeLe!=null && dv.creeLe!=''){
                devis[0].BS_Cree_le_Azur__c=Date.valueOf(dv.creeLe);
            }else if(dv.creeLe!=null && dv.creeLe==''){
                devis[0].BS_Cree_le_Azur__c=null;
            }
            if(dv.creePar!=null && ownerDevis.size()>0){
                devis[0].BS_Cree_par_Azur__c=dv.creePar;
                devis[0].BS_Devis_cree_par_Azur__c=ownerDevis[0].id;
            }else if(dv.creePar!=null){
                devis[0].BS_Cree_par_Azur__c=dv.creePar;
            }
            
            if(dv.modifieLe!=null && dv.modifieLe!=''){
                devis[0].BS_Modifie_le_Azur__c=Date.valueOf(dv.modifieLe);
            }else if(dv.modifieLe!=null && dv.modifieLe==''){
                devis[0].BS_Modifie_le_Azur__c=null;
            }
            if(dv.dateAnnul!=null && dv.dateAnnul!=''){
                devis[0].BS_Date_Annul__c=Date.valueOf(dv.dateAnnul);
            }else if(dv.dateAnnul!=null && dv.dateAnnul==''){
                devis[0].BS_Date_Annul__c=null;
            }   
            if(dv.datePerdu!=null && dv.datePerdu!=''){
                devis[0].BS_Date_Perdu__c=Date.valueOf(dv.datePerdu);
            }else if(dv.datePerdu!=null && dv.datePerdu==''){
                devis[0].BS_Date_Perdu__c=null;
            }   
            if(dv.dateAccord!=null && dv.dateAccord!=''){
                devis[0].BS_Date_Accord__c=Date.valueOf(dv.dateAccord);
            }else if(dv.dateAccord!=null && dv.dateAccord==''){
                devis[0].BS_Date_Accord__c=null;
            }   
            if(dv.montantTotal!=null && dv.montantTotal!=''){
                devis[0].BS_Total_HT__c=Decimal.valueOf(dv.montantTotal);
            }else if(dv.montantTotal!=null && dv.montantTotal==''){
                devis[0].BS_Total_HT__c=0;
            }
            //if(dv.statut!=null && dv.statut!='')              devis[0].BS_Statut__c=dv.statut;
            
            if(dv.codeSite!=null && dv.codeSite!=''){
                devis[0].BS_Code_Site__c=dv.codeSite;
                if(sites.size()>0){
                    devis[0].BS_Emplacement__c=sites[0].id;
                    devis[0].BS_Nom_Client__c=sites[0].BS_Client__c;
                    List<Contact> gestionnaire=Structure_Devis.getGestionnaireByIdClient(sites[0].BS_Client__c);
                    if(gestionnaire.size()>0) devis[0].BS_Contact__c=gestionnaire[0].id;
                }else{
                    //Si le code site ne correspond aucun site dans SFDC
                    nbErr++;
                    messageRetourindiv=Structure_Devis.codeSiteInvalide(dv);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                
            //MSG d'erreur : Le code site est obligatoire
            nbErr++;
            messageRetourindiv=Structure_Devis.codeSiteManquant(dv);
            messageRetour.message+=messageRetourindiv.message;
            }
            
            //ACH ajout 20220222 : lien vers proposition facultatif
            if(dv.idLeadCRM!=null && dv.idLeadCRM!=''){
                List<BS_Devis_from_Lead__c> resPropo = Structure_Devis.getProposition(dv);
                if(resPropo!= null && resPropo.size()>0)
                    devis[0].Devis_Prospect__c = resPropo[0].Id;
                
            }else if(dv.idLeadCRM!=null && dv.idLeadCRM==''){
                devis[0].Devis_Prospect__c = null;
            }
            
            if(dv.origine!=null && dv.origine!='') {
                devis[0].BS_Origine1__c=dv.origine;
                if(mdtOrigine.size()>0){
                    devis[0].BS_Origine__c=mdtOrigine[0].BS_Origine__c;
                    devis[0].BS_DET__c=mdtOrigine[0].BS_DET__c;
                }
            }
            
            devisForUpsert.add(devis[0]);
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.nOpe=dv.nOpe;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    update devisForUpsert;
                }catch(System.DmlException e){
                //System.debug(e.getDmlMessage());
                    messageRetour.message = 'Le devis avec le nOpé '+dv.nOpe+' existe d?j? et n\'a pa été mis à jour. \n Raisons: '+e.getMessage();
                    messageRetour.nOpe=dv.nOpe;
                    messageRetour.IdSFDC=devis[0].id;
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            messageRetour.message = 'Le devis avec le nOpé '+dv.nOpe+' Existe déjà et a été mis à jour';
            messageRetour.nOpe=dv.nOpe;
            messageRetour.IdSFDC=devis[0].id;
            messageRetour.codeErreur = 200;
            return messageRetour;
         }
       /********************************************************************************************************************
* FIN MAJ
*********************************************************************************************************************/     
          
           
       /********************************************************************************************************************
* DEBUT CREATION
/********************************************************************************************************************/             

        else if(devis.size()<=0 && dv.nOpe!=null && dv.nOpe!=''){
            BS_Devis__c NewDevis= New BS_Devis__c();
            NewDevis.BS_N_Ope__c=dv.nOpe;
            if(dv.nTicket!=null && dv.nTicket!='')          NewDevis.BS_N_Ticket__c=dv.nTicket;
            if(dv.designation!=null && dv.designation!='')  NewDevis.Name=dv.designation;
            if(dv.societe!=null && dv.societe!='')          NewDevis.BS_Societe__c=dv.societe;
            if(dv.pole!=null && dv.pole!='')                NewDevis.BS_Pole__c=dv.pole;
            if(dv.tech!=null && dv.tech!='')                NewDevis.BS_Tech__c=dv.tech;
            if(dv.managerTech!=null && dv.managerTech!='')  NewDevis.BS_Manager_Tech__c=dv.managerTech;
            if(dv.societeTech!=null && dv.societeTech!='')  NewDevis.BS_Societe_Tech__c=dv.societeTech;
            if(dv.creeLe!=null && dv.creeLe!='')            NewDevis.BS_Cree_le_Azur__c=Date.valueOf(dv.creeLe);
            if(dv.creePar!=null && dv.creePar!='' && ownerDevis.size()>0){
                NewDevis.BS_Cree_par_Azur__c=dv.creePar;
                NewDevis.BS_Devis_cree_par_Azur__c=ownerDevis[0].id;
            }            
            if(dv.modifieLe!=null && dv.modifieLe!='')              NewDevis.BS_Modifie_le_Azur__c=Date.valueOf(dv.modifieLe);
            if(dv.dateAnnul!=null && dv.dateAnnul!='')              NewDevis.BS_Date_Annul__c=Date.valueOf(dv.dateAnnul);
            if(dv.datePerdu!=null && dv.datePerdu!='')              NewDevis.BS_Date_Perdu__c=Date.valueOf(dv.datePerdu);
            if(dv.dateAccord!=null && dv.dateAccord!='')            NewDevis.BS_Date_Accord__c=Date.valueOf(dv.dateAccord);
            if(dv.montantTotal!=null && dv.montantTotal!='')        NewDevis.BS_Total_HT__c=Decimal.valueOf(dv.montantTotal);
            if(dv.InfoCom!=null && dv.InfoCom!='')                  NewDevis.BS_Info_Com__c=dv.InfoCom;
            if(dv.AuteurRapport!=null && dv.AuteurRapport!='')      NewDevis.Auteur_Rapport__c=dv.AuteurRapport;
            //if(dv.statut!=null && dv.statut!='')                  NewDevis.BS_Statut__c=dv.statut;
            
            if(dv.codeSite!=null && dv.codeSite!=''){
                NewDevis.BS_Code_Site__c=dv.codeSite;
                if(sites.size()>0){
                    NewDevis.BS_Emplacement__c=sites[0].id;
                    NewDevis.BS_Nom_Client__c=sites[0].BS_Client__c;
                    List<Contact> gestionnaire=Structure_Devis.getGestionnaireByIdClient(sites[0].BS_Client__c);
                    if(gestionnaire.size()>0) NewDevis.BS_Contact__c=gestionnaire[0].id;
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC, on génére une erreur?
                    nbErr++;
                    messageRetourindiv=Structure_Devis.codeSiteInvalide(dv);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                
            //MSG d'erreur : Le code site est obligatoire
            nbErr++;
            messageRetourindiv=Structure_Devis.codeSiteManquant(dv);
            messageRetour.message+=messageRetourindiv.message;
            }
            
            
            if(dv.origine!=null && dv.origine!='') {
                NewDevis.BS_Origine1__c=dv.origine;
                if(mdtOrigine.size()>0){
                    NewDevis.BS_Origine__c=mdtOrigine[0].BS_Origine__c;
                    NewDevis.BS_DET__c=mdtOrigine[0].BS_DET__c;
                }
            }
            if(dv.typeOpe!=null && dv.typeOpe!='') {
                NewDevis.BS_Type_Ope__c=dv.typeOpe;
                if(mdtTypeDevis.size()>0){
                        NewDevis.BS_Type1__c=mdtTypeDevis[0].BS_Type1__c;
                        NewDevis.BS_Type2__c=mdtTypeDevis[0].BS_Type2__c;
                }Else{
                        //Si le type opé reçu d'azur ne correspond ? rien dans sfdc(pas de correspondance dans les métadata)
                        // on fait quoi?
                }
            }
            
            //ACH ajout 20220222 : lien vers proposition facultatif
            if(dv.idLeadCRM!=null && dv.idLeadCRM!=''){
                List<BS_Devis_from_Lead__c> resPropo = Structure_Devis.getProposition(dv);
                if(resPropo!= null && resPropo.size()>0)
                    NewDevis.Devis_Prospect__c = resPropo[0].Id;
                
            }else if(dv.idLeadCRM!=null && dv.idLeadCRM==''){
                NewDevis.Devis_Prospect__c = null;
            }
            
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.nOpe=dv.nOpe;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    Database.insert(NewDevis);
                    
                }catch(System.DmlException e){
                //System.debug(e.getDmlMessage());
                    messageRetour.message = 'Le devis avec le nOpé '+dv.nOpe+' n\'a pas été créé. \n Raisons: '+e.getMessage();
                    messageRetour.nOpe=dv.nOpe;
                    messageRetour.IdSFDC='';
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            
            list<BS_Devis__c> idDevis = [Select id, BS_N_Ope__c From BS_Devis__c Where id= :NewDevis.id];
            if(messageRetour.codeErreur !=401){
                messageRetour.message='Le devis avec le nOpé '+ dv.nOpe+' a été créé' ;
                messageRetour.nOpe=dv.nOpe;
                messageRetour.IdSFDC=idDevis[0].id;
                messageRetour.codeErreur=200;
                //return messageRetour;
            }
            return messageRetour;
                                   
        }
        
       /********************************************************************************************************************
* FIN CREATION
/********************************************************************************************************************/ 
        
        //Sinon Générer une erreur lorsque le NOpé est manquant
        else{
            //MSG d'erreur : Le code site est obligatoire
            nbErr++;
            messageRetourindiv=Structure_Devis.nOpeManquant(dv);
            messageRetour.message+=messageRetourindiv.message;
        }
        //A supp
        return messageRetour;
    }

}