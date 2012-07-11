global class SuggestedBlogsHandler implements Schedulable {

    global SuggestedBlogsHandler() {}
    
    global void execute(SchedulableContext c) {
        Date d = Date.Today();
        Datetime dt = DateTime.newInstance(d.year(), d.month(), d.day());
        String dow = dt.format('EEEE');
        
        if(dow == 'Monday') {
        
            List<Blog_Suggestion__c> suggestions = [SELECT ID, Topic__c, Assigned__r.Name, Assigned__r.Email__c, Description__c, Deadline__c from 
                                              Blog_Suggestion__c WHERE Deadline__c > TODAY ORDER BY Deadline__c ASC];
         
            String body = 'The following topics have been suggested for future blog posts.<HR />';
            for(Blog_Suggestion__c bs : suggestions) {
                body += '<h3 style="display: inline">'+bs.Topic__c + '</h3><bR />';
                body += bs.Deadline__c.format() + ':';
                if(bs.Assigned__r != null) {body += '<b>' + bs.Assigned__r.Name + '</b><BR />';}
                else { body += '<i>Unassigned</I> [ <a href="mailto:acceptblogassignment@c-5q1z0th8i3engwguc2vc5vy28.agmcima2.a.apex.salesforce.com?subject='+bs.Id+'">Assign to Me</a>]<BR />'; }
                if(bs.Description__c != null) {body += bs.Description__c;}
                body += '<BR /><BR />';
                  }
            body += '<P><a href="mailto:acceptblogtopic@7qbxmrcplkrm0kcwwfjq8wzv.agmcima2.a.apex.salesforce.com?subject=BLOGTOPIC&body=BLOGDESC">Suggest Blog Topic</a></P>';
            
            body += '<P><a href="mailto:acceptblogtopic@7qbxmrcplkrm0kcwwfjq8wzv.agmcima2.a.apex.salesforce.com?subject=RESENDTOPICS">Request This Email Again</a></P>';
            
            SuggestBlogsEmailer.sendEmail(body,'developerevangelism@salesforce.com','Upcoming Topics');
        }
        
        Date dayBefore = Date.Today().addDays(-1);
        Date dayOf = Date.Today();
        Date dayAfter = Date.Today().addDays(1);
        
        List<Blog_Suggestion__c> notices = [SELECT ID, Topic__c, Assigned__r.Name, Assigned__r.Email__c, Description__c, Deadline__c from 
                                              Blog_Suggestion__c WHERE Deadline__c = :dayBefore OR Deadline__c = :dayOf OR Deadline__c = :dayAfter];
        for(Blog_Suggestion__c bs : notices) {
                String body = 'This is a reminder of a blog topic that was assigned to you.\n\n';
                body += '<h3 style="display: inline">'+bs.Topic__c + '</h3><bR />';
                body += bs.Deadline__c.format() + ':';
                if(bs.Assigned__r != null) {body += '<b>' + bs.Assigned__r.Name + '</b><BR />';}
                else { body += '<i>Unassigned</I> [ <a href="mailto:acceptblogassignment@c-5q1z0th8i3engwguc2vc5vy28.agmcima2.a.apex.salesforce.com?subject='+bs.Id+'">Assign to Me</a> ]<BR />'; }
                if(bs.Description__c != null) {body += bs.Description__c;}
                SuggestBlogsEmailer.sendEmail(body,bs.Assigned__r.Email__c+',joshua.birk@gmail.com','Topic Reminder');
                }
    }    
    
}