@isTest
public class TestThumbnailListController {

    @isTest
    static void testInit() {
        //Create test data
        
        //Invoke functionality
        String thumbnailListJs = '';
        String configJson = '';
        Test.startTest();
            ThumbnailListController ctlr = new ThumbnailListController();
            ctlr.config.debug = true;
            thumbnailListJs = ctlr.getThumbnailListJS();
            configJson = ctlr.getConfigAsJson();
        Test.stopTest();
        
        //Check results
        System.assertEquals('ThumbnailListJS', thumbnailListJs);
        System.assert('' != configJson);
    }
    
    @isTest
    static void testConfig() {
        //Create test data
        
        //Invoke functionality
        ThumbnailListController ctlr = null;
        Test.startTest();
            ctlr = new ThumbnailListController();
            ctlr.config.debug = true;
            ctlr.config.elemId = 'testId';
            ctlr.config.sObjectType = 'User';
            ctlr.config.imageUrlField = 'SomeField';
            ctlr.config.labelField = 'SomeField2';
            ctlr.config.subLabelField = 'SomeField3';
            ctlr.config.sortByField = 'SomeField2';
            ctlr.config.filter = 'none';
            ctlr.config.filterClause = 'none2';
            ctlr.config.listItemStyleClass = 'itemClass';
            ctlr.config.listDividerStyleClass = 'dividerClass';
            ctlr.config.nextPage = '#somePage';
            ctlr.config.jsCtlrName = '$App.ThumbnailListJs';
        Test.stopTest();
        
        //Check results
        System.assertEquals(true, ctlr.config.debug);
        System.assertEquals('testId', ctlr.config.elemId);
        System.assertEquals('User', ctlr.config.sObjectType);
        System.assertEquals('SomeField', ctlr.config.imageUrlField);
        System.assertEquals('SomeField2', ctlr.config.labelField);
        System.assertEquals('SomeField3', ctlr.config.subLabelField);
        System.assertEquals('SomeField2', ctlr.config.sortByField);
        System.assertEquals('none', ctlr.config.filter);
        System.assertEquals('none2', ctlr.config.filterClause);
        System.assertEquals('itemClass', ctlr.config.listItemStyleClass);
        System.assertEquals('dividerClass', ctlr.config.listDividerStyleClass);
        System.assertEquals('#somePage', ctlr.config.nextPage);
        System.assertEquals('$App.ThumbnailListJs', ctlr.config.jsCtlrName);
    }
    
    @isTest
    static void testRemoteMethod() {
        //Create test data
        ThumbnailListController.ThumbnailListConfig config = new ThumbnailListController.ThumbnailListConfig();
        config.imageUrlField = 'FullPhotoUrl';
        config.labelField = 'Name';
        config.subLabelField = 'Phone';
        config.sortByField = 'Name';
        config.sObjectType = 'User';
        
        //Invoke functionality
        List<Sobject> recordsReceived = new List<Sobject>();
        Test.startTest();
            recordsReceived = ThumbnailListController.getRecordsForConfig(config);
        Test.stopTest();
        
        //Check results
        Integer usersInDbCount = [SELECT COUNT() FROM User];
        System.assertEquals(usersInDbCount, recordsReceived.size());
    }

}