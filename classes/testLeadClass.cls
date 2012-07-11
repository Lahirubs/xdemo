@isTest 
private class testLeadClass{

private testLeadClass() {}

static testmethod void saveLeadTest(){
       
         Lead l = new Lead(company='test company',lastname='xyz');
         test.starttest(); 
         Web2LeadExtension ext = new Web2LeadExtension(new ApexPages.StandardController(l));
         PageReference p = ext.saveLead();
         test.stoptest();

 

system.assertEquals(Page.myProfilePage.getUrl(),p.getUrl());
       
      }

   static testmethod void saveLeadTest2(){
        
        
        // Lead l = new Lead(company='testcompany');
         test.starttest();
         Web2LeadExtension ext = new Web2LeadExtension(new ApexPages.StandardController(new Lead()));
         PageReference p = ext.saveLead();
         test.stoptest();
         system.assertEquals(null,p);
        
     }


}