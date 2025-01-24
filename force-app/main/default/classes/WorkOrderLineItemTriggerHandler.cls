public class WorkOrderLineItemTriggerHandler {
    
    public static void woliAfterInsert(List<WorkOrderLineItem> woliList){
        
        Set<Id> parentWorkOrderLineItemIdSet = new Set<Id>();
        Map<Id, Id> woliIdMap = new Map<Id, Id>();
        List<Lot1__c> lot1InsertList = new List<Lot1__c>();
        List<AffectedEquipmentsProducts__c> equipmentInsertList = new List<AffectedEquipmentsProducts__c> ();
        List<ActionPlan__c> actionInsertList = new List<ActionPlan__c> ();
        List<WorkOrderLineItem> newwoliList = new List<WorkOrderLineItem> ();
        
        for (WorkOrderLineItem woli : woliList) {
            
            if(woli.OpePrec__c  != null){
                parentWorkOrderLineItemIdSet.add(woli.OpePrec__c );
                woliIdMap.put(woli.OpePrec__c , woli.Id);
            }
        }
        
        if(parentWorkOrderLineItemIdSet.size()>0){
            
            List<Lot1__c> lotsList = [SELECT Id, OwnerId, IsDeleted, Name,Location__c,Level__c, LotStatus__c, WOLI__c, LotType__c, InfestationLevel__c, DateTime__c, PestType__c, Number__c, LocationType__c, Comment__c, 
                                      OccupantName__c, DamageClass__c, Key__c  FROM Lot1__c WHERE WOLI__c =: parentWorkOrderLineItemIdSet];
            
            List<AffectedEquipmentsProducts__c> equipmentList =[SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId,  
                                                                WOLI__c, TrapNumber__c, Location__c, Type_de_Logement__c, Status__c, Areas__c, ItemClass__c, ConsumptionIndex__c, CaptureIndex__c, 
                                                                Site__c, BundleNumber__c, DeviceState__c, Category__c, AMM__c, Quantity__c, PumpSpot__c, ApplicationMethod__c, Unity__c, Product__c,
                                                                Act__c, Asset__c, Wording__c, Name__c,FuseBoxSpot__c, ConnexionsPowerSupplyCheck__c, PumpsCleaning__c, LevelRegulatorsCheck__c, AntiReturnValve__c, 
                                                                InletFilterCheck__c, Tech_SiteId__c, AssetComment__c FROM AffectedEquipmentsProducts__c WHERE WOLI__c IN :parentWorkOrderLineItemIdSet];
            
            List<ActionPlan__c> actionList = [SELECT Id, OwnerId, IsDeleted, Name, Observation__c, Date__c, ActionsTBD__c, Done__c, 
                                              Location__c, WOLI__c, Adressee__c FROM  ActionPlan__c WHERE WOLI__c IN :parentWorkOrderLineItemIdSet];
            
            for(Lot1__c lo :lotsList){
                
                Lot1__c lots = new Lot1__c();
                
                lots.OwnerId = lo.OwnerId;
                lots.Name = lo.Name;
                lots.Location__c = lo.Location__c;
                lots.Level__c = lo.Level__c;
                lots.LotStatus__c = lo.LotStatus__c;
                lots.WOLI__c = woliIdMap.get(lo.WOLI__c);
                lots.LotType__c = lo.LotType__c;
                lots.InfestationLevel__c = lo.InfestationLevel__c;
                lots.DateTime__c = lo.DateTime__c;
                lots.PestType__c = lo.PestType__c;
                lots.Number__c = lo.Number__c;
                lots.LocationType__c = lo.LocationType__c;
                lots.Comment__c = lo.Comment__c;
                lots.OccupantName__c = lo.OccupantName__c;
                lots.DamageClass__c = lo.DamageClass__c;
                lots.Cloned__c = true;
                lots.Key__c = lo.Key__c;
                
                lot1InsertList.add(lots);
            }
            
            for(AffectedEquipmentsProducts__c aep : equipmentList){
                
                AffectedEquipmentsProducts__c  equipment = new AffectedEquipmentsProducts__c();
                
                equipment.AntiReturnValve__c = aep.AntiReturnValve__c;
                equipment.ApplicationMethod__c = aep.ApplicationMethod__c;
                equipment.Areas__c = aep.Areas__c;
                equipment.Asset__c = aep.Asset__c;
                equipment.CaptureIndex__c = aep.CaptureIndex__c;
                equipment.ConnexionsPowerSupplyCheck__c = aep.ConnexionsPowerSupplyCheck__c;
                equipment.ConsumptionIndex__c = aep.ConsumptionIndex__c;
                equipment.DeviceState__c = aep.DeviceState__c;
                equipment.InletFilterCheck__c = aep.InletFilterCheck__c;
                equipment.ItemClass__c = aep.ItemClass__c;
                equipment.LevelRegulatorsCheck__c = aep.LevelRegulatorsCheck__c;
                equipment.Location__c = aep.Location__c;
                equipment.OwnerId = aep.OwnerId;
                equipment.Product__c = aep.Product__c;
                equipment.PumpsCleaning__c = aep.PumpsCleaning__c;
                equipment.Quantity__c = aep.Quantity__c;
                equipment.RecordTypeId = aep.RecordTypeId;
                equipment.Site__c = aep.Site__c;
                equipment.Status__c = aep.Status__c;
                equipment.TrapNumber__c = aep.TrapNumber__c;
                equipment.Type_de_Logement__c = aep.Type_de_Logement__c;
                equipment.Unity__c = aep.Unity__c;
                equipment.WOLI__c = woliIdMap.get(aep.WOLI__c);
                equipment.Cloned__c = true;
                
                equipmentInsertList.add(equipment);
            }
            
            for(ActionPlan__c act : actionList){
                
                ActionPlan__c action = new 	ActionPlan__c();
                
                action.OwnerId = act.OwnerId;
                action.Observation__c = act.Observation__c;
                action.Date__c = act.Date__c;
                action.ActionsTBD__c = act.ActionsTBD__c;
                action.Adressee__c = act.Adressee__c;
                action.Done__c = act.Done__c;
                action.WOLI__c = woliIdMap.get(act.WOLI__c);
                action.Location__c = act.Location__c;
                action.Cloned__c = true;
                
                actionInsertList.add(action);
            }
            
            if(lot1InsertList.size()>0){
                Insert lot1InsertList;
            }
            
            if(equipmentInsertList.size()>0){
                Insert equipmentInsertList;
            }
            
            if(actionInsertList.size()>0){
                Insert actionInsertList;
            }
            
            // Update the Tech_LotsAbsentsGenerated__c field to true for all WorkOrderLineItems in the woliList
            for (WorkOrderLineItem woliItr : woliList) {
                WorkOrderLineItem woli = new WorkOrderLineItem();
                woli.Id=woliItr.Id;
                woli.Tech_LotsAbsentsGenerated__c = true;
                newwoliList.add(woli);
            }
            if(newwoliList.size()>0){
                update newwoliList;
            }
        }   
    }
}