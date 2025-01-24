trigger addDevisProspect on Contract (after insert, after Update) {
    
    List<Contract> Contract=trigger.new;
    List<Contract> Contract2=trigger.Old;
    List<Contract> UpdateContract = new List<Contract>();
    
    List<string> nDevis = new List<string>();
    
    List<BS_Devis_from_Lead__c> devisProspects= new List<BS_Devis_from_Lead__c>();
    
    IF (Contract.size()>0){
    
      For(integer i=0;i<Contract.size();i++){
          IF(Trigger.isInsert){
          if (Contract[i].N_de_devis__c !=''){
              nDevis.add(Contract[i].N_de_devis__c);  
          }
          }
          IF(Trigger.isUpdate){
          if (Contract[i].N_de_devis__c !='' && Contract[i].N_de_devis__c !=Contract2[i].N_de_devis__c  ){
              nDevis.add(Contract[i].N_de_devis__c);  
          }
          }
       }
       
       If(nDevis.size()>0){
           devisProspects = [Select ID,BS_N_Devis__c from BS_Devis_from_Lead__c where BS_N_Devis__c IN: nDevis ];
       }    
    }
    
    If (devisProspects.size()>0){
        For(integer i=0;i<Contract.size();i++){
            IF(Contract[i].N_de_devis__c!=''){
                Contract NewContract= new Contract();
                for(integer j=0;j<devisProspects.size();j++){
                    if(Contract[i].N_de_devis__c==devisProspects[j].BS_N_Devis__c){
                       NewContract.id=Contract[i].id;
                       NewContract.Devis_Prospect__c=devisProspects[j].id; 
                    }   
                }
                If(NewContract!=Null){
                    UpdateContract.add(newContract);
                } 
            }
        }
    }
    If(UpdateContract.size()>0){
        Update UpdateContract;
    }    
}