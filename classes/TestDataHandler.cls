public with sharing class TestDataHandler {

	public TestDataHandler() {

	
	}
	
	public static void createCars() {
		Car__c c = (Car__c)SmartFactory.createSObject('Car__c');
		insert c;
	
	}

}