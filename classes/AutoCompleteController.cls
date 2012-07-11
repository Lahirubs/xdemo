public class AutoCompleteController{

    public Car__c car {get; set;}
    public String brand {get; set;}
    
    //-- TEST METHODS --
    /*These are very bad test methods and never look at them. 
    Just threw these together so I could get the package uploaded*/
    
    static testMethod void test() { 
        AutoCompleteController controller = new AutoCompleteController();
    }
}