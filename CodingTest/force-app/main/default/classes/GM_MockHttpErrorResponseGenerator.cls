global class GM_MockHttpErrorResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {  
        
        System.debug('--respond'+req.getEndpoint());
        //System.assertEquals('https://example/test.com',req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        if(req.getEndpoint().contains('successRequest') || req.getEndpoint().contains('&mode=driving')){
            return successRespond(req);
        }
        return errorRespond(req);
        
    }
    private static HTTPResponse errorRespond(HTTPRequest req){
        // Create a fake response
        System.debug('--errorRespond'+req.getEndpoint());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
         String respStringBody=		'{"destination_addresses" : [ "New Delhi, Delhi, India" ],   "origin_addresses" : [ "Rupnagar, Punjab 140001, India" ],"rows" : [{"elements" : [            {"distance" : {"text" : "183 mi","value" : 294964},"duration" : {                  "text" : "5 hours 18 mins","value" : 19064             },"status" : "OK"            }]}],"status" : "OK"}';
        
        res.setBody(respStringBody);
        res.setStatusCode(400);
        return res;
        
    }
    private static HTTPResponse successRespond(HTTPRequest req) {  
        
        System.debug('--successRespond'+req.getEndpoint());
        //System.assertEquals('https://example/test.com',req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
                
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String respStringBody=		'{"destination_addresses" : [ "New Delhi, Delhi, India" ],   "origin_addresses" : [ "Rupnagar, Punjab 140001, India" ],"rows" : [{"elements" : [            {"distance" : {"text" : "183 mi","value" : 294964},"duration" : {                  "text" : "5 hours 18 mins","value" : 19064             },"status" : "OK"            }]}],"status" : "OK"}';
        
        res.setBody(respStringBody);
        res.setStatusCode(200);
        return res;
    }
}