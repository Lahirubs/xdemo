public class Web2LeadExtension {

    public Lead wlead {get; set;}
  
    public Web2LeadExtension(ApexPages.StandardController
                                stdController) {
       wlead = (Lead)stdController.getRecord();
     }

     public PageReference saveLead() {
       try {
           insert(wlead);
       }
       catch(System.Exception e) {
           ApexPages.addMessages(e);
           return null;
       }
       PageReference p = Page.MyProfilePage;
       return p;
     }
}