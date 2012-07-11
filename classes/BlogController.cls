public class BlogController {
	
	public Integer blogCount {get; set;}
	public List<BlogMetric> tags {get; set;}
        public String beginDay {get; set;}
        public String endDay { get; set; }
        public Boolean filterCommunity { get; set; }
    
	public List<BlogMetric> dates {get; set;}
	public List<BlogMetric> categories {get; set;}
	public List<BlogMetric> authors {get; set;}
	
	public String dateLabels {get; set;}
	public String dateData {get; set;}
        public String daysofWeek {get; set;}
	
	public String authorLabels {get; set;}
	public String authorData {get; set;}
	
	public String catLabels {get; set;}
	public String catData {get; set;}
	
	public Date metricsDate {get; set;}
	
	
	public BlogController() {
		filterCommunity = true;
                refresh();	
	}
	
        public PageReference refresh() {                   
                        Date d2 = Date.Today();
			if(ApexPages.currentPage().getParameters().get('d') != null) {
				d2 = Date.parse(ApexPages.currentPage().getParameters().get('d'));
			}
			
			Date d1 = d2.toStartOfMonth();
			d2 = d2.addDays(Date.daysInMonth(d2.year(),d2.month()) - d2.day());
			
                        beginDay = d1.format();
			endDay = d2.format();
                        if(!filterCommunity) {
                            blogCount = (Integer)[SELECT Count(ID) from Blog_Entry__c WHERE Published__c >= :d1 AND Published__c <= :d2].get(0).get('expr0');
			} else {
                            blogCount = (Integer)[SELECT Count(ID) from Blog_Entry__c WHERE Published__c >= :d1 AND Published__c <= :d2 AND Category__c != 'Community'].get(0).get('expr0');
			}
                        
                        tags = new List<BlogMetric>();
			dates = new List<BlogMetric>();
			categories = new List<BlogMetric>();
			authors = new List<BlogMetric>();
                        daysofWeek = '';
			
			getMonthTagCount(d1,d2);
			getBlogPostsByDate(d1,d2);
			getBlogPostsByAuthor(d1,d2);
			getBlogPostsByCategory(d1,d2);
			
			dateLabels = '';
			dateData = '';
			for(BlogMetric b : dates) {
				if(b.value != null) {
					dateLabels += '|' +b.label;
					dateData += ',' + b.value;
				}
			}
			dateLabels = dateLabels.substring(1,dateLabels.length());
			dateData = dateData.substring(1,dateData.length());
			
			authorLabels = '';
			authorData = '';
			for(BlogMetric b : authors) {
				if(b.value != null) {
					String label = (String)b.label;
					authorLabels += '|' + label.split(' ')[0];
					authorData += ',' + b.value;
				}
			}
			
                        if(authorLabels.length() > 1) {
                            authorLabels = authorLabels.substring(1,authorLabels.length());
                        }
        
                        if(authorData.length() > 1) {
                            authorData = authorData.substring(1,authorData.length());
			}
            
			catLabels = '';
			catData = '';
			for(BlogMetric b : categories) {
				if(b.label != null) {
					catLabels += '|' +b.label;
					catData += ',' + b.value;
				}
			}
			
                    if(catLabels.length() > 1) {
                        catLabels = catLabels.substring(1,catLabels.length());
			catData = catData.substring(1,catData.length());
                    }
                        
                    return Page.BlogMetrics;
            }
    
	public void getBlogPostsByDate(Date d1, Date d2) {
		List<AggregateResult> result;
                if(!filterCommunity) {
                    result = [SELECT Count(ID), Published__c from Blog_Entry__c WHERE Published__c >= :d1 AND Published__c <= :d2 GROUP BY Published__c ORDER BY Published__c ];
		} else {
                    result = [SELECT Count(ID), Published__c from Blog_Entry__c WHERE Published__c >= :d1 AND Published__c <= :d2 AND Category__c != 'Community' GROUP BY Published__c ORDER BY Published__c ];
		}
                Map<String,Integer> metricsCount = new Map<String,Integer>();
		for(AggregateResult res : result) {
			Date d = (Date)res.get('Published__c');
			dates.add(new BlogMetric(String.valueOf(d.month()) + '/' + String.valueOf(d.day()),(Integer)res.get('expr0')));
		}
		for(Integer x = d1.day(); x < d2.day(); x++) {
			Boolean hasResult = false;
			for(BlogMetric b : dates) {
				if(b.label == (String.valueOf(d1.month()) + '/' + String.valueOf(x))) {
					hasResult = true;
				}
			}
			if(!hasResult) { 
				dates.add(new BlogMetric(String.valueOf(d1.month()) + '/' + String.valueOf(x),0)); 
				}
                        Datetime dt = DateTime.newInstance(d1.year(), d1.month(), x);
                        String dow = dt.format('EEEE');
                        daysofWeek += ',' + dow;
		}
		List<BlogMetric> newDates = new List<BlogMetric>();
		for(Integer i = 1; i <= dates.size(); i++) {
			for(BlogMetric b : dates) {
				String label = (String)b.label;
				if(Integer.valueOf(label.split('/')[1]) == i) {
					newDates.add(b);
				}
			}
		}
		dates = newDates;
                daysofWeek = daysofWeek.substring(1,daysofWeek.length());
	}
	
	public void getBlogPostsByCategory(Date d1, Date d2) {
		List<AggregateResult> result;
                if(!filterCommunity) {
                    result = [SELECT Count(ID), Category__c from Blog_Entry__c WHERE Published__c >= :d1 AND Published__c <= :d2 GROUP BY Category__c];
		} else {
                    result = [SELECT Count(ID), Category__c from Blog_Entry__c WHERE Published__c >= :d1 AND Published__c <= :d2 AND Category__c != 'Community' GROUP BY Category__c];
		}
                Map<String,Integer> metricsCount = new Map<String,Integer>();
		for(AggregateResult res : result) {
			categories.add(new BlogMetric((String)res.get('Category__c'),(Integer)res.get('expr0')));
		}
	}
	
	public void getBlogPostsByAuthor(Date d1, Date d2) {
		List<AggregateResult> result;
                if(!filterCommunity) {
                    result = [SELECT Count(ID), Author__c from Blog_Entry__c WHERE Published__c >= :d1 AND Published__c <= :d2 GROUP BY Author__c];
		} else { 
                    result = [SELECT Count(ID), Author__c from Blog_Entry__c WHERE Published__c >= :d1 AND Published__c <= :d2 AND Category__c != 'Community' GROUP BY Author__c];
		}
                Map<String,Integer> metricsCount = new Map<String,Integer>();
		for(AggregateResult res : result) {
			authors.add(new BlogMetric((String)res.get('Author__c'),(Integer)res.get('expr0')));
		}
	}
	
	public void getMonthTagCount(Date d1, Date d2) {
        String res1String = '';
		List<AggregateResult> result;
                if(!filterCommunity) {
                    result = [SELECT COUNT(Id), Tag_1__c from Blog_Entry__c WHERE Tag_1__c != 'null' AND Published__c >= :d1 AND Published__c <= :d2 GROUP BY Tag_1__c];
		} else {
                    result = [SELECT COUNT(Id), Tag_1__c from Blog_Entry__c WHERE Tag_1__c != 'null' AND Published__c >= :d1 AND Published__c <= :d2 AND Category__c != 'Community' GROUP BY Tag_1__c];
                }
            
                Map<String,Integer> metricsCount = new Map<String,Integer>();
		
		for(AggregateResult res : result) {
			if(res.get('Tag_1__c') != null && res.get('Tag_1__c') != 'null' && res.get('Tag_1__c') != '') {
				if(!metricsCount.containsKey((String)res.get('Tag_1__c'))) {
					metricsCount.put((String)res.get('Tag_1__c'),(Integer)res.get('expr0'));
				} else {
					metricsCount.put((String)res.get('Tag_1__c'), metricsCount.get((String)res.get('Tag_1__c')) + (Integer)res.get('expr0'));
				}
			}
		}
		
                if(!filterCommunity) {
                    result = [SELECT COUNT(Id), Tag_2__c from Blog_Entry__c WHERE Tag_2__c != 'null' AND Published__c >= :d1 AND Published__c <= :d2 GROUP BY Tag_2__c];
		} else {
                    result = [SELECT COUNT(Id), Tag_2__c from Blog_Entry__c WHERE Tag_2__c != 'null' AND Published__c >= :d1 AND Published__c <= :d2 AND Category__c != 'Community' GROUP BY Tag_2__c];
                }
		
                for(AggregateResult res : result) {
			if(res.get('Tag_2__c') != null && res.get('Tag_2__c') != 'null' && res.get('Tag_2__c') != '') {
				if(!metricsCount.containsKey((String)res.get('Tag_2__c'))) {
					metricsCount.put((String)res.get('Tag_2__c'),(Integer)res.get('expr0'));
				} else {
					metricsCount.put((String)res.get('Tag_2__c'), metricsCount.get((String)res.get('Tag_2__c')) + (Integer)res.get('expr0'));
				}
			}
		}
		if(!filterCommunity) {
                    result = [SELECT COUNT(Id), Tag_3__c from Blog_Entry__c WHERE Tag_3__c != 'null' AND Published__c >= :d1 AND Published__c <= :d2 GROUP BY Tag_3__c];
		} else {
                    result = [SELECT COUNT(Id), Tag_3__c from Blog_Entry__c WHERE Tag_3__c != 'null' AND Published__c >= :d1 AND Published__c <= :d2 AND Category__c != 'Community' GROUP BY Tag_3__c];
                }
                
                for(AggregateResult res : result) {
			if(res.get('Tag_3__c') != null && res.get('Tag_3__c') != 'null' && res.get('Tag_3__c') != '') {
				if(!metricsCount.containsKey((String)res.get('Tag_3__c'))) {
					metricsCount.put((String)res.get('Tag_3__c'),(Integer)res.get('expr0'));
				} else {
					metricsCount.put((String)res.get('Tag_3__c'), metricsCount.get((String)res.get('Tag_3__c')) + (Integer)res.get('expr0'));
				}
			}
		}
		
		tags = new List<BlogMetric>();
		
		Set<String> tagsSet = metricsCount.keySet();
		for(String tag : tagsSet) {
			tags.add(new BlogMetric(tag,(Integer)metricsCount.get(tag)));
		} 

    }
    
    @RemoteAction
    public static List<Blog_Entry__c> getFilteredBlogPosts(String filterName, String filter, String beginDay, String endDay, Boolean filterCommunity) {
        List<Blog_Entry__c> blogs = new List<Blog_Entry__c>();
        Date d1 = Date.parse(beginDay);
        Date d2 = Date.parse(endDay);
        if(filterName == 'category') {
                blogs = [SELECT ID, Author__c, Link__c, Title__c, Published__c from Blog_Entry__c WHERE Category__c = :filter AND Published__c >= :d1 AND Published__c <= :d2];
        }
        
        if(filterName == 'author') {
                String likeFilter = filter + '%';
                if(!filterCommunity) {
                    blogs = [SELECT ID, Author__c, Link__c, Title__c, Published__c from Blog_Entry__c WHERE Author__c LIKE :likeFilter AND Published__c >= :d1 AND Published__c <= :d2];
                } else {
                    blogs = [SELECT ID, Author__c, Link__c, Title__c, Published__c from Blog_Entry__c WHERE Category__c != 'Community' AND Author__c LIKE :likeFilter AND Published__c >= :d1 AND Published__c <= :d2];
                }
        }
        
        if(filterName == 'tag') {
                if(!filterCommunity) {
                    blogs = [SELECT ID, Author__c, Link__c, Title__c, Published__c from Blog_Entry__c WHERE (Tag_1__c =: filter OR Tag_2__c =: filter OR Tag_3__c =: filter) AND (Published__c >= :d1 AND Published__c <= :d2)];
                } else {
                    blogs = [SELECT ID, Author__c, Link__c, Title__c, Published__c from Blog_Entry__c WHERE (Tag_1__c =: filter OR Tag_2__c =: filter OR Tag_3__c =: filter) AND (Published__c >= :d1 AND Published__c <= :d2) AND Category__c != 'Community'];
                }
        }
        
        if(filterName == 'calendar') {
                Date t = Date.today();
                String dateString = filter + '/' + String.valueOf(t.year());
                Date dA = Date.parse(dateString).toStartOfWeek();
                Date dB = dA.addDays(6);
                if(!filterCommunity) {
                    blogs = [SELECT ID, Author__c, Link__c, Title__c, Published__c from Blog_Entry__c WHERE Published__c >= :dA AND Published__c <= :dB];
                } else {
                    blogs = [SELECT ID, Author__c, Link__c, Title__c, Published__c from Blog_Entry__c WHERE Category__c != 'Community' AND Published__c >= :dA AND Published__c <= :dB];
                }
        }
        
        return blogs;
        
        }

}