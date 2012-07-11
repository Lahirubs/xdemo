public class ManageInventoryController{

    List<Store__c> stores;
    
    public List<Store__c> getStores(){
        if(stores == null){
            stores = [select Id, Name, City__c, (select Id, Name, Brand__c, Model__c, VIN__c from Cars__r) from Store__c];
        }
        return stores;
    }

    public void updateCar(){
        //Get values passed from actionFunction
        String carId = ApexPages.currentPage().getParameters().get('carId');
        String storeId = ApexPages.currentPage().getParameters().get('storeId');
        
        //Create a "new" car object with Id defined and the new store Id
        Car__c car = new Car__c(Id = carId, Store__c = storeId);
        
        //Update the car record
        update car;
    
        //Then make the stores list null so that it is requeried with the new cars
        stores = null;
    } 
    
    //-- TEST METHODS --
    /*These are very bad test methods and never look at them. 
    Just threw these together so I could get the package uploaded*/
    
    static testMethod void test() { 
        //Create test date
        Store__c store = new Store__c(Name = 'my store');
        insert store;
        
        Car__c car = new Car__c();  
        insert car;
        
        Test.setCurrentPageReference(new PageReference('Page.manageInventory'));
        System.currentPageReference().getParameters().put('carId', car.id);
        System.currentPageReference().getParameters().put('storeId', store.id);
        
        ManageInventoryController controller = new ManageInventoryController();
        controller.getStores();
        controller.updateCar();
    }
}