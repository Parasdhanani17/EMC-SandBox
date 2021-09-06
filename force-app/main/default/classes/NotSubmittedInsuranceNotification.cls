global class NotSubmittedInsuranceNotification implements Database.Batchable<SObject> {
    
    global List<String> listAccount {get;set;}
    global set<string> roleList;
    global NotSubmittedInsuranceNotification() {
        
        String accountName = Label.TripstobeLogged;
        listAccount = new List<String>();
        if(accountName != null) {
            listAccount = accountName.split(',');
        }
        
        system.debug('listAccount=='+ listAccount);
        roleList = new set<string>();
        roleList.add('Driver');
        roleList.add('Driver/Manager');
        roleList.add(StaticValues.roleAdminDriver);
        
        system.debug('roleList=='+ roleList);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) 
    {
        system.debug('listAccount=='+ listAccount);
        system.debug('roleList=='+ roleList);
        string query = 'SELECT Name, Role__c, External_Email__c, FirstName FROM Contact ';
        query+= 'WHERE Account.Name IN : listAccount';
        query+= ' AND Role__c IN : roleList AND Deactivated_Date__c = NULL AND Insurance_Attachment_Id__c = NULL';
        
        system.debug(query);
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> Scope)
    
    {    
        List<Messaging.MassEmailMessage> mails = new List<Messaging.MassEmailMessage>();
        List<id> conId= new List<Id>();
        string header = 'Name, Email, Error \n';
        string finalstr = header ;
        
        List<Contact> conList = Scope;
        system.debug('conList=='+ conList);
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:'driverservices@mburse.com'];
        List<EmailTemplate> temp = new List<EmailTemplate>([SELECT id, Subject, body, HTMLValue FROM EmailTemplate 
                                                            WHERE DeveloperName = 'Not_Submitted_Insurance_Notification']);
        
        Messaging.SingleEmailMessage mail;
        List<Messaging.SingleEmailMessage> mail_list = new List<Messaging.SingleEmailMessage>();
        Integer totalcontacts = conList.size();
        for(Contact c: conList) {
            List<String> sendingTo = new List<String>();
            string htmlbody = '';
            mail = new Messaging.SingleEmailMessage();
            if (owea.size() > 0) 
            {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            sendingTo.add(c.External_Email__c);
            mail.setToAddresses(sendingTo);
            mail.setSubject(temp[0].Subject);
            htmlbody = temp[0].HTMLValue;
            htmlbody = htmlbody.replace('{!Contact.FirstName}',c.FirstName);
            htmlbody = htmlbody.replace('{!$Label.Driver_Forword_Logo}', System.Label.Driver_Forword_Logo);
            mail.setPlainTextBody(htmlbody);
            List<String> bccaddress = new list<String>();
            //bccaddress.add('driverservices@mburse.com');
            //mail.setBccAddresses(bccaddress);
            mail.setHtmlBody(htmlbody);
            mail_list.add(mail);
            system.debug('mail_list');
        }
        SendEmail__c  sendEmailObj = SendEmail__c.getValues('SendMileageReminderforDelta');
        if((sendEmailObj!=null) && sendEmailObj.Send_email_from_code__c==true && mail_list.size()>0 && !Test.isRunningTest())
        {
            Messaging.sendEmail(mail_list);  
        }
    }
    global void finish(Database.BatchableContext BC){
        
    }
    
}