public class BlogCalendarHandler {

    public static void addBlogTopicToCalendar(Blog_Suggestion__c bs) {
        CalendarService service = new CalendarService();
        service.useClientLogin('joshua.birk@salesforce.com','J0shua400');
        GoogleData.Calendar cal = service.getCalendarByTitle('Blog Topics');
            event newEvent = new Event(
            subject = bs.Topic__c,
            description = bs.Description__c,
            ActivityDateTime = bs.Deadline__c,
            DurationInMinutes = 60
            );
        
        xmldom.element entry = service.insertEvent( cal, newEvent );  
        entry.dumpAll();  
    }
    

    
}