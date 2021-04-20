public class VehicleMappingTriggerHalper {
    public static void UpdatePicklistField()
       {
           
           MetadataService.MetadataPort service = createService();    
           MetadataService.CustomField customField = new MetadataService.CustomField();
           customField.fullName = 'Account.Vehicle_Types__c';
           customField.label = 'Vehicle Types';
           customField.type_x = 'Picklist (Multi-Select)';  
           metadataservice.Picklist pt = new metadataservice.Picklist();
           pt.sorted= false;
           metadataservice.PicklistValue two = new metadataservice.PicklistValue(); //new value
           two.fullName= 'second';
           two.default_x=false ;
           metadataservice.PicklistValue three = new metadataservice.PicklistValue(); // new value
           three.fullName= 'third';
           three.default_x=false ;
           pt.picklistValues = new list<metadataservice.PicklistValue>{two,three};  
           customField.picklist = pt ;
           MetadataService.UpdateMetadata_element ut = new MetadataService.UpdateMetadata_element(); // here you are updated your value in object.
           ut.currentName='Account.Vehicle_Types__c';
           ut.metadata= customField;  
           MetadataService.AsyncResult[] results = service.updateMetadata(new List<MetadataService.updateMetadata_element> {ut});
       }
       public static MetadataService.MetadataPort createService()
   
       {
           MetadataService.MetadataPort service = new MetadataService.MetadataPort();
           service.SessionHeader = new MetadataService.SessionHeader_element();
           service.SessionHeader.sessionId = UserInfo.getSessionId();
           return service;    
       }
   
   }