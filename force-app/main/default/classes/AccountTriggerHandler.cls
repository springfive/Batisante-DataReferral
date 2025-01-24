public class AccountTriggerHandler {
    
    public static void accountBeforeUpdate(List<Account> accountList){
        //Prevent Recursive Callouts
        if (TriggerHelper.hasAccountTriggerRun) {
            return;
        }
        else if (TriggerHelper.hasDevisTriggerRun) {
            return;
        }
        TriggerHelper.hasAccountTriggerRun = true;
        
        Set<Id> bsvstSet = new Set<Id>();
        Set<Id> bsvpeSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        Set<String> BS_Code_VendeurSet = new Set<String>();
        Set<String> BS_ActiviteSet = new Set<String>();
        Set<String> BS_Id_ClientAzurset = new Set<String>();
        Map<String, User> vendeursmpMap = new Map<String, User>();
        Map<String,ActivitesSegments__mdt> mdtActivSegMap = new Map<String,ActivitesSegments__mdt>();
        Map<Id,AccountTeamMember> actmMap = new Map<Id,AccountTeamMember>();
        Map<String,Account> BS_Date_convention_PE_signeeMap = new Map<String,Account>();
        Map<Id,Contact>contactsPrincipauxMap = new Map<Id,Contact>();
        Map<Id,Contact>contactsGestionnairesMap = new Map<Id,Contact>();
        List<AccountTeamMember> insertAcctmemMRList = new List<AccountTeamMember>();
        List<Task> insertTaskList = new List<Task>();
        List<Account> insertAccountList = new List<Account>();

        for(Account ac:accountList){

            if(ac.BS_Vendeur_Solution_technique__c != null){
                bsvstSet.add(Id.ValueOf(ac.BS_Vendeur_Solution_technique__c));
            }
            if(ac.BS_Vendeur_PE__c != null){
                bsvpeSet.add(Id.ValueOf(ac.BS_Vendeur_PE__c));
            }
            BS_Code_VendeurSet.add(ac.BS_Code_Vendeur__c);
            BS_ActiviteSet.add(ac.BS_Activite__c);
            accountIdSet.add(ac.Id);
            BS_Id_ClientAzurset.add(ac.BS_Id_ClientAzur__c);
        }

        List<User> vendeursMP = [SELECT Id, name, BS_Gestionnaire_de_clientele__c, BS_Trigramme__c FROM user WHERE BS_Trigramme__c IN :BS_Code_VendeurSet AND IsActive = true];        
        
        List<ActivitesSegments__mdt> mdtActivSeg = [SELECT MasterLabel, QualifiedApiName, Activite_Azur__c,Activite_SFDC__c,Segment_SFDC__c FROM ActivitesSegments__mdt WHERE Activite_Azur__c IN :BS_ActiviteSet]; 
        
        Map<Id, Account> typeClientMap = new Map<Id, Account>([SELECT Id, RecordType.Name, RecordTypeId FROM Account WHERE Id IN :accountIdSet]);
        
        List<AccountTeamMember> actm=[SELECT Id, AccountId, TeamMemberRole, UserId FROM AccountTeamMember WHERE AccountId= :accountIdSet AND TeamMemberRole='Commercial MR'];
        
        Map<Id, User> vendeursSTMap = new Map<Id, User>([SELECT Id, name, BS_Trigramme__c FROM user WHERE Id IN :bsvstSet AND IsActive = true]);
        
        Map<Id, User> vendeursSTGestionnaireMap = new Map<Id, User>([SELECT Id, name, BS_Trigramme__c,BS_Gestionnaire_de_clientele__c FROM user WHERE Id IN :bsvstSet AND IsActive = true]);
        
        Map<Id, User> vendeursPEMap = new Map<Id, User>([SELECT Id, name, BS_Trigramme__c FROM user WHERE Id IN :bsvpeSet AND IsActive = true]);
        
        for(User u:vendeursMP){vendeursmpMap.put(u.BS_Trigramme__c,u);}

        for(ActivitesSegments__mdt mdt: mdtActivSeg){mdtActivSegMap.put(mdt.Activite_Azur__c,mdt);}        
        
        for(AccountTeamMember atm :actm){actmMap.put(atm.AccountId,atm);}
        
        Id contactClientRtId=[Select Id,SobjectType,Name From RecordType where Name ='Contact Client' and SobjectType ='Contact'  limit 1].Id;
        
        List<contact> contactsPrincipaux=[select Id,AccountId, BS_Principal__c, title, recordtypeId from contact where AccountId IN :accountIdSet and BS_Principal__c=true and recordtypeId= :contactClientRtId ];
        
        List<contact> contactsGestionnaires=[select Id,AccountId, BS_Principal__c, title, recordtypeId from contact where AccountId IN :accountIdSet and BS_Principal__c=true and title='Gestionnaire' and recordtypeId= :contactClientRtId];
        
        Id recordtypeid = [Select Id,SobjectType,Name From RecordType where Name ='Relance Gardiens' and SobjectType ='Task'  limit 1].Id;
       
        List<Account> accdatefield = [Select BS_Date_convention_PE_signee__c, BS_Id_ClientAzur__c from Account where BS_Id_ClientAzur__c IN :BS_Id_ClientAzurset];
        
        for(Account ac:accdatefield){BS_Date_convention_PE_signeeMap.put(ac.BS_Id_ClientAzur__c,ac);}

        for(Contact con:contactsPrincipaux){contactsPrincipauxMap.put(con.AccountId,con);}
        
        for(Contact con:contactsGestionnaires){contactsGestionnairesMap.put(con.AccountId,con);}

        for(Account acc : accountList){

            List<AccountTeamMember> acc_actm= new List<AccountTeamMember>();
            AccountTeamMember acctmemMR = new AccountTeamMember();
            List<contact> contactsPrincipaux_lst = new List<contact>();
            List<contact> contactsGestionnaires_lst = new List<contact>();

            //BS_Code_Vendeur__c, OwnerId, BS_Gestionnaire_de_clientele__c
            if(acc.BS_Code_Vendeur__c != null && acc.BS_Code_Vendeur__c!='' && vendeursmpMap.containsKey(acc.BS_Code_Vendeur__c) && vendeursMP.size()>0){                

                acc.BS_Code_Vendeur__c = acc.BS_Code_Vendeur__c;
                acc.OwnerId = vendeursmpMap.get(acc.BS_Code_Vendeur__c).Id; 
                if(vendeursmpMap.get(acc.BS_Code_Vendeur__c).BS_Gestionnaire_de_clientele__c != null){
                acc.BS_Gestionnaire_de_clientele__c = vendeursmpMap.get(acc.BS_Code_Vendeur__c).BS_Gestionnaire_de_clientele__c;
                }                    
            }
            else{
                
                acc.BS_Code_Vendeur__c =acc.BS_Code_Vendeur__c;
                acc.OwnerId =System.Label.BS_Automate_ID; 
                acc.BS_Gestionnaire_de_clientele__c =System.Label.BS_Automate_ID;                      
            }

            for(AccountTeamMember atm : actm){

                if(acc.Id == atm.AccountId){
                    acc_actm.add(atm);
                }
            }

            
            //AccountTeamMember Updation
            if(acc.BS_Vendeur_Solution_technique__c !=null  && vendeursSTMap.containsKey(acc.BS_Vendeur_Solution_technique__c)){
               /* if(acc_actm.size()<=0 && vendeursSTMap.containsKey(acc.BS_Vendeur_Solution_technique__c)){
                    acctmemMR.AccountId=acc.id;
                    acctmemMR.TeamMemberRole='Commercial MR';
                    acctmemMR.UserId=vendeursSTMap.get(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)).Id;
                    acctmemMR.OpportunityAccessLevel='Edit';
                    acctmemMR.AccountAccessLevel='Edit';
                    insertAcctmemMRList.add(acctmemMR);
LMS 11/10/2024 : Logique déja dans un flow
*/
                }
                else if(acc_actm.size()>0 && actmMap.get(acc.Id).UserId != vendeursSTMap.get(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)).Id){
                   /* delete acc_actm;
                    acctmemMR.AccountId=acc.id;
                    acctmemMR.TeamMemberRole='Commercial MR';
                    acctmemMR.UserId=vendeursSTMap.get(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)).Id;
                    acctmemMR.OpportunityAccessLevel='Edit';
                    acctmemMR.AccountAccessLevel='Edit';
                    insertAcctmemMRList.add(acctmemMR);
                }
LMS 11/10/2024 : Logique déja dans un flow
*/

            }
            else{
                acc.BS_Vendeur_Solution_technique__c =System.Label.BS_Automate_ID; 
            }
            
            //Gestionnaire_de_client_le_Indisp__c
            if(acc.BS_Vendeur_Solution_technique__c !=null && vendeursSTGestionnaireMap.size()!=0 && vendeursSTGestionnaireMap.containsKey(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)) && vendeursSTGestionnaireMap.get(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)).BS_Gestionnaire_de_clientele__c != null){              
                
                acc.Gestionnaire_de_client_le_Indisp__c = vendeursSTGestionnaireMap.get(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)).BS_Gestionnaire_de_clientele__c;
            }
            else{
              
                acc.Gestionnaire_de_client_le_Indisp__c =System.Label.BS_Automate_ID;                      
            }
            
            //VendeurPE
            if(acc.BS_Vendeur_PE__c == null){acc.BS_Vendeur_PE__c =System.Label.BS_ManagerCoPE;}
            
  
            if(acc.RecordTypeId !=null ){
                
                //ADB -> BS_Activite_ADB__c
                //Si le client est de type ADB, récupération de la valeur telle quelle
                if(acc.RecordTypeId == System.Label.BS_nom_recordtype_ADB){

                    if(acc.BS_Activite_ADB__c != null && acc.BS_Activite_ADB__c != ''){ 
                        acc.BS_Activite_ADB__c = acc.BS_Activite_ADB__c;                       
                    }
                }
                
                //CFE -> Segment_SFDC__c, Activite_SFDC__c
                //Si le client est de type CFE ou CFImmo, transcodage de la valeur activité et calcul segment associé
                else if(acc.RecordTypeId == System.Label.BS_nom_recordtype_CFE){

                    if(acc.BS_Activite__c != null && acc.BS_Activite__c != ''){ 
                        
                        if(mdtActivSeg.size()>0){
                            if(mdtActivSegMap.containsKey(acc.BS_Activite__c) && mdtActivSegMap.get(acc.BS_Activite__c).Segment_SFDC__c!=null && mdtActivSegMap.get(acc.BS_Activite__c).Segment_SFDC__c!='') acc.BS_Segment__c = mdtActivSegMap.get(acc.BS_Activite__c).Segment_SFDC__c;
                            if(mdtActivSegMap.containsKey(acc.BS_Activite__c) && mdtActivSegMap.get(acc.BS_Activite__c).Activite_SFDC__c!=null && mdtActivSegMap.get(acc.BS_Activite__c).Activite_SFDC__c!='')acc.BS_Activite__c = mdtActivSegMap.get(acc.BS_Activite__c).Activite_SFDC__c;
                        }
                    } 
                }
            }
            
            //BS_Client_reserve__c
            if(acc.BS_Client_reserve__c != null && typeClientMap.get(acc.Id).RecordType.Name =='ADB') { 

                if(acc.BS_Client_reserve__c == 'F'){
                    acc.BS_Client_reserve__c = 'FNAIM';
                }
                else if(acc.BS_Client_reserve__c == 'U'){
                    acc.BS_Client_reserve__c = 'UNIS';
                }
            }

            for(contact con : contactsPrincipaux){
                if(con.AccountId == acc.Id){
                    contactsPrincipaux_lst.add(con);
                }
            }
            
            for(contact con : contactsGestionnaires){
                if(con.AccountId == acc.Id){
                    contactsGestionnaires_lst.add(con);
                }
            }
            
            //Task Creation
            if(acc.BS_Date_convention_PE_signee__c != null){

                //création tâche relance si date conv renseigné et supérieur à J-15
                if(acc.BS_Date_convention_PE_signee__c > system.today().addDays(-15) && BS_Date_convention_PE_signeeMap.containsKey(acc.BS_Id_ClientAzur__c) && acc.BS_Date_convention_PE_signee__c != BS_Date_convention_PE_signeeMap.get(acc.BS_Id_ClientAzur__c).BS_Date_convention_PE_signee__c){

                    task relanceGardien= new task();
                    relanceGardien.Priority='Normale';
                    relanceGardien.recordtypeid= recordtypeid;
                    relanceGardien.Subject='Relance Gardiens';
                    relanceGardien.WhatId=acc.id;
                    relanceGardien.status='Ouvert';
                    relanceGardien.ActivityDate=Date.ValueOf(acc.BS_Date_convention_PE_signee__c).addMonths(1);

                    //Nom et prénom du contact
                    if(contactsPrincipaux_lst.size()==1){
                        relanceGardien.WhoId= contactsPrincipauxMap.get(acc.Id).Id;
                    }
                    else if(contactsPrincipaux_lst.size()>1){
                        
                        if(contactsGestionnaires_lst.size()>0){
                            relanceGardien.WhoId= contactsGestionnairesMap.get(acc.Id).Id;
                        }else{
                            relanceGardien.WhoId= contactsPrincipauxMap.get(acc.Id).Id;
                        }
                    }
                    if(acc.BS_Vendeur_PE__c!=null  && vendeursPEMap.size()>0 && vendeursPEMap.containsKey(acc.BS_Vendeur_PE__c)){ 

                        relanceGardien.ownerid =vendeursPEMap.get(acc.BS_Vendeur_PE__c).Id;
                        
                    }
                    else{
                        relanceGardien.ownerid =System.Label.BS_ManagerCoPE;
                    }
                    insertTaskList.add(relanceGardien);
                }
            }
            else{
                acc.BS_Date_convention_PE_signee__c = null;
            }
            
            insertAccountList.add(acc);
        }
        
        if(insertAcctmemMRList.size() > 0){
            insert insertAcctmemMRList;
        }
        
        if(insertTaskList.size() > 0){
            insert insertTaskList;
        }
    }
    
    public static void accountBeforeInsert(List<Account> accountList){
        
        Set<Id> bsvstSet = new Set<Id>();
        Set<Id> bsvpeSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        Set<String> BS_Code_VendeurSet = new Set<String>();
        Set<String> BS_ActiviteSet = new Set<String>();
        Map<String,Account> BS_Date_convention_PE_signeeMap = new Map<String,Account>();
        Map<String, User> vendeursmpMap = new Map<String, User>();
        Map<String,ActivitesSegments__mdt> mdtActivSegMap = new Map<String,ActivitesSegments__mdt>();
        Map<Id,AccountTeamMember> actmMap = new Map<Id,AccountTeamMember>();
        List<AccountTeamMember> insertAcctmemMRList = new List<AccountTeamMember>();
        List<Account> insertAccountList = new List<Account>();
        List<Task> insertTaskList = new List<Task>();

        for(Account ac:accountList){

            if(ac.BS_Vendeur_Solution_technique__c != null){
                bsvstSet.add(Id.ValueOf(ac.BS_Vendeur_Solution_technique__c));
            }

            if(ac.BS_Vendeur_PE__c != null){
                bsvpeSet.add(Id.ValueOf(ac.BS_Vendeur_PE__c));
            }

            BS_Code_VendeurSet.add(ac.BS_Code_Vendeur__c);
            BS_ActiviteSet.add(ac.BS_Activite__c);
            accountIdSet.add(ac.Id);
            BS_Date_convention_PE_signeeMap.put(ac.BS_Id_ClientAzur__c,ac);
        }
        
        List<User> VendeursMP = [SELECT id, name, BS_Gestionnaire_de_clientele__c, BS_Trigramme__c FROM user WHERE BS_Trigramme__c IN :BS_Code_VendeurSet AND IsActive = true];

        List<ActivitesSegments__mdt> mdtActivSeg = [SELECT MasterLabel, QualifiedApiName, Activite_Azur__c,Activite_SFDC__c,Segment_SFDC__c FROM ActivitesSegments__mdt WHERE Activite_Azur__c IN :BS_ActiviteSet]; 

        Map<Id, Account> typeClientMap = new Map<Id, Account>([SELECT Id, RecordType.Name, RecordTypeId FROM Account WHERE Id IN :accountIdSet]);

        List<AccountTeamMember> actm=[SELECT id, AccountId, TeamMemberRole, UserId FROM AccountTeamMember WHERE AccountId IN :accountIdSet AND TeamMemberRole='Commercial MR'];
        
        Map<Id, User> vendeursSTMap = new Map<Id, User>([SELECT Id, name, BS_Trigramme__c FROM user WHERE Id IN :bsvstSet AND IsActive = true]);
        
        Map<Id, User> vendeursSTGestionnaireMap = new Map<Id, User>([SELECT Id, name, BS_Trigramme__c,BS_Gestionnaire_de_clientele__c FROM user WHERE Id IN :bsvstSet AND IsActive = true]);
        
        Map<Id, User> vendeursPEMap = new Map<Id, User>([SELECT Id, name, BS_Trigramme__c FROM user WHERE Id IN :bsvpeSet AND IsActive = true]);

        for(User u:vendeursMP){vendeursmpMap.put(u.BS_Trigramme__c,u);}

        for(ActivitesSegments__mdt mdt: mdtActivSeg){mdtActivSegMap.put(mdt.Activite_Azur__c,mdt);}        
        
        for(AccountTeamMember atm :actm){actmMap.put(atm.AccountId,atm);}

        for(Account acc : accountList){
            
            //BS_Code_Vendeur__c, OwnerId, BS_Gestionnaire_de_clientele__c
            if(acc.BS_Code_Vendeur__c!=null && acc.BS_Code_Vendeur__c!='' && vendeursmpMap.containsKey(acc.BS_Code_Vendeur__c) && vendeursMP.size()>0){              
                acc.BS_Code_Vendeur__c =acc.BS_Code_Vendeur__c;
                acc.OwnerId = vendeursmpMap.get(acc.BS_Code_Vendeur__c).id; 
                if(vendeursmpMap.get(acc.BS_Code_Vendeur__c).BS_Gestionnaire_de_clientele__c != null){
                acc.BS_Gestionnaire_de_clientele__c = vendeursmpMap.get(acc.BS_Code_Vendeur__c).BS_Gestionnaire_de_clientele__c;
                }                    
            }else{
                acc.BS_Code_Vendeur__c =acc.BS_Code_Vendeur__c;
                acc.OwnerId =System.Label.BS_Automate_ID; 
                acc.BS_Gestionnaire_de_clientele__c =System.Label.BS_Automate_ID;                      
            }
            
            //BS_Vendeur_Solution_technique__c
            if(acc.BS_Vendeur_Solution_technique__c == null){
                acc.BS_Vendeur_Solution_technique__c =System.Label.BS_Automate_ID; 
            }
            
            //Gestionnaire_de_client_le_Indisp__c
            if(acc.BS_Vendeur_Solution_technique__c != null && vendeursSTGestionnaireMap.size()>0 && vendeursSTGestionnaireMap.containsKey(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)) && vendeursSTGestionnaireMap.get(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)).BS_Gestionnaire_de_clientele__c != null){              
                                                                
                acc.Gestionnaire_de_client_le_Indisp__c =vendeursSTGestionnaireMap.get(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)).BS_Gestionnaire_de_clientele__c;                    
            }else{
              
                acc.Gestionnaire_de_client_le_Indisp__c =System.Label.BS_Automate_ID;                      
            }
            
            //BS_Vendeur_PE__c
            if(acc.BS_Vendeur_PE__c == null){  

                acc.BS_Vendeur_PE__c=System.Label.BS_ManagerCoPE; 
            }
            
            if(acc.RecordTypeId != null){

                //ADB -> BS_Activite_ADB__c
                if(acc.RecordTypeId == System.Label.BS_nom_recordtype_ADB){
                    //acc.RecordTypeId=System.Label.BS_nom_recordtype_ADB;
                    acc.BS_Activite_ADB__c=acc.BS_Activite_ADB__c;
                    
                }
                //CFE -> BS_Segment__c, BS_Activite__c
                else if(acc.RecordTypeId == System.Label.BS_nom_recordtype_CFE){

                    if(mdtActivSeg.size()>0){
                        if(mdtActivSegMap.containsKey(acc.BS_Activite__c) && mdtActivSegMap.get(acc.BS_Activite__c).Segment_SFDC__c!=null && mdtActivSegMap.get(acc.BS_Activite__c).Segment_SFDC__c!=''){acc.BS_Segment__c = mdtActivSegMap.get(acc.BS_Activite__c).Segment_SFDC__c;}
                        if(mdtActivSegMap.containsKey(acc.BS_Activite__c) && mdtActivSegMap.get(acc.BS_Activite__c).Activite_SFDC__c!=null && mdtActivSegMap.get(acc.BS_Activite__c).Activite_SFDC__c!=''){acc.BS_Activite__c = mdtActivSegMap.get(acc.BS_Activite__c).Activite_SFDC__c;}
                    } 
                }
            }
            
            //BS_Client_reserve__c
            if(acc.BS_Client_reserve__c!=null && acc.BS_Client_reserve__c!='') { 

                if(acc.BS_Client_reserve__c=='F'){
                    acc.BS_Client_reserve__c='FNAIM';
                }
                else if(acc.BS_Client_reserve__c=='U'){
                    acc.BS_Client_reserve__c='UNIS';
                }
            }
        }    
    }
    
    public static void accountAfterInsert(List<Account> accountList){
       
        Set<Id> bsvstSet = new Set<Id>();
        Set<Id> bsvpeSet = new Set<Id>();
        Set<Id> accountIdSet = new Set<Id>();
        Set<String> BS_Code_VendeurSet = new Set<String>();
        Set<String> BS_ActiviteSet = new Set<String>();
        Map<String,Account> BS_Date_convention_PE_signeeMap = new Map<String,Account>();
        Map<Id,Contact>contactsPrincipauxMap = new Map<Id,Contact>();
        Map<Id,Contact>contactsGestionnairesMap = new Map<Id,Contact>();
        List<AccountTeamMember> insertAcctmemMRList = new List<AccountTeamMember>();
        List<Task> insertTaskList = new List<Task>();

        for(Account ac:accountList){

            if(ac.BS_Vendeur_Solution_technique__c != null){
                bsvstSet.add(Id.ValueOf(ac.BS_Vendeur_Solution_technique__c));
            }
            if(ac.BS_Vendeur_PE__c != null){
                bsvpeSet.add(Id.ValueOf(ac.BS_Vendeur_PE__c));
            }
            BS_Code_VendeurSet.add(ac.BS_Code_Vendeur__c);
            BS_ActiviteSet.add(ac.BS_Activite__c);
            accountIdSet.add(ac.Id);
            BS_Date_convention_PE_signeeMap.put(ac.BS_Id_ClientAzur__c,ac);
        }
        
        Map<Id, User> vendeursSTMap = new Map<Id, User>([SELECT Id, name, BS_Trigramme__c FROM user WHERE Id IN :bsvstSet AND IsActive = true]);
        
        Map<Id, User> vendeursPEMap = new Map<Id, User>([SELECT Id, name, BS_Trigramme__c FROM user WHERE Id IN :bsvpeSet AND IsActive = true]);
        
        Id contactClientRtId=[Select Id,SobjectType,Name From RecordType where Name ='Contact Client' and SobjectType ='Contact'  limit 1].Id;
        
        List<contact> contactsPrincipaux=[select Id,AccountId, BS_Principal__c, title, recordtypeId from contact where AccountId IN :accountIdSet and BS_Principal__c=true and recordtypeId= :contactClientRtId ];
        
        List<contact> contactsGestionnaires=[select Id,AccountId, BS_Principal__c, title, recordtypeId from contact where AccountId= :accountIdSet and BS_Principal__c=true and title='Gestionnaire' and recordtypeId= :contactClientRtId];
        
        Id recordtypeid = [Select Id,SobjectType,Name From RecordType where Name ='Relance Gardiens' and SobjectType ='Task'  limit 1].Id;
        
        for(Contact con:contactsPrincipaux){contactsPrincipauxMap.put(con.AccountId,con);}
        
        for(Contact con:contactsGestionnaires){contactsGestionnairesMap.put(con.AccountId,con);}
        
        for(Account acc: accountList){
            AccountTeamMember acctmemMR = new AccountTeamMember();  
            List<contact> contactsPrincipaux_lst = new List<contact>();
            List<contact> contactsGestionnaires_lst = new List<contact>();

             //AccountTeamMember
            if(VendeursSTMap.size()>0 && VendeursSTMap.containsKey(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c))){
                /*
                acctmemMR.AccountId=acc.id;
                acctmemMR.TeamMemberRole='Commercial MR';
                acctmemMR.UserId=vendeursSTMap.get(Id.ValueOf(acc.BS_Vendeur_Solution_technique__c)).id;
                acctmemMR.OpportunityAccessLevel='Edit';
                acctmemMR.AccountAccessLevel='Edit';
                insertAcctmemMRList.add(acctmemMR);
LMS 11/10/2024 : Logique déja dans un flow
*/
            }

            for(contact con : contactsPrincipaux){
                
                if(con.AccountId == acc.Id){
                    contactsPrincipaux_lst.add(con);
                }
            }

            for(contact con : contactsGestionnaires){

                if(con.AccountId == acc.Id){
                    contactsGestionnaires_lst.add(con);
                }
            }

            //Task Creation
            if(acc.BS_Date_convention_PE_signee__c != null){
                if(Date.ValueOf(acc.BS_Date_convention_PE_signee__c)>system.today().addDays(-15)){

                    task relanceGardien= new task();

                    relanceGardien.Priority='Normale';
                    relanceGardien.recordtypeid=recordtypeid;
                    relanceGardien.Subject='Relance Gardiens';
                    relanceGardien.WhatId=acc.id;
                    relanceGardien.status='Ouvert';
                    relanceGardien.ActivityDate=Date.ValueOf(acc.BS_Date_convention_PE_signee__c).addMonths(1);
                    
                    if(contactsPrincipaux_lst.size()==1){
                        relanceGardien.WhoId= contactsPrincipauxMap.get(acc.Id).Id;
                    }
                    else if(contactsPrincipaux_lst.size()>1){
                        
                        if(contactsGestionnaires_lst.size()>0){
                            relanceGardien.WhoId= contactsGestionnairesMap.get(acc.Id).Id;
                        }else{
                            relanceGardien.WhoId= contactsPrincipauxMap.get(acc.Id).Id;
                        }
                        
                    }

                    if(acc.BS_Vendeur_PE__c!=null  && VendeursPEMap.size()>0 && VendeursPEMap.containsKey(acc.BS_Vendeur_PE__c)){ 

                        relanceGardien.ownerid =vendeursPEMap.get(acc.BS_Vendeur_PE__c).id;  
                    }
                    else{
                        relanceGardien.ownerid =System.Label.BS_ManagerCoPE;
                    }
                    insertTaskList.add(relanceGardien);
                }
            }
        }
             
        if(insertAcctmemMRList.size() > 0){
            insert insertAcctmemMRList;
        }
            
        if(insertTaskList.size() > 0){
            insert insertTaskList;
        }
    }
}