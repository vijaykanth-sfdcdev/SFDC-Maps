@isTest
public class demoGoogleMapsTest {
    @testSetup 
    static void setup() {
    }
    static testmethod void testSuccessSearchCallout() {
         Test.setMock(HttpCalloutMock.class, new GM_MockHttpErrorResponseGenerator());
        Test.startTest();
        	String successResponse=demoGoogleMaps.getAddressSet('successRequest');
        Test.stopTest();
	}
    static testmethod void testErrorSearchCallout() {
         Test.setMock(HttpCalloutMock.class, new GM_MockHttpErrorResponseGenerator());
        Test.startTest();
        	String errorResponse=demoGoogleMaps.getAddressSet('errorRequest');
        Test.stopTest();
	}
     static testmethod void testSuccessGetDistanceCallout() {
         demoGoogleMaps.navigationAttributes navigationProperties=new demoGoogleMaps.navigationAttributes();
         Test.setMock(HttpCalloutMock.class, new GM_MockHttpErrorResponseGenerator());
        Test.startTest();
        	demoGoogleMaps.navigationAttributes successResponse=demoGoogleMaps.getDistance('New York','New Jersey','driving');
        Test.stopTest();
	}
     static testmethod void testErrorGetDistanceCallout() {
         demoGoogleMaps.navigationAttributes navigationProperties=new demoGoogleMaps.navigationAttributes();
         
         Test.setMock(HttpCalloutMock.class, new GM_MockHttpErrorResponseGenerator());
        Test.startTest();
        	demoGoogleMaps.navigationAttributes errorResponse=demoGoogleMaps.getDistance('Japan','China','walking');
        Test.stopTest();
	}

}