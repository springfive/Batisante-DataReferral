public class Gestion_Devis_TriggerHandler {

    public static void gestion_Devis_BeforeUpdate(List<BS_Devis__c> bs_Devis_List){

        //Prevent Invoking Account Trigger
        if (TriggerHelper.hasDevisTriggerRun) {
            return;
        }
        TriggerHelper.hasDevisTriggerRun = true;

		Set<String> BS_Type_OpeSet = new Set<String>();
        Set<String> BS_Origine1Set = new Set<String>();
        Set<String> BS_Cree_par_AzurSet = new Set<String>();
        Map<String, BS_Typologie_Devis__mdt> typologieMap = new Map<String, BS_Typologie_Devis__mdt>();
        Map<String, BS_Origine__mdt> origineMap = new Map<String, BS_Origine__mdt>();
        Map<String, User> ownerDevisMap = new Map<String, User>();

        for(BS_Devis__c dev : bs_Devis_List){
            BS_Type_OpeSet.add(dev.BS_Type_Ope__c);
            BS_Origine1Set.add(dev.BS_Origine1__c);
            BS_Cree_par_AzurSet.add(dev.BS_Cree_par_Azur__c);
        }
        
        List<BS_Typologie_Devis__mdt> mdtTypeDevis = [SELECT MasterLabel, QualifiedApiName, BS_Type_ope__c, BS_Type1__c, BS_Type2__c
                                                    FROM BS_Typologie_Devis__mdt 
                                                    WHERE BS_Type_ope__c IN: BS_Type_OpeSet];
        
        List<BS_Origine__mdt> mdtOrigine = [SELECT MasterLabel, QualifiedApiName, BS_DET__c, BS_Origine__c, BS_Origine1__c  
                                            FROM BS_Origine__mdt WHERE BS_Origine1__c IN :BS_Origine1Set];

        List<user> ownerDevis = [SELECT id,BS_Trigramme__c FROM user WHERE BS_Trigramme__c IN:BS_Cree_par_AzurSet AND IsActive = True];
        
        for (BS_Typologie_Devis__mdt mdt : mdtTypeDevis) {
            typologieMap.put(mdt.BS_Type_ope__c, mdt);
        }
        
        for (BS_Origine__mdt mdt : mdtOrigine) {
            origineMap.put(mdt.BS_Origine1__c, mdt);
        }
        
        for (User userRecord : ownerDevis) {
            ownerDevisMap.put(userRecord.BS_Trigramme__c, userRecord);
        }
        
        for(BS_Devis__c bsd : bs_Devis_List){
            
            //BS_Type1__c, BS_Type2__c
            if(bsd.BS_Type_Ope__c!=null && bsd.BS_Type_Ope__c!='' && typologieMap.containsKey(bsd.BS_Type_Ope__c)) {

                if(mdtTypeDevis.size()>0){
                        bsd.BS_Type1__c = typologieMap.get(bsd.BS_Type_Ope__c).BS_Type1__c;
                        bsd.BS_Type2__c = typologieMap.get(bsd.BS_Type_Ope__c).BS_Type2__c;
                }
            }
            
            //BS_Origine__c, BS_DET__c
            if(bsd.BS_Origine1__c != null && bsd.BS_Origine1__c !='' && origineMap.containsKey(bsd.BS_Origine1__c)) {

                if(mdtOrigine.size()>0){
                    bsd.BS_Origine__c = origineMap.get(bsd.BS_Origine1__c).BS_Origine__c;
                    bsd.BS_DET__c = origineMap.get(bsd.BS_Origine1__c).BS_DET__c;
                }
            }
            
            //BS_Devis_cree_par_Azur__c
            if(bsd.BS_Cree_par_Azur__c!=null && bsd.BS_Cree_par_Azur__c != '' && ownerDevisMap.containsKey(bsd.BS_Cree_par_Azur__c)){
                bsd.BS_Devis_cree_par_Azur__c = ownerDevisMap.get(bsd.BS_Cree_par_Azur__c).Id;
            }
        }
    }
    
    public static void gestion_Devis_BeforeInsert(List<BS_Devis__c> bs_Devis_List){
        
        //Prevent Invoking Account Trigger
        if (TriggerHelper.hasDevisTriggerRun) {
            return;
        }
        TriggerHelper.hasDevisTriggerRun = true;

        Set<String> BS_Type_OpeSet = new Set<String>();
        Set<String> BS_Origine1Set = new Set<String>();
        Set<String> BS_Cree_par_AzurSet = new Set<String>();
        Map<String, BS_Typologie_Devis__mdt> typologieMap = new Map<String, BS_Typologie_Devis__mdt>();
        Map<String, BS_Origine__mdt> origineMap = new Map<String, BS_Origine__mdt>();
        Map<String, User> ownerDevisMap = new Map<String, User>();

        for(BS_Devis__c dev : bs_Devis_List){
            BS_Type_OpeSet.add(dev.BS_Type_Ope__c);
            BS_Origine1Set.add(dev.BS_Origine1__c);
            BS_Cree_par_AzurSet.add(dev.BS_Cree_par_Azur__c);
        }
        
        List<BS_Typologie_Devis__mdt> mdtTypeDevis = [SELECT MasterLabel, QualifiedApiName, BS_Type_ope__c, BS_Type1__c, BS_Type2__c
                                                    FROM BS_Typologie_Devis__mdt 
                                                    WHERE BS_Type_ope__c IN :BS_Type_OpeSet];
        
        List<BS_Origine__mdt> mdtOrigine = [SELECT MasterLabel, QualifiedApiName, BS_DET__c, BS_Origine__c, BS_Origine1__c  
                                            FROM BS_Origine__mdt WHERE BS_Origine1__c IN :BS_Origine1Set];

        List<user> ownerDevis = [SELECT id,BS_Trigramme__c FROM user WHERE BS_Trigramme__c IN :BS_Cree_par_AzurSet AND IsActive = True];
        
        for (BS_Typologie_Devis__mdt mdt : mdtTypeDevis) {
            typologieMap.put(mdt.BS_Type_ope__c, mdt);
        }
        
        for (BS_Origine__mdt mdt : mdtOrigine) {
            origineMap.put(mdt.BS_Origine1__c, mdt);
        }
        
        for (User userRecord : ownerDevis) {
            ownerDevisMap.put(userRecord.BS_Trigramme__c, userRecord);
        }
        
        for(BS_Devis__c bsd : bs_Devis_List){
            
            //BS_Type1__c, BS_Type2__c
            if(bsd.BS_Type_Ope__c!=null && bsd.BS_Type_Ope__c!='' && typologieMap.containsKey(bsd.BS_Type_Ope__c)) {

                if(mdtTypeDevis.size()>0){
                        bsd.BS_Type1__c = typologieMap.get(bsd.BS_Type_Ope__c).BS_Type1__c;
                        bsd.BS_Type2__c = typologieMap.get(bsd.BS_Type_Ope__c).BS_Type2__c;
                }
            }
            
            //BS_Origine__c, BS_DET__c
            if(bsd.BS_Origine1__c != null && bsd.BS_Origine1__c !='' && origineMap.containsKey(bsd.BS_Origine1__c)) {

                if(mdtOrigine.size()>0){
                    bsd.BS_Origine__c = origineMap.get(bsd.BS_Origine1__c).BS_Origine__c;
                    bsd.BS_DET__c = origineMap.get(bsd.BS_Origine1__c).BS_DET__c;
                }
            }
            
            //BS_Devis_cree_par_Azur__c
            if(bsd.BS_Cree_par_Azur__c!=null && bsd.BS_Cree_par_Azur__c != '' && ownerDevisMap.containsKey(bsd.BS_Cree_par_Azur__c)){
                bsd.BS_Devis_cree_par_Azur__c = ownerDevisMap.get(bsd.BS_Cree_par_Azur__c).id;
            }

        }
    }
}