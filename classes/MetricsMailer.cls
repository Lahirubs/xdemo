global class MetricsMailer implements Schedulable, Messaging.InboundEmailHandler {

	global MetricsMailer() {}
	
	global void execute(SchedulableContext c) {
        Date d = Date.today();
		MetricsMailer.sendEmailMetrics(String.valueOf(d.month()) + '/' + String.valueOf(d.day()) + '/' + String.valueOf(d.year()),'all');
    }
	
	global static void sendEmailMetrics(String d, String email) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(email == 'all') {
			mail.setToAddresses(Label.blogemaillist.split(','));
		} else {
			List<String> a = new List<String>();
			a.add(email);
			mail.setToAddresses(a);
		}
        mail.setSubject ('[BLOGLOG] Blog Metrics for '+d);  
		PageReference metricsPage = Page.BlogMetrics;
		metricsPage.getParameters().put('d', d);
		String htmlBody = metricsPage.getContent().toString();

        mail.setPlainTextBody(htmlBody);
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}
	
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
	                                                       Messaging.InboundEnvelope env){
						
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		try {
			Date d = Date.parse(email.subject);
			MetricsMailer.sendEmailMetrics(email.subject,email.fromAddress);
			result.success = true;
			return result;
		} catch (Exception e) {
			Date d = Date.today();
			MetricsMailer.sendEmailMetrics(String.valueOf(d.month()) + '/' + String.valueOf(d.day()) + '/' + String.valueOf(d.year()),email.fromAddress);
			result.success = true;
			return result;
		}
		
		result.success = false;
		return result;
	}

}