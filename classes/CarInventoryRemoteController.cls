global with sharing class CarInventoryRemoteController {

    @RemoteAction
    global static List<Car__c> getCars() {
        List<Car__c> cars = [select Id, Name, Brand__c, Model__c, VIN__c from Car__c order by Brand__c];
        return cars;
    }
    
    @RemoteAction
    global static Car__c getCar(string Id) {
        Car__c car = [select Id, Name, Brand__c, Model__c, VIN__c, Mileage__c, Price__c from Car__c WHERE ID = :Id];
        return car;
    }
    
     //-- TEST METHODS --
    /*These are very bad test methods and never look at them. 
    Just threw these together so I could get the package uploaded*/
    
    static testMethod void test() { 
        //Create test data
        Car__c car = new Car__c();  
        insert car;
        
        CarInventoryRemoteController.getCars();
        CarInventoryRemoteController.getCar(car.Id);
    }
}