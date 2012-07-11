global class SuggestBlogsEmailer implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                       Messaging.InboundEnvelope env){
 
                                                           
       Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
       String bEmail = email.fromAddress;
       String bstopic = email.Subject;                                                    
       String bsDesc = email.PlainTextBody;
                                                           
       if(bsTopic == 'RESENDTOPICS') { 
            List<Blog_Suggestion__c> suggestions = [SELECT ID, Topic__c, Assigned__r.Name, Assigned__r.Email__c, Description__c, Deadline__c from 
                                              Blog_Suggestion__c WHERE Deadline__c > TODAY ORDER BY Deadline__c ASC];
         
            String body = 'The following topics have been suggested for future blog posts.<HR />';
            for(Blog_Suggestion__c bs : suggestions) {
                body += '<h3 style="display: inline">'+bs.Topic__c + '</h3><bR />';
                body += bs.Deadline__c.format() + ':';
                if(bs.Assigned__r != null) {body += '<b>' + bs.Assigned__r.Name + '</b><BR />';}
                else { body += '<i>Unassigned</I> [ <a href="mailto:acceptblogassignment@c-5q1z0th8i3engwguc2vc5vy28.agmcima2.a.apex.salesforce.com?subject='+bs.Id+'">Assign to Me</a> ]<BR />'; }
                if(bs.Description__c != null) {body += bs.Description__c;}
                body += '<BR /><BR />';
                  }
            sendEmail(body,bEmail,'Upcoming Topics');   
       } else {
       
           Blog_Suggestion__c bs = new Blog_Suggestion__c(SuggestedBy__c=bEmail,Topic__c=bstopic,Description__c=bsDesc);
           Date td = Date.Today();
           bs.Deadline__c = td;
                                                           
           insert bs;                                                    
                                                           
           SuggestBlogsEmailer.sendEmail('Topic Suggested',bEmail,'Assigned Topic Response');                                                    
       }
    
       result.success = true;
       return result; 
       }
    
    
    global static void sendEmail(String body, String toEmail, String Subject) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> tos = new List<String>();
                if(toEmail.contains(',')) { 
                    tos = toEmail.split(','); 
                } else { tos.add(toEmail); }
                mail.setToAddresses(tos);
                mail.setSubject ('[BLOGLOG] ' + Subject);  
                mail.setHTMLBody(body);
         
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

}