public class ContentDocumentLinkTriggerHelper {
    

    public static void processContentDocumentLinks(Set<Id> newCDLs, String operation) {
        System.debug('###'+operation);
        Set<Id> woliIds = new Set<Id>();
        Map<Id, ContentDocumentLink> cdlMap = new Map<Id, ContentDocumentLink>();
        List<Picture__c> picturesToInsert = new List<Picture__c>();

        List<ContentDocumentLink> newCDLQueryResult = [SELECT Id, LinkedEntity.Type, LinkedEntityId, ContentDocument.LatestPublishedVersionId, ContentDocument.Description, ContentDocument.FileType FROM ContentDocumentLink WHERE Id IN :newCDLs];

        for (ContentDocumentLink cdl : newCDLQueryResult) {
            System.debug('###'+cdl.LinkedEntityId.getSObjectType()+'/'+cdl.ContentDocument.FileType);
            if (cdl.LinkedEntityId.getSObjectType() == WorkOrderLineItem.sObjectType && cdl.ContentDocument.FileType != 'PDF') {
                woliIds.add(cdl.LinkedEntityId);
                cdlMap.put(cdl.LinkedEntityId, cdl);
            }
        }

        if (!woliIds.isEmpty()) {
            Map<Id, WorkOrderLineItem> woliMap = new Map<Id, WorkOrderLineItem>([SELECT Id FROM WorkOrderLineItem WHERE Id IN :woliIds]);
            
            for (WorkOrderLineItem woli : woliMap.values()) {
                ContentDocumentLink cdl = cdlMap.get(woli.Id);
                
                if (operation == 'AFTER_INSERT') {
                    // Create a new Picture record
                    picturesToInsert.add(new Picture__c(
                        //Name = 'Picture associated with CDL: ' + cdl.Id,
                        VersionID__c = cdl.ContentDocument.LatestPublishedVersionId,
                        Comment__c = cdl.ContentDocument.Description,
                        WOLI__c = cdl.LinkedEntityId
                    ));
                }
            }
        }

        // Insert or delete Picture records accordingly
        if (!picturesToInsert.isEmpty()) {
            insert picturesToInsert;
        }

    }
}