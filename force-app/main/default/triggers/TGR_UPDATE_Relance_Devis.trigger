trigger TGR_UPDATE_Relance_Devis on BS_Devis__c (after insert, after update)
{
    
    LIST <BS_Devis__c> newDevis=[SELECT id,BS_Type_relance__c,BS_Resultat_relance__c,BS_Motif_du_refus__c,
                                BS_Nom_Confrere__c,BS_Montant_offre_confrere__c,BS_Durite__c,BS_Commentaires__c,LastModifiedById FROM BS_Devis__c WHERE Id IN :Trigger.new];
    LIST <BS_Devis__c> oldDevis=Trigger.old;
    LIST<BS_Devis__c> devisToUpdate=new list<BS_Devis__c>();
    for(BS_Devis__c devisA :newDevis)
    {
        if(Trigger.IsAfter && !Trigger.isInsert){
        BS_Devis__c devisOldRecord=Trigger.oldMap.get(devisA.id);
        
        
        if(devisA.BS_Type_relance__c!=devisOldRecord.BS_Type_relance__c||
           devisA.BS_Resultat_relance__c!=devisOldRecord.BS_Resultat_relance__c||
          devisA.BS_Motif_du_refus__c!=devisOldRecord.BS_Motif_du_refus__c||
          devisA.BS_Nom_Confrere__c!=devisOldRecord.BS_Nom_Confrere__c||
          devisA.BS_Montant_offre_confrere__c!=devisOldRecord.BS_Montant_offre_confrere__c||
          devisA.BS_Durite__c!=devisOldRecord.BS_Durite__c||
          devisA.BS_Commentaires__c!=devisOldRecord.BS_Commentaires__c){
              
              devisA.BS_Relance_le__c=date.today();
              devisA.BS_Relance_par__c=devisA.LastModifiedById;
              devisToUpdate.add(devisA);
            
          }}
    }
    upsert(devisToUpdate);
    
    

}