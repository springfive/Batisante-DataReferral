public class ServiceAppointmentTriggerHandler {
    
    public static void serviceappointmentAfterUpdate(List<ServiceAppointment> serviceappointmentList, Map<Id, ServiceAppointment> OldRecordMap){
        
        //Prevent Recursive Trigger callouts
        if (TriggerHelper.hasServiceAppointmentTriggerRun) {
            return;
        }
        TriggerHelper.hasServiceAppointmentTriggerRun = true;
        
        List<AssignedResource> arlist = new List<AssignedResource>();
        List<String> intervenantValues = new List<String>();
        Set<String> intervenantSet = new Set<String>();
        Set<Id> serviceappointmentIdSet = new Set<Id>();
        Map<Id, AssignedResource> assignedResourceIdMap = new Map<Id, AssignedResource>();
        Map<Id, List<AssignedResource>> assignedResourcesByServiceAppointment = new Map<Id, List<AssignedResource>>();
        Map<String,ServiceResource> serviceResourceMap = new Map<String,ServiceResource>();
        List<AssignedResource> deletelst = new List<AssignedResource>();
        List<ServiceAppointment> updateServiceAppointmentlst = new List<ServiceAppointment>();
        List<ServiceAppointment> updateServiceAppointmentschtimelst = new List<ServiceAppointment>();
        Set<Id> sa_id_set = new Set<Id>();
        
        //Split & store Intervenant__c, ServiceappointmentId in Set Variables
        for (ServiceAppointment sa : serviceappointmentList) {
            
            if (!String.isEmpty(sa.Intervenant__c)) {
                intervenantValues = sa.Intervenant__c.split('/');
            }
            intervenantSet.addAll(intervenantValues);
            serviceappointmentIdSet.add(sa.Id);
        }
        
        //Split & store old Intervenant__c in Set Variable for the old ServiceApoointment records
        for (Id sa_id : OldRecordMap.keySet()) {
            
            if (!String.isEmpty(OldRecordMap.get(sa_id).Intervenant__c)) {
                intervenantValues = OldRecordMap.get(sa_id).Intervenant__c.split('/');
            }
            intervenantSet.addAll(intervenantValues);
        }
        
        //AssignedResource fetch using serviceappointedid set
        List<AssignedResource> assignedResourceOldIdList = new List<AssignedResource>([Select Id, ServiceAppointmentId, ServiceResourceId, ServiceResource.Trigramme__c From AssignedResource Where ServiceAppointmentId IN :serviceappointmentIdSet]);
        
        //Map AssignedResource record with ServiceAppointmentId
        for (AssignedResource ar : assignedResourceOldIdList) {
            
            assignedResourceIdMap.put(ar.ServiceResourceId, ar);
            
            if (!assignedResourcesByServiceAppointment.containsKey(ar.ServiceAppointmentId)) {
                assignedResourcesByServiceAppointment.put(ar.ServiceAppointmentId, new List<AssignedResource>{ar});
            }else {
                assignedResourcesByServiceAppointment.get(ar.ServiceAppointmentId).add(ar);
            }
            
        }
        
        //ServiceResource fetch using intervenant set
        List<ServiceResource> serviceResourceList = [SELECT Id,Trigramme__c,IsActive FROM ServiceResource WHERE Trigramme__c IN :intervenantSet AND IsActive = true];
        
        //Map ServiceResource record with Trigramme__c(Intervenant__c) value
        for (ServiceResource sr : serviceResourceList) {serviceResourceMap.put(sr.Trigramme__c, sr);}
        
        //Iterate over serviceappointmentList
        for(ServiceAppointment sa : serviceappointmentList){

            System.debug('Iterating Service Appointment =>'+sa);

            ServiceAppointment newinstance = new ServiceAppointment();
            ServiceAppointment newinstanceschtime = new ServiceAppointment();
            List<String> intervenantVal = new List<String>(); 
            List<String> oldintervenantVal = new List<String> ();
            String oldIntervenantString;
            
            //Get AssignedResource List related to the iterating Service Appointment instance  
            List<AssignedResource> ar_lst = assignedResourcesByServiceAppointment.get(sa.Id);
            System.debug('AssignedResourceList => '+ar_lst);

            Map<Id, AssignedResource> arIdMap = new Map<Id, AssignedResource>();
            
            //Split Intervenant__c value for the iterating Service Appointment instance  
            if (sa.Intervenant__c != null && !String.isEmpty(sa.Intervenant__c)) {
                
                intervenantVal = sa.Intervenant__c.split('/');
            }
            
            
            if(ar_lst!=null && ar_lst.size()>0){
                for(AssignedResource al : ar_lst){
                    oldintervenantVal.add(al.ServiceResource.Trigramme__c);
                }
                oldIntervenantString = String.join(oldintervenantVal, '/');
            }
            
            //Split old record's Intervenant__c value for the iterating Service Appointment instance
            /*if(OldRecordMap.get(sa.Id).Intervenant__c != '' && OldRecordMap.get(sa.Id).Intervenant__c !=null){

oldintervenantVal = OldRecordMap.get(sa.Id).Intervenant__c.split('/');
System.debug('OldRecordMap.get(sa.Id).Intervenant__c. => '+ OldRecordMap.get(sa.Id).Intervenant__c.split('/'));
}*/
            
            if(ar_lst!=null && ar_lst.size()>0){
                
                //Map AssignedResource record with ServiceResourceId
                for(AssignedResource ar: ar_lst){
                    if(ar.ServiceAppointmentId == sa.id){arIdMap.put(ar.ServiceResourceId,ar);}
                }
            }
            /*System.debug('old=> '+OldRecordMap.get(sa.Id).Intervenant__c);
System.debug('old=> '+oldIntervenantString);
System.debug('new=> '+sa.Intervenant__c);*/
            //Check if Intervenant__c has size more than 0 & old Intervenant__c != new  Intervenant__c
            System.debug('Iterating Service appointments oldIntervenantString=>' + oldIntervenantString);
            System.debug('Iterating Service appointments sa.Intervenant__c=>' + sa.Intervenant__c);
            if(intervenantVal.size()>0 && sa.Intervenant__c != oldIntervenantString){

                //Iterate over new Intervenant values
                for(String intervenant: intervenantVal){
                    
                    //Check if the old list has some values
                    if(ar_lst!=null && arIdMap.size()>0){
                        
                        //Check if intervenant exists in old AssignedResource map & 
                        //AssignedResourceId doesn't exist in AssignedResource map for iterating instance
                        if(serviceResourceMap.containsKey(intervenant) && !arIdMap.containsKey(serviceResourceMap.get(intervenant).Id)){
                            
                            //Update SchedStartTime, SchedEndTime
                            newinstanceschtime.Id = sa.Id;
                            newinstanceschtime.SchedStartTime = sa.EarliestStartTime;
                            newinstanceschtime.SchedEndTime = sa.DueDate;
                            if(sa.Intervenant__c == null || sa.Intervenant__c == ''){
                                newinstance.Id = sa.Id;
                                newinstance.Status = 'Aucun';
                                if(!updateServiceAppointmentlst.contains(newinstance)){
                                    updateServiceAppointmentlst.add(newinstance);
                                }
                            }else{
                                newinstance.Id = sa.Id;
                                newinstance.Status = 'Expédié';
                                if(!updateServiceAppointmentlst.contains(newinstance)){
                                    updateServiceAppointmentlst.add(newinstance);
                                }
                            }
                            
                            //Update updateServiceAppointmentschtimelst if instance doesn't already exist.
                            if(!updateServiceAppointmentschtimelst.contains(newinstanceschtime)){
                                updateServiceAppointmentschtimelst.add(newinstanceschtime);
                            }
                            //Create AssignedResource for iterating ServiceAppointment instance and update list
                            AssignedResource ar = new AssignedResource();
                            ar.ServiceAppointmentId = sa.Id;
                            ar.ServiceResourceId = serviceResourceMap.get(intervenant).Id;
                            arlist.add(ar);
                            
                        }
                    }
                    
                    //Check old AssignedResorce list related to this ServiceAppointment instance has no values & 
                    //intervenant exists in Old AssignedResource Map 
                    if(ar_lst==null && arIdMap.size()==0 && serviceResourceMap.containsKey(intervenant)){
                        
                        //Update SchedStartTime, SchedEndTime, Status
                        newinstanceschtime.Id = sa.Id;
                        newinstanceschtime.SchedStartTime = sa.EarliestStartTime;
                        newinstanceschtime.SchedEndTime = sa.DueDate;
                        //newinstanceschtime.Status = 'Expédié';
                        //If Intervenant__c is empty update Status to 'Aucun'
                        if(sa.Intervenant__c == null || sa.Intervenant__c == ''){
                            newinstance.Id = sa.Id;
                            newinstance.Status = 'Aucun';
                            if(!updateServiceAppointmentlst.contains(newinstance)){
                                updateServiceAppointmentlst.add(newinstance);
                            }
                        }else{
                            newinstance.Id = sa.Id;
                            newinstance.Status = 'Expédié';
                            if(!updateServiceAppointmentlst.contains(newinstance)){
                                updateServiceAppointmentlst.add(newinstance);
                            }
                        }
                        
                        //Update updateServiceAppointmentschtimelst if instance doesn't already exist.
                        if(!updateServiceAppointmentschtimelst.contains(newinstanceschtime)){
                            updateServiceAppointmentschtimelst.add(newinstanceschtime);
                        }
                        
                        //Create AssignedResource for iterating ServiceAppointment instance and update list
                        AssignedResource ar = new AssignedResource();
                        ar.ServiceAppointmentId = sa.Id;
                        ar.ServiceResourceId = serviceResourceMap.get(intervenant).Id;
                        arlist.add(ar);
                        
                    }
                    
                }
                
                //Iterate over old intervenant
                for(String oldintervenant : oldintervenantVal){
                    
                    //Check intervenantval list doesn't contains old intervenant value &
                    //old intervenant exists in Old AssignedResource Map 
                    if(!intervenantVal.contains(oldintervenant) && serviceResourceMap.containsKey(oldintervenant)){
                        
                        //Create a AssignedResource instance and update the Id
                        AssignedResource delar = arIdMap.get(serviceResourceMap.get(oldintervenant).Id);
                        
                        if(delar!=null){
                            
                            deletelst.add(delar);
                        }
                    }
                }
                
                //Check if oldAR list is not empty.
                if(ar_lst!=null && ar_lst.size()>0){
                    //Add AR to deletelst if newIntervenantval doesn't have the trigramme value from AR record.
                    for(AssignedResource al : ar_lst){
                        if(!intervenantVal.contains(al.ServiceResource.Trigramme__c) && !deletelst.contains(al)){
                            deletelst.add(al);
                            
                        }
                    }
                }
            }
            
            //Check AssignedResource List related to iterating SR instance is not null and size is above 0 &
            //Intervenant__c value is null or empty
            else if(ar_lst!=null && ar_lst.size()>0 && (sa.Intervenant__c == null || sa.Intervenant__c == '')){
                
                //Update the deletelst List
                for(AssignedResource al : ar_lst)
                {  
                    deletelst.add(al);
                }
                
            }
            
            //Check AssignedResource List related to iterating SR instance is  null or size is equal 0 &
            //Status = 'Expédié' &
            //Intervenant__c = null or Empty
            else if((ar_lst==null || ar_lst.size()==0) && sa.Status == 'Expédié' && (sa.Intervenant__c == null || sa.Intervenant__c == '')){
                
                //Update Status = Aucun
                newinstance.Id = sa.Id;
                newinstance.Status = 'Aucun';
                
                //Update updateServiceAppointmentlst if instance doesn't already exist.
                if(!updateServiceAppointmentlst.contains(newinstance)){
                    updateServiceAppointmentlst.add(newinstance);
                }
            }
            
            //Check Status = Aucun or None &
            //Intervenant__c = null or empty
            if( (sa.Status == 'Aucun'|| sa.Status == 'None') && (sa.Intervenant__c!='' && sa.Intervenant__c!=null)){
                
                //Update Status = 'Expédié'
                newinstance.Id = sa.Id;
                newinstance.Status = 'Expédié';
                
                //Update updateServiceAppointmentlst if instance doesn't already exist.
                if(!updateServiceAppointmentlst.contains(newinstance)){
                    updateServiceAppointmentlst.add(newinstance);
                }
            }
            
        }
        
        System.debug('delete list => ' + deletelst);
        //Delete AssignedResorce
        if(deletelst!=null && deletelst.size()>0){
            
            Delete deletelst;
        }
        
        //Add deleted ServiceAppointmentId to a set
        for(AssignedResource ar: deletelst){
            sa_id_set.add(ar.ServiceAppointmentId);
        }
        
        //Fetch ServiceAppointment's with set Id's
        List<ServiceAppointment> SALST = [SELECT Id, Status, Intervenant__c, SchedStartTime, SchedEndTime, EarliestStartTime, DueDate  FROM ServiceAppointment Where Id IN : sa_id_set];
        
        if(SALST.size()>0){
            
            //Iterate over ServiceAppointment
            for(ServiceAppointment sa : SALST){
                
                ServiceAppointment newinstanceschtime = new ServiceAppointment();
                ServiceAppointment newinstance = new ServiceAppointment();
                
                
                //If Intervenant__c = null or empty Update status = Aucun
                if(sa.Intervenant__c == null || sa.Intervenant__c == ''){
                    newinstance.Id = sa.Id;
                    newinstance.Status = 'Aucun';
                    if(!updateServiceAppointmentlst.contains(newinstance)){
                        updateServiceAppointmentlst.add(newinstance);
                    }
                }
                
                //If SchedStartTime & SchedEndTime is null Update those fields
                if(sa.SchedStartTime == null && sa.SchedEndTime == null){
                    newinstanceschtime.Id = sa.Id;
                    newinstanceschtime.SchedStartTime = sa.EarliestStartTime;
                    //newinstanceschtime.Status = 'Aucun';
                    newinstanceschtime.SchedEndTime = sa.DueDate;
                }
                
                //Update updateServiceAppointmentschtimelst if instance doesn't already exist.
                if(!updateServiceAppointmentschtimelst.contains(newinstanceschtime) && newinstanceschtime.Id!=null){
                    updateServiceAppointmentschtimelst.add(newinstanceschtime);
                }
                
            }
        }
        
        System.debug('Update scheduled time for serviceappointment lst => ' + updateServiceAppointmentschtimelst);
        //Update SchedStarttime and SchedEndtime
        if(updateServiceAppointmentschtimelst!=null && updateServiceAppointmentschtimelst.size()>0){  
            Update updateServiceAppointmentschtimelst;
        }
        
        System.debug('Assigned Resource lst for Insertion => ' + arlist);
        //Insert AssignedResource
        if(arlist.size()>0){
            
            Insert arlist;
        }
        
        System.debug('Update ServiceAppointment lst for Status => ' + updateServiceAppointmentlst);
        //Update ServiceAppointment Status 
        if(updateServiceAppointmentlst.size()>0){
            
            Update updateServiceAppointmentlst;
        }
        TriggerHelper.hasServiceAppointmentTriggerRun = false;
    }
    
    public static void serviceappointmentAfterInsert(List<ServiceAppointment> serviceappointmentList){
        
        //Prevent Recursive Trigger callouts
        if (TriggerHelper.hasTriggerRun) {
            return;
        }
        
        TriggerHelper.hasTriggerRun = true;
        
        List<AssignedResource> arlist = new List<AssignedResource>();
        List<String> intervenantValues = new List<String>();
        Set<String> intervenantSet = new Set<String>();
        Set<Id> serviceappointmentIdSet = new Set<Id>();
        Map<Id, AssignedResource> assignedResourceIdMap = new Map<Id, AssignedResource>();
        Map<String,ServiceResource> serviceResourceMap = new Map<String,ServiceResource>();
        List<ServiceAppointment> updateServiceAppointmentlst = new List<ServiceAppointment>();
        
        //Split & store Intervenant__c, ServiceappointmentId in Set Variables
        for (ServiceAppointment sa : serviceappointmentList) {
            
            if (!String.isEmpty(sa.Intervenant__c)) {
                intervenantValues = sa.Intervenant__c.split('/');
            }
            intervenantSet.addAll(intervenantValues);
            
        }
        
        //ServiceResource fetch using intervenant set
        List<ServiceResource> serviceResourceList = [SELECT Id,Trigramme__c,IsActive FROM ServiceResource WHERE Trigramme__c IN :intervenantSet AND IsActive = true];
        
        //Map ServiceResource record with Trigramme__c(Intervenant__c) value
        for (ServiceResource sr : serviceResourceList) {serviceResourceMap.put(sr.Trigramme__c, sr);}
        
        //Iterate over ServiceAppointment
        for(ServiceAppointment sa : serviceappointmentList){
            
            ServiceAppointment newinstance = new ServiceAppointment();
            List<String> intervenantVal = new List<String>();
            
            System.debug('Iterating Service appointments sa.Intervenant__c=>' + sa.Intervenant__c);
            //Split Intervenant__c value for the iterating Service Appointment instance  
            if (!String.isEmpty(sa.Intervenant__c)) {
                intervenantVal = sa.Intervenant__c.split('/');
            }
            
            if(intervenantVal.size()>0){
                
                //Iterate over intervenantval values
                for(String intervenant: intervenantVal){
                    
                    //intervenant exists in Old AssignedResource Map 
                    if(serviceResourceMap.containsKey(intervenant)){
                        
                        //Create AssignedResource for iterating ServiceAppointment instance and update list
                        AssignedResource ar = new AssignedResource();
                        ar.ServiceAppointmentId = sa.Id;
                        ar.ServiceResourceId = serviceResourceMap.get(intervenant).Id;
                        arlist.add(ar);
                    }
                }
                
                //Update Status = 'Expédié'
                newinstance.Id = sa.Id;
                newinstance.Status = 'Expédié';
                updateServiceAppointmentlst.add(newinstance); 
            }
            else{
                
                //Update Status = 'Aucun'
                newinstance.Id = sa.Id;
                newinstance.Status = 'Aucun';
                updateServiceAppointmentlst.add(newinstance); 
                
            }
            
        }
        System.debug('Assigned Resource for Insert => ' + arlist);
        //Insert AssignedResource
        if(arlist.size()>0){
            
            Insert arlist;
        }
        System.debug('Update ServiceAppointment lst for Status => ' + updateServiceAppointmentlst);
        //Update ServiceAppointment Status 
        if(updateServiceAppointmentlst.size()>0){
            
            Update updateServiceAppointmentlst;
        }
        
    }
}