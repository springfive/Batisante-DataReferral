@isTest
public class ServiceAppointmentTriggerHandlerTest {
    @isTest
    static void afterInsert1(){
        
        user u1 = Test_Data_Factory.VendeursSTGestionnaire();
        User u2 = Test_Data_Factory.User1();
        User u3 = Test_Data_Factory.User2();
        User u4 = Test_Data_Factory.User3();
        System.runAs(u1){
            Account acc = Test_Data_Factory.createAccount(u1.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            WorkOrder wo = Test_Data_Factory.createWorkOrder(acc.Id, site.Id, con.Id);
            SchedulingConstraint sc = Test_Data_Factory.createSC();
            ServiceResource sr = Test_Data_Factory.createSR(u1.Id,sc.Id);
            OperatingHours oh = Test_Data_Factory.createOH();
            ServiceTerritory st = Test_Data_Factory.createST(oh.Id,sc.Id);
            ServiceTerritoryMember stm = Test_Data_Factory.createSTM(sr.Id,st.Id,oh.Id);
            Test.startTest();
			ServiceAppointment sa = Test_Data_Factory.createSA4(wo.Id, con.Id);
            
            
            TriggerHelper.hasServiceAppointmentTriggerRun= false;
            ServiceAppointmentTriggerHandler.serviceappointmentAfterInsert(new List<ServiceAppointment>{sa});
        }
        Test.stopTest();
    }
    
    @isTest
    static void afterUpdate1(){
        user u1 = Test_Data_Factory.VendeursSTGestionnaire();
        User u2 = Test_Data_Factory.User1();
        User u3 = Test_Data_Factory.User2();
        User u4 = Test_Data_Factory.User3();
        System.runAs(u1){
            Account acc = Test_Data_Factory.createAccount(u1.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            WorkOrder wo = Test_Data_Factory.createWorkOrder(acc.Id, site.Id, con.Id);
            SchedulingConstraint sc = Test_Data_Factory.createSC();
            OperatingHours oh = Test_Data_Factory.createOH();
            ServiceTerritory st = Test_Data_Factory.createST(oh.Id,sc.Id);
            ServiceResource sr = Test_Data_Factory.createSR(u1.Id,sc.Id);
            ServiceResource sr1 = Test_Data_Factory.createSR(u2.Id,sc.Id);
            ServiceTerritoryMember stm = Test_Data_Factory.createSTM(sr.Id,st.Id,oh.Id);
            ServiceTerritoryMember stm1 = Test_Data_Factory.createSTM(sr1.Id,st.Id,oh.Id);
            ServiceAppointment sa = Test_Data_Factory.createSA4(wo.Id, con.Id);
            ServiceAppointment sa1 = Test_Data_Factory.createSA1(wo.Id, con.Id);
            //AssignedResource ar = Test_Data_Factory.createAR(sr.Id, sa.Id);
            Map<Id, ServiceAppointment> oldServiceappointmentMap = new Map<Id, ServiceAppointment>();
            oldServiceappointmentMap.put(sa.Id, sa1);
            
            Test.startTest();
            sa.Intervenant__c = 'ADC/CDE';
            Update sa;
            TriggerHelper.hasServiceAppointmentTriggerRun= false;
            ServiceAppointmentTriggerHandler.serviceappointmentAfterUpdate(new List<ServiceAppointment>{sa},oldServiceappointmentMap);
        }
        Test.stopTest();
    }
    
    @isTest
    static void afterUpdate2(){
        user u1 = Test_Data_Factory.VendeursSTGestionnaire();
        User u2 = Test_Data_Factory.User1();
        User u3 = Test_Data_Factory.User2();
        User u4 = Test_Data_Factory.User3();
        System.runAs(u1){
            Account acc = Test_Data_Factory.createAccount(u1.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            WorkOrder wo = Test_Data_Factory.createWorkOrder(acc.Id, site.Id, con.Id);
            SchedulingConstraint sc = Test_Data_Factory.createSC();
            OperatingHours oh = Test_Data_Factory.createOH();
            ServiceTerritory st = Test_Data_Factory.createST(oh.Id,sc.Id);
            ServiceResource sr = Test_Data_Factory.createSR(u1.Id,sc.Id);
            ServiceResource sr1 = Test_Data_Factory.createSR(u2.Id,sc.Id);
            ServiceTerritoryMember stm = Test_Data_Factory.createSTM(sr.Id,st.Id,oh.Id);
            ServiceTerritoryMember stm1 = Test_Data_Factory.createSTM(sr1.Id,st.Id,oh.Id);
            ServiceAppointment sa = Test_Data_Factory.createSA4(wo.Id, con.Id);
            ServiceAppointment sa1 = Test_Data_Factory.createSA(wo.Id, con.Id);
            AssignedResource ar = Test_Data_Factory.createAR(sr.Id, sa.Id);
            Map<Id, ServiceAppointment> oldServiceappointmentMap = new Map<Id, ServiceAppointment>();
            oldServiceappointmentMap.put(sa.Id, sa1);
            Test.startTest();
            sa.Intervenant__c = 'ADC/ABC';
            Update sa;
            TriggerHelper.hasServiceAppointmentTriggerRun= false;
            ServiceAppointmentTriggerHandler.serviceappointmentAfterUpdate(new List<ServiceAppointment>{sa},oldServiceappointmentMap);
        }
        Test.stopTest();
    }
    
    @isTest
    static void afterUpdate3(){
        user u1 = Test_Data_Factory.VendeursSTGestionnaire();
        User u2 = Test_Data_Factory.User1();
        User u3 = Test_Data_Factory.User2();
        User u4 = Test_Data_Factory.User3();
        System.runAs(u1){
            Account acc = Test_Data_Factory.createAccount(u1.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            WorkOrder wo = Test_Data_Factory.createWorkOrder(acc.Id, site.Id, con.Id);
            SchedulingConstraint sc = Test_Data_Factory.createSC();
            OperatingHours oh = Test_Data_Factory.createOH();
            ServiceTerritory st = Test_Data_Factory.createST(oh.Id,sc.Id);
            ServiceResource sr = Test_Data_Factory.createSR(u1.Id,sc.Id);
            ServiceResource sr1 = Test_Data_Factory.createSR(u2.Id,sc.Id);
            ServiceTerritoryMember stm = Test_Data_Factory.createSTM(sr.Id,st.Id,oh.Id);
            ServiceTerritoryMember stm1 = Test_Data_Factory.createSTM(sr1.Id,st.Id,oh.Id);
            ServiceAppointment sa = Test_Data_Factory.createSA4(wo.Id, con.Id);
            ServiceAppointment sa1 = Test_Data_Factory.createSA(wo.Id, con.Id);
            AssignedResource ar = Test_Data_Factory.createAR(sr.Id, sa.Id);
            Map<Id, ServiceAppointment> oldServiceappointmentMap = new Map<Id, ServiceAppointment>();
            oldServiceappointmentMap.put(sa.Id, sa1);
            
            Test.startTest();
            sa.Intervenant__c = '';
            //Update sa;
            System.debug('sa =>'+sa);
            System.debug('old sa =>'+oldServiceappointmentMap);
            TriggerHelper.hasServiceAppointmentTriggerRun= false;
            ServiceAppointmentTriggerHandler.serviceappointmentAfterUpdate(new List<ServiceAppointment>{sa},oldServiceappointmentMap);
        }
        Test.stopTest();
    }
    
    @isTest
    static void afterUpdate4(){
        user u1 = Test_Data_Factory.VendeursSTGestionnaire();
        User u2 = Test_Data_Factory.User1();
        User u3 = Test_Data_Factory.User2();
        User u4 = Test_Data_Factory.User3();
        System.runAs(u1){
            Account acc = Test_Data_Factory.createAccount(u1.Id,u2.Id);
            Contact con = Test_Data_Factory.createContact(acc.Id);
            Schema.Location site = Test_Data_Factory.createSite(acc.Id);
            WorkOrder wo = Test_Data_Factory.createWorkOrder(acc.Id, site.Id, con.Id);
            SchedulingConstraint sc = Test_Data_Factory.createSC();
            OperatingHours oh = Test_Data_Factory.createOH();
            ServiceTerritory st = Test_Data_Factory.createST(oh.Id,sc.Id);
            ServiceResource sr = Test_Data_Factory.createSR(u1.Id,sc.Id);
            ServiceResource sr1 = Test_Data_Factory.createSR(u2.Id,sc.Id);
            ServiceTerritoryMember stm = Test_Data_Factory.createSTM(sr.Id,st.Id,oh.Id);
            ServiceTerritoryMember stm1 = Test_Data_Factory.createSTM(sr1.Id,st.Id,oh.Id);
            ServiceAppointment sa = Test_Data_Factory.createSA4(wo.Id, con.Id);
            ServiceAppointment sa1 = Test_Data_Factory.createSA(wo.Id, con.Id);
            AssignedResource ar = Test_Data_Factory.createAR(sr.Id, sa.Id);
            Map<Id, ServiceAppointment> oldServiceappointmentMap = new Map<Id, ServiceAppointment>();
            oldServiceappointmentMap.put(sa.Id, sa1);
            
            Test.startTest();
            sa.Intervenant__c = 'ADC/BCD/CDE';
            Update sa;
            TriggerHelper.hasServiceAppointmentTriggerRun= false;
            ServiceAppointmentTriggerHandler.serviceappointmentAfterUpdate(new List<ServiceAppointment>{sa},oldServiceappointmentMap);
        }
        Test.stopTest();
    }
    
}