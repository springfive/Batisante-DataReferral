public class Gestion_Contract_TriggerHandler {

    public static void gestion_ContractBeforeUpdate(List<Contract> contractList){
        
        Set<String> BS_PrestationSet = new Set<String>();
        Set<String> BS_Code_SiteSet = new Set<String>();
        Map<String,BS_Typologie_Contrat__mdt> mdtTypeContratMap = new Map<String,BS_Typologie_Contrat__mdt>();
        Map<String,Schema.Location> siteMap = new Map<String,Schema.Location>();

        for(Contract cont : contractList){
            BS_PrestationSet.add(cont.BS_Prestation__c);
            BS_Code_SiteSet.add(cont.BS_Code_Site__c);
        }
        
        List<BS_Typologie_Contrat__mdt> mdtTypeContrat = [SELECT MasterLabel, QualifiedApiName, BS_N_contrat__c, BS_Ordre__c,BS_Type_1__c, BS_Type_2__c FROM BS_Typologie_Contrat__mdt WHERE BS_N_contrat__c IN :BS_PrestationSet];
        
        List<Schema.Location> sites = [SELECT id, BS_Code_Site__c, BS_Client__c FROM Location WHERE BS_Code_Site__c IN :BS_Code_SiteSet];
        
        for(BS_Typologie_Contrat__mdt mdt : mdtTypeContrat){
            mdtTypeContratMap.put(mdt.BS_N_contrat__c,mdt);
        }
        
        for(Schema.Location site : sites){
            siteMap.put(site.BS_Code_Site__c,site);
        }
        
        for(Contract ctr :contractList){
            
            //BS_Type1__c, BS_Type2__c, BS_Ordre__c
            if(ctr.BS_Prestation__c!=null && ctr.BS_Prestation__c!=''){
                ctr.BS_Prestation__c=ctr.BS_Prestation__c;
                if(ctr.BS_Prestation__c != null && ctr.BS_Prestation__c != '' && mdtTypeContratMap.containsKey(ctr.BS_Prestation__c)){
                    ctr.BS_Type_1__c = mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Type_1__c;
                    ctr.BS_Type_2__c = mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Type_2__c;
                    if(mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Ordre__c!=null && mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Ordre__c!='') ctr.BS_Ordre__c = Decimal.valueOf(mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Ordre__c);
                }
            }

            //BS_Emplacement__c
            if(ctr.BS_Code_site__c != null && ctr.BS_Code_site__c != '' && siteMap.containsKey(ctr.BS_Code_site__c) && siteMap.get(ctr.BS_Code_site__c).Id != null){
                ctr.BS_Emplacement__c = siteMap.get(ctr.BS_Code_site__c).Id;
            }
        }
    }
    
    public static void gestion_ContractBeforeInsert(List<Contract> contractList){
        
        Set<String> BS_PrestationSet = new Set<String>();
        Set<String> BS_Code_SiteSet = new Set<String>();
        Map<String,BS_Typologie_Contrat__mdt> mdtTypeContratMap = new Map<String,BS_Typologie_Contrat__mdt>();
        Map<String,Schema.Location> siteMap = new Map<String,Schema.Location>();

        for(Contract cont : contractList){
            BS_PrestationSet.add(cont.BS_Prestation__c);
            BS_Code_SiteSet.add(cont.BS_Code_Site__c);
        }
        
        List<BS_Typologie_Contrat__mdt> mdtTypeContrat = [SELECT MasterLabel, QualifiedApiName, BS_N_contrat__c, BS_Ordre__c,BS_Type_1__c, BS_Type_2__c FROM BS_Typologie_Contrat__mdt WHERE BS_N_contrat__c IN :BS_PrestationSet];
        
        List<Schema.Location> sites = [SELECT id, BS_Code_Site__c, BS_Client__c FROM Location WHERE BS_Code_Site__c IN :BS_Code_SiteSet];
        
        for(BS_Typologie_Contrat__mdt mdt : mdtTypeContrat){
            mdtTypeContratMap.put(mdt.BS_N_contrat__c,mdt);
        }
        
        for(Schema.Location site : sites){
            siteMap.put(site.BS_Code_Site__c,site);
        }
        
        for(Contract ctr :contractList){
            
            //BS_Type1__c, BS_Type2__c, BS_Ordre__c
            if(ctr.BS_Prestation__c!=null && ctr.BS_Prestation__c!=''){
                ctr.BS_Prestation__c=ctr.BS_Prestation__c;
                if(ctr.BS_Prestation__c != null && ctr.BS_Prestation__c != '' && mdtTypeContratMap.containsKey(ctr.BS_Prestation__c)){
                    ctr.BS_Type_1__c = mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Type_1__c;
                    ctr.BS_Type_2__c = mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Type_2__c;
                    if(mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Ordre__c!=null && mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Ordre__c!='') ctr.BS_Ordre__c=Decimal.valueOf(mdtTypeContratMap.get(ctr.BS_Prestation__c).BS_Ordre__c);
                }
            }
            
            //BS_Emplacement__c
            if(ctr.BS_Code_site__c != null && ctr.BS_Code_site__c != '' && siteMap.containsKey(ctr.BS_Code_site__c) && siteMap.get(ctr.BS_Code_site__c).Id != null){
                ctr.BS_Emplacement__c = siteMap.get(ctr.BS_Code_site__c).Id;
            }
        } 
    }
}