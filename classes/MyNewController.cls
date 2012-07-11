public with sharing class MyNewController {

    public String myVariable { get; set; }

	public PageReference customEdit() {
		PageReference page = new PageReference('/003');
		return page;
	}
}