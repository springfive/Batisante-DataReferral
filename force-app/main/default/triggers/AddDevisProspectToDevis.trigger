trigger AddDevisProspectToDevis on BS_Devis__c (after insert, after update) {
	List<BS_Devis__c> Devis=trigger.new;
    List<BS_Devis__c> Devis2=trigger.Old;
    List<BS_Devis__c> UpdateDevis = new List<BS_Devis__c>();
    List<BS_Devis__c> ToUpdateDevis = new List<BS_Devis__c>();
    List<string> nDevis = new List<string>();
    List<BS_Devis_from_Lead__c> devisProspects= new List<BS_Devis_from_Lead__c>();
   
  IF (Devis.size()>0){
   
      For(integer i=0;i<Devis.size();i++){
          IF(Trigger.isInsert){
          if (Devis[i].N_Devis_From_Lead__c !='' ){
              ToUpdateDevis.add(Devis[i]);
              nDevis.add(Devis[i].N_Devis_From_Lead__c);  
          }
              }
          IF(Trigger.isUpdate){
          if (Devis[i].N_Devis_From_Lead__c !='' && Devis[i].N_Devis_From_Lead__c!=Devis2[i].N_Devis_From_Lead__c ){
              ToUpdateDevis.add(Devis[i]);
              nDevis.add(Devis[i].N_Devis_From_Lead__c);  
          }
          }
       }
       }
   
       If(nDevis.size()>0){
           devisProspects = [Select ID,BS_N_Devis__c from BS_Devis_from_Lead__c where BS_N_Devis__c IN: nDevis ];
       }    
    System.debug(devisProspects);
   
    If (devisProspects.size()>0){

        For(integer i=0;i<ToUpdateDevis.size();i++){
            
                BS_Devis__c NewDevis= new BS_Devis__c();
           
               
                for(integer j=0;j<devisProspects.size();j++){
                    
                
                    if(ToUpdateDevis[i].N_Devis_From_Lead__c==devisProspects[j].BS_N_Devis__c){
                        
                       NewDevis.id=ToUpdateDevis[i].id;
                       NewDevis.Devis_Prospect__c=devisProspects[j].id; 
                    }   
                }
                IF(NewDevis!=null){
                   UpdateDevis.add(NewDevis);
                }
            
            }
                
            
        }
        
   System.debug(UpdateDevis);
    If(UpdateDevis.size()>0){
        Update UpdateDevis;
    }
  
}