public class ContentDocumentTriggerHelper {

    public static void processDeletedContentDocuments(List<ContentDocument> deletedContentDocuments, String operation) {
        Set<Id> versionIds = new Set<Id>();
        Map<Id,Picture__c> picturesToDelete = new Map<Id,Picture__c>();

        Set<Id> cdlIds = new Set<Id>();

        for (ContentDocument cd : deletedContentDocuments) {
            cdlIds.addAll(getLinkedContentDocumentLinkIds(cd.Id));
            versionIds.add(cd.LatestPublishedVersionId);
        }

        Map<Id, Picture__c> versionIdToPicturesMap = new Map<Id, Picture__c>();
        for (Picture__c picture : [SELECT Id, VersionID__c FROM Picture__c WHERE VersionID__c IN :versionIds]) {
            versionIdToPicturesMap.put(picture.VersionID__c, picture);
        }

        for (ContentDocumentLink cdl : [SELECT Id, ContentDocument.LatestPublishedVersionId, LinkedEntity.Type, LinkedEntityId, ContentDocument.FileType FROM ContentDocumentLink WHERE Id IN :cdlIds]) {
            // Check if ContentDocumentLink is linked to Work Order Line Item
            if (cdl.LinkedEntityId.getSObjectType() == WorkOrderLineItem.sObjectType && cdl.ContentDocument.FileType != 'PDF') {
                // Identify the Picture__c record by matching VersionID__c
                Picture__c pictureToDelete = versionIdToPicturesMap.get(cdl.ContentDocument.LatestPublishedVersionId);
                if (pictureToDelete != null) {
                    picturesToDelete.put(pictureToDelete.Id,pictureToDelete);
                }
            }
        }

        // Delete the collected Picture__c records outside of the loop
        if (!picturesToDelete.isEmpty()) {
            delete picturesToDelete.Values();
        }
    }

    private static Set<Id> getLinkedContentDocumentLinkIds(Id contentDocumentId) {
        Set<Id> linkedCDLIds = new Set<Id>();
        
        for (ContentDocumentLink cdl : [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocumentId]) {
            linkedCDLIds.add(cdl.Id);
        }

        return linkedCDLIds;
    }
}