@istest
public class ScheduleNotSubmittedInsuranceNoti_Test {
    
    public static testMethod void scheduledSendMileageDeltaTestMethod() {
        
        Test.startTest();
        ScheduleNotSubmittedInsuranceNoti schMailDelta = new ScheduleNotSubmittedInsuranceNoti();
        String sch = '0 0 23 * * ?';
        system.schedule('Test schedule',sch,schMailDelta);
        Test.stopTest();
    }
}