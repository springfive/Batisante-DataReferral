@isTest
public class ContentDocumentTriggerHelperTest {

    @isTest
    static void testProcessDeletedContentDocuments() {
        // Test data setup
        Blob testData = Blob.valueOf('Test Data');
        
        
        //Create WOLI
        user u = Test_Data_Factory.User1();
        User u2 = Test_Data_Factory.User2();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            Contract cont = Test_Data_Factory.createContract(acc.Id, site.Id);
            WorkOrder wo = Test_Data_Factory.createWorkOrder(acc.Id, site.Id, con.Id);
            WorkOrderLineItem woli = Test_Data_Factory.createwoli(wo.Id,site.Id,con.Id,cont.Id);
            
            Lot1__c lot = Test_Data_Factory.createLot1(woli.Id);
            AffectedEquipmentsProducts__c aep = Test_Data_Factory.createAEP(woli.Id);
            ActionPlan__c ap = Test_Data_Factory.createAP(woli.Id);
            
            WorkOrder wo1 = Test_Data_Factory.createWorkOrder(acc.Id, site.Id, con.Id); 
            WorkOrderLineItem woli1 = Test_Data_Factory.createwoli1(wo1.Id,site.Id,con.Id,cont.Id,woli.Id);
            Test.startTest();
            woli1.SourceCode__c = Decimal.valueOf('1');
            Update woli1;
        
        
        // You must specify either PathOnClient or ContentUrl when inserting a ContentVersion
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test Content',
            VersionData = testData,
            PathOnClient = 'TestPath/TestFile.txt', // Example PathOnClient
            FirstPublishLocationId = woli1.Id
        );
        insert testContentVersion;
 Id cvInserted = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id = :testContentVersion.Id Limit 1].ContentDocumentId;


        ContentDocumentLink testCDL = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE Id = :cvInserted LIMIT 1].Id,
            LinkedEntityId = [SELECT Id FROM WorkOrderLineItem LIMIT 1].Id,
            ShareType = 'V'
        );

        insert testCDL;

        Picture__c testPicture = new Picture__c(
            VersionID__c = testContentVersion.Id
            // Add other required fields
        );
        insert testPicture;
        
        // Test trigger
        delete [SELECT Id FROM ContentDocument WHERE Id = :cvInserted];
        Test.stopTest();

        // Validate results
        List<Picture__c> deletedPictures = [SELECT Id FROM Picture__c WHERE Id = :testPicture.Id];
        System.assertEquals(0, deletedPictures.size(), 'Picture__c record should be deleted');
        }
    }
}