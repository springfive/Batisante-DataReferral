public class Gestion_Engagements_TriggerHandler {

    public static void gestion_EngagementsBeforeUpdate(List<BS_Engagement__c> BS_Engagement_List){
 
        Set<String> BS_PrestationSet = new Set<String>();
        Map<String,BS_Type_engagement__mdt> mdtTypeEngMap = new Map<String,BS_Type_engagement__mdt>();

        for(BS_Engagement__c eng : BS_Engagement_List){
            BS_PrestationSet.add(eng.BS_Prestation__c);
        }
        
        List<BS_Type_engagement__mdt> mdtTypeEng = [SELECT MasterLabel, QualifiedApiName, BS_N_Engagement__c, BS_Type1__c, BS_Type2__c  
                                                    FROM BS_Type_engagement__mdt WHERE BS_N_Engagement__c IN :BS_PrestationSet];
        
        for(BS_Type_engagement__mdt mdt : mdtTypeEng){
            mdtTypeEngMap.put(mdt.BS_N_Engagement__c,mdt);
        }
    
        for(BS_Engagement__c eng : BS_Engagement_List){
           
            //BS_Type1__c, BS_Type2__c
            if(eng.BS_Prestation__c!=null && eng.BS_Prestation__c!='' && mdtTypeEngMap.containsKey(eng.BS_Prestation__c)){

                if(mdtTypeEng.size()>0){
                    eng.BS_Type1__c = mdtTypeEngMap.get(eng.BS_Prestation__c).BS_Type1__c;
                    eng.BS_Type2__c = mdtTypeEngMap.get(eng.BS_Prestation__c).BS_Type2__c;
                }
            }
        }
    }
    
    public static void gestion_EngagementsBeforeInsert(List<BS_Engagement__c> BS_Engagement_List){
        
        Set<String> BS_PrestationSet = new Set<String>();
        Map<String,BS_Type_engagement__mdt> mdtTypeEngMap = new Map<String,BS_Type_engagement__mdt>();

        for(BS_Engagement__c eng : BS_Engagement_List){
            BS_PrestationSet.add(eng.BS_Prestation__c);
        }
        
        List<BS_Type_engagement__mdt> mdtTypeEng = [SELECT MasterLabel, QualifiedApiName, BS_N_Engagement__c, BS_Type1__c, BS_Type2__c  
                                                    FROM BS_Type_engagement__mdt WHERE BS_N_Engagement__c IN :BS_PrestationSet];

        for(BS_Type_engagement__mdt mdt : mdtTypeEng){
            mdtTypeEngMap.put(mdt.BS_N_Engagement__c,mdt);
        }
       
        for(BS_Engagement__c eng : BS_Engagement_List){
           
            //BS_Type1__c, BS_Type2__c
            if(eng.BS_Prestation__c!=null && eng.BS_Prestation__c!='' && mdtTypeEngMap.containsKey(eng.BS_Prestation__c)){

                if(mdtTypeEng.size()>0){
                    eng.BS_Type1__c=mdtTypeEngMap.get(eng.BS_Prestation__c).BS_Type1__c;
                    eng.BS_Type2__c=mdtTypeEngMap.get(eng.BS_Prestation__c).BS_Type2__c;
                }
            }
        }
    }
}