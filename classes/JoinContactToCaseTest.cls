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
private class JoinContactToCaseTest {

	public static List<Contact> contactsList;
	public static List<Case> casesList;
	public static String email1;
	
	static void init(){
		contactsList = new List<Contact>();
		casesList = new List<Case>();
		
		email1 = 'toto@toto.com';
		
		casesList.add(new Case(
			SuppliedEMail = email1
		));
	}

	/** Test avec un contact existant **/
    static testMethod void testWithExistingContact() {
        init();
        Test.startTest();
        
        contactsList.add(new Contact(
			Email = email1,
			LastName = email1
		));
		insert contactsList;
		
		insert casesList;
		
		// Récupération du case pour être sûr d'avoir le champs 'ContactId' non null
		casesList = [
			SELECT Id, ContactId
			FROM Case
			WHERE Id = :casesList[0].Id
		];
		
		// Vérification que le case est relié au bon contact
		System.assertEquals(casesList[0].ContactId, contactsList[0].Id);
        
        Test.stopTest();
    }
    
    /** Test avec un contact inexistant **/
    static testMethod void testWithDoesntExistingContact() {
        init();
        Test.startTest();
        
        insert casesList;
		
		// Récupération du case pour être sûr d'avoir le champs 'ContactId' non null
		casesList = [
			SELECT Id, ContactId
			FROM Case
			WHERE Id = :casesList[0].Id
		];
		
		// Récupération du contact créé avec le trigger
		contactsList = [
			SELECT Id, Email
			FROM Contact
			WHERE Email = :email1
		];
		
		// Vérification que le case est relié au bon contact
		System.assertEquals(casesList[0].ContactId, contactsList[0].Id);
        
        Test.stopTest();
    }
}