@isTest
public class WorkOrderLineItemTriggerHandlerTest {
    @isTest
    static void afterInsert(){
        user u = Test_Data_Factory.User1();
        User u2 = Test_Data_Factory.User2();
        System.runAs(u){
            Account acc = Test_Data_Factory.createAccount(u.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            Contract cont = Test_Data_Factory.createContract(acc.Id, site.Id);
            WorkOrder wo = Test_Data_Factory.createWorkOrder1(acc.Id, site.Id, con.Id);
            WorkOrderLineItem woli = Test_Data_Factory.createwoli(wo.Id,site.Id,con.Id,cont.Id);
            
            Lot1__c lot = Test_Data_Factory.createLot1(woli.Id);
            AffectedEquipmentsProducts__c aep = Test_Data_Factory.createAEP(woli.Id);
            ActionPlan__c ap = Test_Data_Factory.createAP(woli.Id);
            
            WorkOrder wo1 = Test_Data_Factory.createWorkOrder(acc.Id, site.Id, con.Id); 
            WorkOrderLineItem woli1 = Test_Data_Factory.createwoli1(wo1.Id,site.Id,con.Id,cont.Id,woli.Id);
            Test.startTest();
            woli1.SourceCode__c = Decimal.valueOf('1');
            Update woli1;
            WorkOrderLineItemTriggerHandler.woliAfterInsert(new List<WorkOrderLineItem>{woli1});
        }
        Test.stopTest();
    }
}