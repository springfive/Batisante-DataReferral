trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {

    // Trigger handler for After Insert
    if (Trigger.isAfter && Trigger.isInsert) {
        Set<Id> newCDLIds = new Set<Id>();
        for (ContentDocumentLink cdl : Trigger.new) {
            newCDLIds.add(cdl.Id);
        }
        ContentDocumentLinkTriggerHelper.processContentDocumentLinks(newCDLIds, 'AFTER_INSERT');
    }
}