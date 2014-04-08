/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=false)
private class CalculatorWebServiceTest {

	/** Teste avec une réponse mock **/
    static testMethod void testWithMock() {
        Test.startTest();
        
        Double numerator = 10.7;
        Double denominator = 12.9;
        
        // Remplace la réponse du webservice par la réponse mock
        Test.setMock(WebServiceMock.class, new CalculatorWebServiceMockDivide());
        
        MyWebServiceCalculatorCallout myWebServiceCalculatorCallout = new MyWebServiceCalculatorCallout();
        
        // Compare des valeurs
        System.assertEquals(5.0, myWebServiceCalculatorCallout.divide(numerator, denominator));
        
        Test.stopTest();
    }
    
    /** Teste avec une ressource statique **/
    static testMethod void testWithStaticResource(){
    	Test.startTest();
        
        Double numerator = 10.7;
        Double denominator = 12.9;
        
        // Créé la réponse mock
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        // Utilise la ressource statique divideResult
        mock.setStaticResource('divideResult');
        
        // Attribution de la réponse mock
        Test.setMock(HttpCalloutMock.class, mock);
        
        MyWebServiceCalculatorCallout myWebServiceCalculatorCallout = new MyWebServiceCalculatorCallout();
        
        // Compare des valeurs
        System.assertEquals(5.0, myWebServiceCalculatorCallout.divide(numerator, denominator));
        
        Test.stopTest();
    }
}