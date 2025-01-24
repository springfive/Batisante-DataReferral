public class Gestion_BDC_TriggerHandler {
    
    public static void gestion_BDC_BeforeUpdate(List<BS_BDC__c> gestion_BDC_List){
        
        Set<String> BS_PrestationSet = new Set<String>();
        Set<String> BS_StatutSet = new Set<String>();
        Map<String,TypeBDC__mdt> mdtBDCMap = new Map<String,TypeBDC__mdt>();
        Map<String,BS_statut_Contrat__mdt> mdtSatutMap = new Map<String,BS_statut_Contrat__mdt>();
        
        for(BS_BDC__c bdc : gestion_BDC_List){
            BS_PrestationSet.add(bdc.BS_Prestation__c);
            BS_StatutSet.add(bdc.BS_Statut__c);
        }
        
        List<TypeBDC__mdt> mdtBDC = [SELECT MasterLabel, QualifiedApiName, BS_Prestation__c, BS_Type1__c, BS_Type2__c FROM TypeBDC__mdt WHERE BS_Prestation__c IN :BS_PrestationSet];

        List<BS_statut_Contrat__mdt> mdtStatut = [SELECT MasterLabel, QualifiedApiName, BS_Code__c, BS_Statut__c FROM BS_statut_Contrat__mdt WHERE BS_Code__c IN :BS_StatutSet];
        
        for(TypeBDC__mdt mdt : mdtBDC){
            mdtBDCMap.put(mdt.BS_Prestation__c,mdt);
        }
        
        for(BS_statut_Contrat__mdt mdt : mdtStatut){
            mdtSatutMap.put(mdt.BS_Code__c,mdt);
        }
        
        for(BS_BDC__c bdc: gestion_BDC_List){
            
            //BS_Type1__c, BS_Type2__c
            if(bdc.BS_Prestation__c!=null && bdc.BS_Prestation__c!='' && mdtBDCMap.containsKey(bdc.BS_Prestation__c)){

                if(mdtBDC.size()>0){
                    bdc.BS_Type1__c = mdtBDCMap.get(bdc.BS_Prestation__c).BS_Type1__c;
                    bdc.BS_Type2__c = mdtBDCMap.get(bdc.BS_Prestation__c).BS_Type2__c; 
                }
            }
            
            //BS_Statut__c
            if(bdc.BS_Statut__c!=null && bdc.BS_Statut__c!='' && mdtSatutMap.containsKey(bdc.BS_Statut__c)){
                if(mdtStatut.size()>0){
                    bdc.BS_Statut__c = mdtSatutMap.get(bdc.BS_Statut__c).BS_Statut__c;
                }
            }
        }
    }
	
    public static void gestion_BDC_BeforeInsert(List<BS_BDC__c> gestion_BDC_List){
        
        Set<String> BS_PrestationSet = new Set<String>();
        Set<String> BS_StatutSet = new Set<String>();      
        Map<String,TypeBDC__mdt> mdtBDCMap = new Map<String,TypeBDC__mdt>();
        Map<String,BS_statut_Contrat__mdt> mdtSatutMap = new Map<String,BS_statut_Contrat__mdt>();

        for(BS_BDC__c bdc : gestion_BDC_List){
            BS_PrestationSet.add(bdc.BS_Prestation__c);
            BS_StatutSet.add(bdc.BS_Statut__c);
        }
        
        List<TypeBDC__mdt> mdtBDC = [SELECT MasterLabel, QualifiedApiName, BS_Prestation__c, BS_Type1__c, BS_Type2__c FROM TypeBDC__mdt WHERE BS_Prestation__c IN :BS_PrestationSet];

        List<BS_statut_Contrat__mdt> mdtStatut = [SELECT MasterLabel, QualifiedApiName, BS_Code__c, BS_Statut__c FROM BS_statut_Contrat__mdt WHERE BS_Code__c IN :BS_StatutSet];
        
        for(TypeBDC__mdt mdt : mdtBDC){
            mdtBDCMap.put(mdt.BS_Prestation__c,mdt);
        }
        
        for(BS_statut_Contrat__mdt mdt : mdtStatut){
            mdtSatutMap.put(mdt.BS_Code__c,mdt);
        }
        
        for(BS_BDC__c bdc: gestion_BDC_List){
            
            //BS_Type1__c, BS_Type2__c
            if(bdc.BS_Prestation__c!=null && bdc.BS_Prestation__c!='' && mdtBDCMap.containsKey(bdc.BS_Prestation__c)){

                if(mdtBDC.size()>0){
                    bdc.BS_Type1__c = mdtBDCMap.get(bdc.BS_Prestation__c).BS_Type1__c;
                    bdc.BS_Type2__c = mdtBDCMap.get(bdc.BS_Prestation__c).BS_Type2__c; 
                }
            }
            
            //BS_Statut__c
            if(bdc.BS_Statut__c!=null && bdc.BS_Statut__c!='' && mdtSatutMap.containsKey(bdc.BS_Statut__c)){
                if(mdtStatut.size()>0){
                    bdc.BS_Statut__c = mdtSatutMap.get(bdc.BS_Statut__c).BS_Statut__c;
                }
        	}
        }
    }
}