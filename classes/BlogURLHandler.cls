global class BlogURLHandler {

    public String url {get; set;}
    public Blog_Entry__c blog {get; set;}
    public String html { get; set; }
    public String status { get; set; }
    
    public BlogURLHandler() {
        url = 'http://blogs.developerforce.com/page/';
        blog = new Blog_Entry__c();
        html = '';
        status = 'Ready';
    }
    
    public PageReference saveBlog() {
    	
    	List<Blog_Entry__c> blogs = [SELECT Id, Title__c from Blog_Entry__c WHERE Title__c =: blog.Title__c LIMIT 1];
    	if(blogs.size() > 0) {Blog_Entry__c b = blogs[0]; blog = new Blog_Entry__c(Id = b.Id, Published__c = blog.Published__c, 
    		Title__c = blog.Title__c, Author__c = blog.Author__c, Link__c = blog.Link__c, Category__c = blog.Category__c,
    		Tag_1__c = blog.Tag_1__c, Tag_2__c = blog.Tag_2__c, Tag_3__c = blog.Tag_3__c, Blog_Tags__c = blog.Blog_Tags__c,
    		Lead_Copy__c = blog.Lead_Copy__c); 
    		}
    	else {
    		blog = new Blog_Entry__c(Published__c = blog.Published__c, Title__c = blog.Title__c, Author__c = blog.Author__c, Link__c = blog.Link__c, Category__c = blog.Category__c,
    		Tag_1__c = blog.Tag_1__c, Tag_2__c = blog.Tag_2__c, Tag_3__c = blog.Tag_3__c, Blog_Tags__c = blog.Blog_Tags__c,
    		Lead_Copy__c = blog.Lead_Copy__c);
    	}
    	
    	upsert blog;
    	status = blog.Title__c + ' saved, ID:'+blog.Id;
    	
    	return null;
    }
    
    public PageReference getURL() {
       HttpRequest req = new HttpRequest();
       req.setEndpoint(url);
       req.setMethod('GET');
       
       Http http = new Http();
       HTTPResponse res = http.send(req);   
       
       html = res.getBody();
       html = html.substring(html.indexOf('<div id="blogcontent">'),html.indexOf('<div id="footer">'));
       
       status = 'Loaded page: '+url;
       
       blog = new Blog_Entry__c();
        
       return null;
    }
    
    @RemoteAction
    global static String getPublishDate(string publishString) {
    	return Utility.convertWordpressDateStringToDate(publishString).format();
    }
    

}