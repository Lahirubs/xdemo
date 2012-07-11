global class PopulationController {


    global PopulationController() {}
    global PopulationController(ApexPages.StandardController controller) {}
    
    @RemoteAction
    global static List<DFSurvey__c> getSurveyResults() {
        List<DFSurvey__c> s = [SELECT ID,
            Years_Using_Salesforce__c,
            Years_Using_Apex__c,
            Years_Using_Visualforce__c,
            Years_Using_Flex__c,
            Years_At_Dreamforce__c FROM DFSurvey__c
            ORDER BY LastModifiedDate];
        return s;
    }
    
    global static void deleteSurveyResults() {
        List<DFSurvey__c> s = [SELECT ID from DFSurvey__c];
        delete s;
    }
    
    @isTest
    global static void testResults() {
        DFSurvey__c d = new DFSurvey__c();
        PopulationController.getSurveyResults();
        PopulationController.deleteSurveyResults();
        
    }

}