global class Utility {
	global static Date convertWordpressDateStringToDate(String s) {
		String months = 'January,February,March,April,May,June,July,August,September,October,November,December';
		String monthsShort = 'Janu,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';
		
		String m,d,y;
		
		//check to see if it is in Mon, Day Year format
		if( months.indexOf(s.substring(0,s.indexOf(' '))) >= 0 ) {
			String[] monthsArray = months.split(',');
			String mString = s.substring(0,s.indexOf(' '));
			for(Integer i = 0; i < monthsArray.size(); i++) {
				if(mString == monthsArray[i]) {
					m = String.valueOf(i + 1);
				}
			}
		} 
		
		if( monthsShort.indexOf(s.substring(0,s.indexOf(' '))) >= 0 ) {
			String[] monthsArray = monthsShort.split(',');
			String mString = s.substring(0,s.indexOf(' '));
			for(Integer i = 0; i < monthsArray.size(); i++) {
				if(mString == monthsArray[i]) {
					m = String.valueOf(i + 1);
				}
			}
		}
		
		d = s.substring(s.indexOf(' ')+1,s.indexOf(','));
		y = s.substring(s.indexOf(',')+1,s.length());
		
		return Date.parse(m+'/'+d+'/'+y);
			
	}
	
	global static Date convertRSSDateStringToDate(String s) {
		String months = 'January,February,March,April,May,June,July,August,September,October,November,December';
		String monthsShort = 'Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec';
		
		String m,d,y;
		
		String[] dateArray = s.split(' ');
		d = dateArray[1];
		y = dateArray[3];
		if( monthsShort.indexOf(dateArray[2]) >= 0 ) {
			String[] monthsArray = monthsShort.split(',');
			String mString = dateArray[2];
			for(Integer i = 0; i < monthsArray.size(); i++) {
				if(mString == monthsArray[i]) {
					m = String.valueOf(i + 1);
				}
			}
		}
		
		return Date.parse(m+'/'+d+'/'+y);
			
	}

    global static String convertStringToLink(String s) {
    //    System.debug('LINK'+s);
        Integer i = s.length();
        String returnString = '';
        String alphanum = 'abcdefghijklmnopqrstuvwxyz0123456789';
        for(Integer x = 0; x < i; x++) {
            String c = s.substring(x,x+1);
        //    System.debug('LINK CHAR'+c);
            if(alphanum.indexOf(c.toLowerCase()) != -1) {
                returnString += c;
            }
            if(c == ' ' || c == '.') {
                returnString += '-';
            }
        }
        
        return returnString;
    }


}