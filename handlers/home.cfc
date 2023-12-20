component {
	property name="notifyService"		inject="id:notifyService@cbSendPulse";
	property name="settingService"		inject="id:settingService@contentbox";
   	property name="CBHelper"			inject="id:CBHelper@contentbox";
   	property name="cbMessagebox" 	inject="messagebox@cbmessagebox";
   	
   	function preHandler(event,rc,prc){
   		
   	}

	function index(event,rc,prc) {
		prc.xehContactSetting	= CBHelper.buildModuleLink("cbSendPulse","home.saveSettings");
		prc.xehNotifyForm = CBHelper.buildModuleLink("cbSendPulse","home.contactFormSettings");
		prc.xehNotifySubmit = CBHelper.buildModuleLink("cbSendPulse","home.saveNotify");
		event.paramValue( "clientId", "" ).paramValue( "clientSecret", "" ).paramValue( "access_token_url", "" ).paramValue( "website_url", "" ).paramValue( "limitVal", "" ).paramValue( "limitVal", "" ).paramValue( "offsetVal", "" ).paramValue( "post_task_url", "" );
		var args 	= { name="cb_cbSendPulse" };
		var allsettings = settingService.findWhere( criteria=args );

		if(!isNull(allsettings)){
			var pairs=deserializeJSON(allsettings.getValue());
			for( var key in pairs ){
				event.setValue(key,pairs[key] );
			}
		}
		event.setView( view="home/index",module="cbSendPulse");
	}

	function saveSettings( event, rc, prc ){
		var csettings = {
			clientId=''
			,clientSecret=''
			,access_token_url=''
			,website_url=''
			,limitVal=''
			,offsetVal=''
			,post_task_url=''
			,access_token=''
			,token_type=''
			,expires_in=''
			,added_time=now()
		};
		for( var key in csettings ){
			if( structKeyExists( rc, key ) ){
				csettings[ key ] = rc[ key ];
			}
		}
		var args 	= { name="cb_cbSendPulse" };
		var setting = settingService.findWhere( criteria=args );
		if( isNull( setting ) ){
			setting = settingService.new( properties=args );
		}
		setting.setValue( serializeJSON( csettings ) );
		settingService.save( setting );
		settingService.flushSettingsCache();
		var dataRet = validateData(csettings);
        if(arrayLen(dataRet) EQ 0){
			if(csettings.ACCESS_TOKEN_URL NEQ ''){
				var data = notifyService.getAccessToken();
				if(data.success EQ true){
					cbMessageBox.info(data.msg);
				}else{
					cbMessageBox.error(data.msg);
				}
			}
		}else{
			cbMessageBox.setMessage(type='error',messageArray=dataRet);
		}
			CBHelper.moduleRelocate( "cbSendPulse", "home.index" );
	}

	function contactFormSettings(event,rc,prc) {
		event.paramValue( "msgTitle", "" ).paramValue( "webSite", "" ).paramValue( "ttlSettings", 86400 ).paramValue( "msgBody", "" ).paramValue( "webLink", "" );
		prc.xehNotifySubmit = CBHelper.buildModuleLink("cbSendPulse","home.saveNotify");
		prc.indexForm	= CBHelper.buildModuleLink("cbSendPulse","home.index");
		var args 	= { name="cb_cbSendPulse" };
		var setting = settingService.findWhere( criteria=args );
		if(!isNull(setting)){
			var pairs=deserializeJSON(setting.getValue());
			if(pairs.CLIENTID NEQ '' AND pairs.CLIENTSECRET NEQ '' AND pairs.WEBSITE_URL NEQ '' AND pairs.LIMITVAL NEQ '' AND pairs.OFFSETVAL NEQ ''){
				var data = notifyService.getWebSiteList();
				if(data.success EQ true){
					prc.arrayWebSite = data.data;
					event.setView( view="home/notify",module="cbSendPulse");
				}else{
					cbMessageBox.error(data.msg);
					CBHelper.moduleRelocate( "cbSendPulse", "home.index" );
				}
			}else{
				cbMessageBox.error('No data to show!');
				CBHelper.moduleRelocate( "cbSendPulse", "home.index" );
			}
		}
	}

	function saveNotify(event,rc,prc) {
		var args 	= { name="cb_cbSendPulse" };
		if(event.getHTTPMethod() EQ 'GET'){
			cbMessageBox.error('Only Allow Post Method');
			CBHelper.moduleRelocate( "cbSendPulse", "home.index" );
		}
		var setting = settingService.findWhere( criteria=args );
		if(!isNull(setting)){
			var dataRet = validateDataNotify(rc);
        	if(arrayLen(dataRet) EQ 0){
				var pairs=deserializeJSON(setting.getValue());
				if(pairs.POST_TASK_URL NEQ ''){
					var data = notifyService.sendPush(rc);
					if(data.success EQ true){
						cbMessageBox.info(data.msg);
					}else{
						cbMessageBox.error(data.msg);
					}
					
				}
				CBHelper.moduleRelocate( "cbSendPulse", "home.index" );
			}else{
				cbMessageBox.setMessage(type='error',messageArray=dataRet);
				contactFormSettings( argumentCollection=arguments );
			}
		}		
	}

	function validateDataNotify(data){
		var errorArr = arrayNew(1);
	    if(IsDefined('data.MSGTITLE') AND trim(data.MSGTITLE) EQ '') {
	    	arrayAppend(errorArr,"Message Title is required");
	    }else if(len(data.MSGTITLE) GT 50){
	    	arrayAppend(errorArr,"Message Title maximum length is 50.");
	    }
	    if(IsDefined('data.MSGBODY') AND trim(data.MSGBODY) EQ '') {
	    	arrayAppend(errorArr,"Notification Message is required");
	    }else if(len(data.MSGBODY) GT 125){
	    	arrayAppend(errorArr,"Notification Message maximum length is 125.");
	    }
	    if(IsDefined('data.WEBLINK') AND trim(data.WEBLINK) EQ '') {
	    	arrayAppend(errorArr,"Link for Notification is required");
	    }else if(IsDefined('data.WEBLINK') AND trim(data.WEBLINK) NEQ '' AND !IsValid( "URL", data.WEBLINK)) {
	    	arrayAppend(errorArr,"Link for Notification must be a valid URL");
	    }else if(len(data.WEBLINK) GT 100){
	    	arrayAppend(errorArr,"Link for Notification maximum length is 100.");
	    }
	    return errorArr;  
	}

	function validateData(data){
		var errorArr = arrayNew(1);
	    if(IsDefined('data.CLIENTID') AND trim(data.CLIENTID) EQ '') {
	    	arrayAppend(errorArr,"Client ID is required");
	    }else if(len(data.CLIENTID) GT 50){
	    	arrayAppend(errorArr,"Client ID maximum length is 50.");
	    }
	    if(IsDefined('data.CLIENTSECRET') AND trim(data.CLIENTSECRET) EQ '') {
	    	arrayAppend(errorArr,"Client secret id is required");
	    }else if(len(data.CLIENTSECRET) GT 50){
	    	arrayAppend(errorArr,"Client secret id maximum length is 50.");
	    }
	    if(IsDefined('data.ACCESS_TOKEN_URL') AND trim(data.ACCESS_TOKEN_URL) EQ '') {
	    	arrayAppend(errorArr,"API URL for Authorization is required");
	    }else if(IsDefined('data.ACCESS_TOKEN_URL') AND trim(data.ACCESS_TOKEN_URL) NEQ '' AND !IsValid( "URL", data.ACCESS_TOKEN_URL)) {
	    	arrayAppend(errorArr,"API URL for Authorization must be a valid URL");
	    }else if(len(data.ACCESS_TOKEN_URL) GT 100){
	    	arrayAppend(errorArr,"API URL for Authorization maximum length is 100.");
	    }
	    if(IsDefined('data.WEBSITE_URL') AND trim(data.WEBSITE_URL) EQ '') {
	    	arrayAppend(errorArr,"API URL for Retrieving a list of websites is required");
	    }else if(IsDefined('data.WEBSITE_URL') AND trim(data.WEBSITE_URL) NEQ '' AND !IsValid( "URL", data.WEBSITE_URL)) {
	    	arrayAppend(errorArr,"API URL for Retrieving a list of websites must be a valid URL");
	    }else if(len(data.WEBSITE_URL) GT 100){
	    	arrayAppend(errorArr,"API URL for Retrieving a list of websites maximum length is 100.");
	    }
	    if(IsDefined('data.POST_TASK_URL') AND trim(data.POST_TASK_URL) EQ '') {
	    	arrayAppend(errorArr,"API URL for creating a new Campaign is required");
	    }else if(IsDefined('data.POST_TASK_URL') AND trim(data.POST_TASK_URL) NEQ '' AND !IsValid( "URL", data.POST_TASK_URL)) {
	    	arrayAppend(errorArr,"API URL for creating a new Campaign must be a valid URL");
	    }else if(len(data.POST_TASK_URL) GT 100){
	    	arrayAppend(errorArr,"API URL for creating a new Campaign maximum length is 100.");
	    }
	    if(IsDefined('data.LIMITVAL') AND trim(data.LIMITVAL) EQ '') {
	    	arrayAppend(errorArr,"Maximum number of websites list is required");
	    }else if(data.LIMITVAL GT 50){
	    	arrayAppend(errorArr,"Maximum number of websites list maximum value is 50.");
	    }else if(data.LIMITVAL LT 1){
	    	arrayAppend(errorArr,"Maximum number of websites list minimum value is 1.");
	    }
	    if(IsDefined('data.OFFSETVAL') AND trim(data.OFFSETVAL) EQ '') {
	    	arrayAppend(errorArr,"Starting Point for websites list is required");
	    }else if(data.OFFSETVAL GT 5){
	    	arrayAppend(errorArr,"Starting Point for websites list maximum value is 5.");
	    }else if(data.OFFSETVAL LT 0){
	    	arrayAppend(errorArr,"Maximum number of websites list minimum value is 0.");
	    }
	    return errorArr;  
	}

}