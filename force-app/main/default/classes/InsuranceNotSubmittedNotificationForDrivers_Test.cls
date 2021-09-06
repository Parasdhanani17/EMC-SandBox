@isTest
public class InsuranceNotSubmittedNotificationForDrivers_Test {
    public static testmethod void testMethod1(){

        SendEmail__c customSetting1 =  new SendEmail__c();
        customSetting1.Name = 'Send Email For Compliance';
        customSetting1.Send_email_from_code__c= true;
        insert customSetting1;

        Account acc = new Account();
        acc.Name = 'Test';
        Insert acc;

        Contact con = new Contact();        
        con.FirstName = 'Test';
        con.LastName = 'Contact';
        con.AccountId = acc.Id;
        con.External_Email__c = 'minkesh.patel1478@gmail.com';
        con.Deactivated_Date__c = Null;
        con.Role__c = 'Driver';
        con.Insurance_Attachment_Id__c = Null;
        insert con;
    }
}
