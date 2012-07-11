public with sharing class MetricCloudController {

	private BlogMetric[] metrics;

	public List<String> tagHTML {get; set;}

	public MetricCloudController() {
		
	}
	
	public BlogMetric[] getMetrics() {
		return metrics;
	}
	
	public void setMetrics(BlogMetric[] m) {
		metrics = m;
		tagHTML = new List<String>();
		for(BlogMetric b : metrics) {
			String pt = '11';
			String weight = 'normal';
			if(b.value == 1) { pt = '10'; }
			if(b.value > 2) { pt = '12'; }
			if(b.value > 5) { pt = '14'; }
			
			if(b.value > 4) { weight = 'bold'; }
			
                }
	}
    
        @isTest static void testTag() {
                MetricCloudController m = new MetricCloudController();
                BlogMetric b = new BlogMetric('foo',1);
                List<BlogMetric> metrics = new List<BlogMetric>();
                metrics.add(b);
                m.setMetrics(metrics);
                System.assertEquals(m.getMetrics().size(),1);
            }

}