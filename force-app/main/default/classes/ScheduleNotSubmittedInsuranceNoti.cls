global class ScheduleNotSubmittedInsuranceNoti implements Schedulable {
   global void execute(SchedulableContext sc) { 
      NotSubmittedInsuranceNotification sendBatch = new NotSubmittedInsuranceNotification();       
      database.executebatch(sendBatch,1);
   }

}