trigger BlogEntryTrigger on Blog_Entry__c (before insert, before update) {


	for(Blog_Entry__c b : Trigger.new) {
		b.SEO_Title__c = Utility.convertStringToLink(b.Title__c);
	}


}