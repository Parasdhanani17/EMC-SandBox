public class UKGLoggingController {
    
    //public String password { get; set; }
    //public String username { get; set; }
    static String username = 'MBurse_2021';
    static String baseUrl = 'https://service4.ultipro.com';
    static String userAPIKey = Label.UKGuserAPIKey;
    static String customerAPIKey = Label.UKGcustomerAPIKey;
    static String tokenURL = 'https://login.ultipro.com';
       
    //This Method is used to get contact from UKG
    public static void getContact(){
        //Custom setting for username and password
        UKG_Integration__c ukg = UKG_Integration__c.getValues('MBurse_2021');
        string encodedString = 'BASIC ' + EncodingUtil.base64Encode(blob.valueOf(ukg.Name + ':' + ukg.Password__c));
        baseURL = baseURL + '/personnel/v1/companies/7UC0H/employment-details';
        System.debug('baseURL=='+ baseURL);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(baseURL);
        request.setHeader('US-Customer-Api-Key', customerAPIKey);
        request.setHeader('Authorization', encodedString);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        System.debug('response=='+ response);
        
        if (response.getStatusCode() == 200) {
            system.debug('Statuscode == ' + response.getStatusCode());
            system.debug('Statuscode == ' + response.getBody());
            
            //object responseObject = JSON.deserializeUntyped(response.getBody());
            
            
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            system.debug('results'+ results);
            List<Contact> empList = new List<Contact>();
            system.debug('empList');
            
            
            for(Object obj: results){
                Map<String, Object> mapJson = (Map<String, Object>)obj;
               
                Contact con = new Contact();
                
                con.Employee_ID__c = (String)mapJson.get('employeeID');
                con.FirstName = (String)mapJson.get('firstName');
                con.LastName = (String)mapJson.get('lastName');
                con.Manager__c = (String)mapJson.get('supervisorFirstName') +' '+ (String)mapJson.get('supervisorLastName');
                
                //con.Added_Date__c = (date)mapJson.get('dateInJob');
                //con.External_Email__c  = (String)mapJson.get('emailAddress');
                empList.add(con);
            }
            system.debug('empList=='+ empList);
            system.debug('empList=='+ empList.size());
            if(!empList.isEmpty()){
                upsert empList;
            }
        }
    }
}