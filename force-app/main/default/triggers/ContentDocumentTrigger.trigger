trigger ContentDocumentTrigger on ContentDocument (Before delete) {

    // Trigger handler for After Delete
    if (Trigger.isBefore && Trigger.isDelete) {
        ContentDocumentTriggerHelper.processDeletedContentDocuments(Trigger.old, 'BEFORE_DELETE');
    }
}