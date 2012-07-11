global class AcceptBlogEmailer implements Messaging.InboundEmailHandler {
 
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                       Messaging.InboundEnvelope env){
 
                                                           
       Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
       String bEmail = email.fromAddress;
       String bsid = email.Subject;                                                    
       
       String body = '';                                      
                                                           
       List<Blog_Suggestion__c> blogSuggestion = [SELECT Id, Assigned__c from Blog_Suggestion__c WHERE Id =: bsid LIMIT 1];
       if(blogSuggestion.size() == 0) {
                 body += 'ERROR: There was no blog suggestion found for that ID.';                                              
                 } else {
                 List<Blog_Author__c> author = [SELECT Id, Email__C from Blog_Author__c WHERE Email__c =: bEmail LIMIT 1];
                     if(author.size() == 0) { body += 'ERROR: No Author found for your email address.  Ask Josh.'; }
                     else { 
                        blogSuggestion[0].Assigned__c = author[0].Id; 
                        update blogSuggestion;
                         
                        body += 'The blog suggestion has been assigned to you.';
                     }
                 }
       SuggestBlogsEmailer.sendEmail(body,bEmail,'Assigned Topic Response');                                                    
       result.success = true;
       return result; 
       }
    
}