public class demoGoogleMaps {
    public static String vHash='VmlqYXkgS2FudGg=';
    //Method to call google API and fetch the address recommendations 
    @AuraEnabled
    public static String getAddressSet(String SearchText){
        String APIKey = '';
        String result = null;
        if(SearchText != null){
            String APIUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + SearchText.replace(' ', '%20') + '&key=AIzaSyAftXZ-OWzVV9bCqoSZw772jtkP0CNu-lA'; 
            system.debug('APIUrl is ' + APIUrl);
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(APIURL);
            Http http = new Http();
            HttpResponse res = http.send(req);
            Integer statusCode = res.getStatusCode();
            system.debug('statusCode is ' + statusCode);
            if(statusCode == 200){
                system.debug('API invoked successfully');
                result = res.getBody();
            }else{
                result =null;
            }
        }
        return result;
    }
    @AuraEnabled(cacheable=false)
    public static navigationAttributes getDistance( String originLocation, String destinationLocation,String mode)
    {
        mode.toLowerCase();
        JSON2ApexClass_Salesforcecody googleWrapper=new JSON2ApexClass_Salesforcecody();
        navigationAttributes attr=new navigationAttributes();
        Map<String, googleMapModeCost__mdt> mcs = googleMapModeCost__mdt.getAll();
        String CostPerMile=googleMapModeCost__mdt.getAll().get(mode).Cost_per_mile__c;
        originLocation=originLocation.replaceAll(',', '%2C%20');
        originLocation=originLocation.replaceAll(' ','%20');
        System.debug('--'+originLocation);
        destinationLocation=destinationLocation.replaceAll(',', '%2C%20');
        destinationLocation=destinationLocation.replaceAll(' ','%20');
        System.debug('--'+mode);
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setMethod('GET');
        String url = 'https://maps.googleapis.com/maps/api/distancematrix/json' + '?origins=' + originLocation + '&destinations=' + destinationLocation +'&key=AIzaSyAftXZ-OWzVV9bCqoSZw772jtkP0CNu-lA'+ '&mode='+mode + '&sensor=false' + '&language=en' + '&units=imperial';
        req.setEndPoint(url);
        HTTPResponse resp = http.send(req); 
        List<JSON2ApexClass_Salesforcecody.cls_rows> rows=new List<JSON2ApexClass_Salesforcecody.cls_rows>();
        System.debug('---> '+resp.getBody());
        googleWrapper=JSON2ApexClass_Salesforcecody.parse(resp.getBody());
        for(JSON2ApexClass_Salesforcecody.cls_rows wrapper:googleWrapper.rows){
            rows.add(wrapper);
            for(JSON2ApexClass_Salesforcecody.cls_elements element:wrapper.elements){
                //  System.debug('--'+element.status);
                attr.status=element.status;
                if(element.status=='OK'){
                    attr.travelDistance=element.distance.text;
                    attr.travelTime=element.duration.text;
                    attr.travelCost= decimal.valueOf(attr.travelDistance.replaceAll(',','').split(' ')[0])* decimal.valueOf(CostPerMile);
                }
            }
            
        }
        
        return attr;
    }
    public class navigationAttributes{
        @auraEnabled public String travelDistance;
        @auraEnabled public String travelTime;
        @auraEnabled public Double travelCost;
        @auraEnabled public String status;
    }
    
}
//walking
//driving