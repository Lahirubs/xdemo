public class RESTTest {

    public void retrieveRemoteData(){
		RestUtility ru = new RestUtility();
		if(ru.login('3MVG9zeKbAVObYjPJixRj0EVnsFUqlMKvahFweySggVWeFlxzows.7F2i6uBg5s7OijLzyd9IzAFk5SfTsmcP', '9133363525192674513', 'josh@rest.com', ru.getMyPassword(), '')){
			String qString = 'Select+Id,Name+From+Dog__c+LIMIT+1';
			String res = ru.getSOQLQuery(qString);
			System.debug(res);
		}
		
	}
    
}