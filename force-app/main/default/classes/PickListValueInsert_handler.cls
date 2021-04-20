public class PickListValueInsert_handler{
    public class MetadataServiceExamplesException extends Exception { }
    @Future(callout=true)
    public static void createPickValue(Set<String> pick1,String newMapString){
        
        Map<Id, Account> newMap = (Map<Id, Account>)JSON.deserialize(newMapString, Map<Id, Account>.class);
       
        for(Test_4__c test4Val : newMap.Values()){
            if(firstDependentMap.ContainsKey(test4Val.Pick_2__c)){
                firstDependentMap.get(test4Val.Pick_2__c).add(test4Val.Pick_1__c); 
            }
        }
        
        List<Set<String>> masterPick = new List<Set<String>>();
        masterPick.add(pick1);
        System.debug('masterPick-->'+masterPick);
        
            
        for( integer i = 0 ; i < 3 ; i++ ){
            MetadataService.MetadataPort service = createService();     
            MetadataService.CustomField customField = new MetadataService.CustomField();
            customField.fullName = 'Test_4__c.';
            customField.label = Labels[i];
            customField.type_x = 'Picklist';
            
            metadataservice.Picklist pt = new metadataservice.Picklist();
            pt.sorted= false;
            pt.picklistValues = new list<metadataservice.PicklistValue>();
            System.debug('apis-->'+APIs[i]);
            //String sp = APIs[i];
            //System.debug('apis split-->'+sp.split('.'));
            //String[] controllingFieldName = APIs[i];
            if(i > 0){
                pt.controllingField = APIs[i-1];
            }
            for(String str : masterPick[i]){
                metadataservice.PicklistValue plValue = new metadataservice.PicklistValue();
                plValue.fullName= str;
                plValue.default_x=false ;
                
                System.debug(i+'<--masterPick[i]-->'+masterPick[i]);
                
                if(i == 1){
                   System.debug('iiiiiiiii-->'+i);
                   List<String> fistList=new List<String>();
                   fistList.addAll(firstDependentMap.get(str));
                   System.debug('fistList-->'+fistList);
                   plValue.controllingFieldValues = fistList; 
                }
                if(i == 2){
                   System.debug('iiiiiiiii-->'+i);
                   List<String> secondList=new List<String>();
                   secondList.addAll(secondDependentMap.get(str));
                   System.debug('secondList-->'+secondList);
                   plValue.controllingFieldValues = secondList; 
                }
                
                pt.picklistValues.add(plValue);
            }        
            customField.picklist = pt ;
            
            List<MetadataService.SaveResult> results =
                service.updateMetadata(
                    new MetadataService.Metadata[] { customField });
            handleSaveResults(results[0]);
        }
    }
    public static void handleSaveResults(MetadataService.SaveResult saveResult)
    {
        // Nothing to see?
        if(saveResult==null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if(saveResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + saveResult.fullName + '.');
            for(MetadataService.Error error : saveResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
        }
        if(!saveResult.success)
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
    }
    public static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
}