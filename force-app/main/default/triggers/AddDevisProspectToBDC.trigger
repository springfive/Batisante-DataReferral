trigger AddDevisProspectToBDC on BS_BDC__c (after insert, after Update) {
	List<BS_BDC__c> BDC=trigger.new;
    List<BS_BDC__c> BDC2=trigger.Old;
    List<BS_BDC__c> UpdateBDC = new List<BS_BDC__c>();
    List<BS_BDC__c> ToUpdateBDC = new List<BS_BDC__c>();
    List<string> nDevis = new List<string>();
    List<BS_Devis_from_Lead__c> devisProspects= new List<BS_Devis_from_Lead__c>();
    
  IF (BDC.size()>0){
   
      For(integer i=0;i<BDC.size();i++){
          IF(Trigger.isInsert){
          if (BDC[i].N_Devis_From_Lead__c !='' ){
              ToUpdateBDC.add(BDC[i]);
              nDevis.add(BDC[i].N_Devis_From_Lead__c);  
          }
              }
          IF(Trigger.isUpdate){
          if (BDC[i].N_Devis_From_Lead__c !='' && BDC[i].N_Devis_From_Lead__c!=BDC2[i].N_Devis_From_Lead__c ){
              ToUpdateBDC.add(BDC[i]);
              nDevis.add(BDC[i].N_Devis_From_Lead__c);  
          }
          }
       }
       }
   
       If(nDevis.size()>0){
           devisProspects = [Select ID,BS_N_Devis__c from BS_Devis_from_Lead__c where BS_N_Devis__c IN: nDevis ];
       }    
    
   
    If (devisProspects.size()>0){

        For(integer i=0;i<ToUpdateBDC.size();i++){
            
                BS_BDC__c NewBDC= new BS_BDC__c();
           
               
                for(integer j=0;j<devisProspects.size();j++){
                    
                
                    if(ToUpdateBDC[i].N_Devis_From_Lead__c==devisProspects[j].BS_N_Devis__c){
                        
                       NewBDC.id=ToUpdateBDC[i].id;
                       NewBDC.Devis_Prospect__c=devisProspects[j].id; 
                    }   
                }
                IF(NewBDC!=null){
                   UpdateBDC.add(NewBDC);
                }
            
            }
                
            
        }
        
    
    If(UpdateBDC.size()>0){
        Update UpdateBDC;
    }
}