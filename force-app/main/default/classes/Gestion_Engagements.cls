/**
* @author Amine SARBOUTE
* @date 23/07/2020
* @description Gestion_Engagements : Gestion du flux Engagement AZUR=>SFDC
*/
Global with sharing class Gestion_Engagements {
    public static Structure_Engagement.MessageRetour CheckEngagemenExistWithExternalID(Structure_Engagement.EngagementWrapper eng) {
        Structure_Engagement.MessageRetour messageRetour= new Structure_Engagement.MessageRetour();
        Structure_Engagement.MessageRetour messageRetourindiv= new Structure_Engagement.MessageRetour();
        integer nbErr=0;
        messageRetour.message ='Erreur(s): ';
        List<BS_Engagement__c> EngagementsForUpsert= new List<BS_Engagement__c>();
        List<BS_Engagement__c> engagements=Structure_Engagement.getEngagementByIdEngagement(eng);
        List<BS_Type_engagement__mdt> mdtTypeEng=Structure_Engagement.transcoFromPrestation(eng);
        List<BS_Site__c> sites=Structure_Engagement.getSiteAndClientByCodeSite(eng.codeSite);
        /********************************************************************************************************************
* DEBUT MAJ
*********************************************************************************************************************/
        if (engagements.size()>0 && eng.idEngagement!=null && eng.idEngagement!='' ){ 
            if(eng.idEngagement!=null && eng.idEngagement!=''){
                engagements[0].BS_ID_engagement_Az__c=eng.idEngagement;
                engagements[0].name=eng.idEngagement;
            }  	
            if(eng.prestation!=null && eng.prestation!=''){
                engagements[0].BS_Prestation__c=eng.prestation;
                if(mdtTypeEng.size()>0){
                    engagements[0].BS_Type1__c=mdtTypeEng[0].BS_Type1__c;
                    engagements[0].BS_Type2__c=mdtTypeEng[0].BS_Type2__c;
                }
            }
            if(eng.dateAcceptation!=null && eng.dateAcceptation!=''){
                engagements[0].BS_Date_acceptation__c=Date.valueOf(eng.dateAcceptation);
            }else if(eng.dateAcceptation!=null && eng.dateAcceptation==''){
                engagements[0].BS_Date_acceptation__c=null;
            }
            if(eng.dateResiliation!=null && eng.dateResiliation!=''){
                engagements[0].BS_Date_de_resiliation__c=Date.valueOf(eng.dateResiliation);
            }else if(eng.dateResiliation!=null && eng.dateResiliation==''){
                engagements[0].BS_Date_de_resiliation__c=null;
            } 
            if(eng.creeLe!=null && eng.creeLe!='') {
                engagements[0].BS_Date_creation_Az__c=Date.valueOf(eng.creeLe);
            }else if(eng.creeLe!=null && eng.creeLe=='') {
                engagements[0].BS_Date_creation_Az__c=null;
            } 
            if(eng.modifieLe!=null && eng.modifieLe!=''){
                engagements[0].BS_Date_modification_Az__c=Date.valueOf(eng.modifieLe);
            }else if(eng.modifieLe!=null && eng.modifieLe==''){
                engagements[0].BS_Date_modification_Az__c=null;
            }
            if(eng.prixEstimeHt!=null && eng.prixEstimeHt!=''){
                engagements[0].BS_Prix_estime_HT__c=Decimal.ValueOf(eng.prixEstimeHt);
            }else if(eng.prixEstimeHt!=null && eng.prixEstimeHt==''){
                engagements[0].BS_Prix_estime_HT__c=0;
            }
            if(eng.societe!=null)  				 engagements[0].BS_Societe__c=eng.societe;
            if(eng.pole!=null)  			     engagements[0].BS_Pole__c=eng.pole;
            if(eng.dateCreaDevis!=null && eng.dateCreaDevis!=''){
                engagements[0].BS_Date_creation_devis_Az__c=Date.valueOf(eng.dateCreaDevis);
            }else if(eng.dateCreaDevis!=null && eng.dateCreaDevis==''){
                engagements[0].BS_Date_creation_devis_Az__c=null;
            } 
            if(eng.dateAcceptDevis!=null && eng.dateAcceptDevis!=''){
                engagements[0].BS_Date_acceptation_Devis__c=Date.valueOf(eng.dateAcceptDevis);
            }else if(eng.dateAcceptDevis!=null && eng.dateAcceptDevis==''){
                engagements[0].BS_Date_acceptation_Devis__c=null;
            } 
            if(eng.dateRefusDevis!=null && eng.dateRefusDevis!=''){
                engagements[0].BS_Date_refus_devis__c=Date.valueOf(eng.dateRefusDevis);
            }else if(eng.dateRefusDevis!=null && eng.dateRefusDevis==''){
                engagements[0].BS_Date_refus_devis__c=null;
            }
            if(eng.codeSite!=null && eng.codeSite!=''){
                engagements[0].BS_Code_site__c=eng.codeSite;
                if(sites.size()>0){
                    engagements[0].BS_site__c=sites[0].id;
                    if(sites[0].BS_Client__c!=null){
                        engagements[0].BS_Client__c=sites[0].BS_Client__c;
                        List<Contact> gestionnaire=Structure_Engagement.getGestionnaireByIdClient(sites[0].BS_Client__c);
                        if(gestionnaire.size()>0) engagements[0].BS_Contact__c=gestionnaire[0].id;
                    }else{
                        //Si Le site n'est associé à aucun client=>Impossible
                        /*nbErr++;
                        messageRetourindiv=Structure_Engagement.clientManquant(eng);
                        messageRetour.message+=messageRetourindiv.message;*/
                    } 
                    
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC, on génére une erreur?
                    nbErr++;
                    messageRetourindiv=Structure_Engagement.codeSiteInvalide(eng);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                
                //MSG d'erreur : Le code site est obligatoire
                nbErr++;
                messageRetourindiv=Structure_Engagement.codeSiteManquant(eng);
                messageRetour.message+=messageRetourindiv.message;
            }
            
            EngagementsForUpsert.add(engagements[0]);
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.idEngagement=eng.idEngagement;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                    update EngagementsForUpsert;
                }catch(System.DmlException e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message = 'L\'engagement avec le No '+eng.idEngagement+' existe déjà et n\'a pa été mis à jour. \n Raisons: '+e.getMessage();
                    messageRetour.idEngagement=eng.idEngagement;
                    messageRetour.IdSFDC=engagements[0].id;
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            messageRetour.message = 'L\'engagement avec le No '+eng.idEngagement+' Existe déjà et a été mis à jour';
            messageRetour.idEngagement=eng.idEngagement;
            messageRetour.IdSFDC=engagements[0].id;
            messageRetour.codeErreur = 200;
            return messageRetour;
        }  
        
        /********************************************************************************************************************
* FIN MAJ
*********************************************************************************************************************/     
        
        
        /********************************************************************************************************************
* DEBUT CREATION
/********************************************************************************************************************/      
        else if (engagements.size()<=0 && eng.idEngagement!=null && eng.idEngagement!=''  ){
            BS_Engagement__c NewEng= New BS_Engagement__c();
            if(eng.idEngagement!=null && eng.idEngagement!=''){
                NewEng.BS_ID_engagement_Az__c=eng.idEngagement;
                NewEng.name=eng.idEngagement;                
            }
            if(eng.prestation!=null && eng.prestation!=''){
                NewEng.BS_Prestation__c=eng.prestation;
                if(mdtTypeEng.size()>0){
                    NewEng.BS_Type1__c=mdtTypeEng[0].BS_Type1__c;
                   	NewEng.BS_Type2__c=mdtTypeEng[0].BS_Type2__c;
                }
            }
            if(eng.dateAcceptation!=null && eng.dateAcceptation!='') NewEng.BS_Date_acceptation__c=Date.valueOf(eng.dateAcceptation);
            if(eng.dateResiliation!=null && eng.dateResiliation!='') NewEng.BS_Date_de_resiliation__c=Date.valueOf(eng.dateResiliation);
            if(eng.creeLe!=null && eng.creeLe!='')   				 NewEng.BS_Date_creation_Az__c=Date.valueOf(eng.creeLe);
            if(eng.modifieLe!=null && eng.modifieLe!='')   			 NewEng.BS_Date_modification_Az__c=Date.valueOf(eng.modifieLe);
            if(eng.prixEstimeHt!=null && eng.prixEstimeHt!='') 		 NewEng.BS_Prix_estime_HT__c=Decimal.ValueOf(eng.prixEstimeHt);
            if(eng.societe!=null && eng.societe!='')  				 NewEng.BS_Societe__c=eng.societe;
            if(eng.pole!=null && eng.pole!='')  					 NewEng.BS_Pole__c=eng.pole;
            if(eng.dateCreaDevis!=null && eng.dateCreaDevis!='') 	 NewEng.BS_Date_creation_devis_Az__c=Date.valueOf(eng.dateCreaDevis);
            if(eng.dateAcceptDevis!=null && eng.dateAcceptDevis!='') NewEng.BS_Date_acceptation_Devis__c=Date.valueOf(eng.dateAcceptDevis);
            if(eng.dateRefusDevis!=null && eng.dateRefusDevis!='')   NewEng.BS_Date_refus_devis__c=Date.valueOf(eng.dateRefusDevis);
            if(eng.codeSite!=null && eng.codeSite!=''){
                NewEng.BS_Code_site__c=eng.codeSite;
                if(sites.size()>0){
                    NewEng.BS_site__c=sites[0].id;
                    if(sites[0].BS_Client__c!=null){
                        NewEng.BS_Client__c=sites[0].BS_Client__c;
                        List<Contact> gestionnaire=Structure_Engagement.getGestionnaireByIdClient(sites[0].BS_Client__c);
                        if(gestionnaire.size()>0) NewEng.BS_Contact__c=gestionnaire[0].id;
                    }else{
                        //Si Le site n'est associé à aucun client=>Impossible
                        /*nbErr++;
                        messageRetourindiv=Structure_Engagement.clientManquant(eng);
                        messageRetour.message+=messageRetourindiv.message;*/
                    } 
                    
                }else{
                    //Si le code site ne correspond à aucun site dans SFDC, on génére une erreur?
                    nbErr++;
                    messageRetourindiv=Structure_Engagement.codeSiteInvalide(eng);
                    messageRetour.message+=messageRetourindiv.message;
                }
            }else{
                
                //MSG d'erreur : Le code site est obligatoire
                nbErr++;
                messageRetourindiv=Structure_Engagement.codeSiteManquant(eng);
                messageRetour.message+=messageRetourindiv.message;
            }
            if(nbErr>0){
                messageRetour.message =nbErr+ ' '+messageRetour.message;
                messageRetour.idEngagement=eng.idEngagement;
                messageRetour.IdSFDC='';
                messageRetour.codeErreur =401;
                return messageRetour;
            }else{
                try{
                	Database.insert(NewEng);
                }catch(System.DmlException e){
                    //System.debug(e.getDmlMessage());
                    messageRetour.message = 'L\'engagement avec le No '+eng.idEngagement+' n\'a pas été créé. \n Raisons: '+e.getMessage();
                    messageRetour.idEngagement=eng.idEngagement;
                    messageRetour.IdSFDC='';
                    messageRetour.codeErreur =401;
                    return messageRetour;
                }
            }
            list<BS_Engagement__c> idEng = [Select id From BS_Engagement__c Where id= :NewEng.id];
            if(messageRetour.codeErreur !=401){
                messageRetour.message = 'L\'engagement avec le No '+eng.idEngagement+' a été créé';
                messageRetour.idEngagement=eng.idEngagement;
                messageRetour.IdSFDC=idEng[0].id;
                messageRetour.codeErreur = 200;
            }
            return messageRetour;
        }     
        /********************************************************************************************************************
* FIN CREATION
/********************************************************************************************************************/             
        //Si le N d'engagement est manquant
        else{
            nbErr++;
            messageRetourindiv=Structure_Engagement.idEngagementManquant(eng);
            messageRetour.message+=messageRetourindiv.message;
        }
        
        
        return messageRetour;
    }
    
}