@isTest
public class NotSubmittedInsuranceNotification_Test {

    public static testmethod void testMethod1(){
        SendEmail__c  customEmailSetting =  new SendEmail__c ();
        customEmailSetting.Name = 'SendMileageReminderforDelta';
        customEmailSetting.Send_email_from_code__c= false;
        insert customEmailSetting;
        
        SendEmail__c customSetting =  new SendEmail__c();
        customSetting.Name = 'Send Email For Compliance';
        customSetting.Send_email_from_code__c= true;
        insert customSetting;
        
        TriggerConfig__c customEmailSetting1 =  new TriggerConfig__c();
        customEmailSetting1.Name = 'Defaulttrigger';
        customEmailSetting1.ContactTriggersendEmailForNewContact__c = true;
        customEmailSetting1.ContactTriCommunityReimCreate__c = true;
        insert customEmailSetting1;
        
        SendEmailonDeactivation__c objCustom = new SendEmailonDeactivation__c();
        objCustom.Name = 'SendMileageReminderforDelta';        
        objCustom.BCCEmailaddresses__c = 'test@gmail.com';
        objCustom.Send_to_Driver__c = true;
        insert objCustom;
        
        Vehicle_URL_Mapping__c veh = new Vehicle_URL_Mapping__c();
        veh.URL__c = 'https://cdn2.hubspot.net/hubfs/2511299/iStock-494093356.jpg';
        veh.vehicle__c = 'Full-Size Sedan';
        veh.Year__c = '2019';
        insert veh;

        Account acc = new Account();           
        acc.Name = 'Acme Corporation';
        acc.Triplog_API__c = '123456789';
        Acc.Triplog_Status__c = 'U';
        insert Acc;

        Contact con = new Contact();        
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = acc.Id;
        con.External_Email__c = 'minkesh.patel1478@gmail.com';
        con.Deactivated_Date__c = Null;
        con.Role__c = 'Driver';
        con.Insurance_Attachment_Id__c = Null;
        con.Vehicle_Type__c = '2019 Full-Size Sedan';
        insert con;
        
        Contact cont = new Contact();        
        cont.FirstName = 'Test';
        cont.LastName = 'Contact';
        cont.AccountId = acc.Id;
        cont.External_Email__c = 'minkesh.patel147812@gmail.com';
        cont.Deactivated_Date__c = Null;
        cont.Role__c = 'Driver/Manager';
        cont.Insurance_Attachment_Id__c = Null;
        cont.Vehicle_Type__c = '2019 Full-Size Sedan';
        insert cont;
        
         Test.startTest();
       
        NotSubmittedInsuranceNotification emailObj = new NotSubmittedInsuranceNotification();
        Database.executeBatch(emailObj);
        
         Test.stopTest();
      
    }
}