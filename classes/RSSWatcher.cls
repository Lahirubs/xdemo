global class RSSWatcher {
	
	global static void sendEmailNotice(String links) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(Label.blogemaillist.split(','));
        mail.setSubject ('[BLOGLOG] New Entries');  
        mail.setPlainTextBody('New blog posts have been created.\n\n'+links+'\n\nBlogs List https://na7.salesforce.com/a07?fcf=00BA0000005ms9A \n\n ');
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}

}