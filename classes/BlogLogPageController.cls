public class BlogLogPageController {
    
    public String action {get; set;}
    public String email {get; set;}
    public String body {get; set;}
    
    public BlogLogPageController() {
        action = ApexPages.currentPage().getParameters().get('act');
        email = ApexPages.currentPage().getParameters().get('em');
        
        if(action == 'assign') {
                String bsid = ApexPages.currentPage().getParameters().get('i');
                List<Blog_Suggestion__c> blogSuggestion = [SELECT Id, Assigned__c from Blog_Suggestion__c WHERE Id =: bsid LIMIT 1];
                if(blogSuggestion.size() == 0) {
                     body += 'ERROR: There was no blog suggestion found for that ID.';                                              
                 } else {
                     List<Blog_Author__c> author = [SELECT Id, Email__C from Blog_Author__c WHERE Email__c =: email LIMIT 1];
                     if(author.size() == 0) { body += 'ERROR: No Author found for your email address.  Ask Josh.'; }
                     else { 
                        blogSuggestion[0].Assigned__c = author[0].Id; 
                        update blogSuggestion;
                         
                        body += 'The blog suggestion has been assigned to you.';
                     }
                 }
               SuggestBlogsEmailer.sendEmail(body,email,'Assigned Topic Response');   
        }
        
    }
    
}