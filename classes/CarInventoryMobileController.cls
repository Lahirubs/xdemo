public with sharing class CarInventoryMobileController {

    List<Car__c> cars;
    
    public List<Car__c> getCars(){
        if(cars == null){
            cars = [select Id, Name, Brand__c, Model__c, VIN__c from Car__c order by Brand__c];
        }
        return cars;
    }

}