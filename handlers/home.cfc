component {
	property name="notifyService"		inject="id:notifyService@cbSendPulse";
	property name="settingService"		inject="id:settingService@cb";
   	property name="CBHelper"			inject="id:CBHelper@cb";
   	property name="cbMessagebox" 	inject="messagebox@cbmessagebox";
   	
   	function preHandler(event,rc,prc){
   		
   	}
	function index(event,rc,prc) {
		prc.xehContactSetting	= CBHelper.buildModuleLink("cbSendPulse","home.saveSettings");
		prc.xehNotifyForm = CBHelper.buildModuleLink("cbSendPulse","home.contactFormSettings");
		prc.xehNotifySubmit = CBHelper.buildModuleLink("cbSendPulse","home.saveNotify");
		event.paramValue( "clientId", "" );
		event.paramValue( "clientSecret", "" );
		event.paramValue( "access_token_url", "" );
		event.paramValue( "website_url", "" );
		event.paramValue( "limitVal", "" );
		event.paramValue( "offsetVal", "" );
		event.paramValue( "post_task_url", "" );

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
		// Get settings
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
		// iterate over settings
		for( var key in csettings ){
			// save only sent in setting keys
			if( structKeyExists( rc, key ) ){
				csettings[ key ] = rc[ key ];
			}
		}
		// Save settings
		var args 	= { name="cb_cbSendPulse" };
		var setting = settingService.findWhere( criteria=args );
		if( isNull( setting ) ){
			setting = settingService.new( properties=args );
		}
		setting.setValue( serializeJSON( csettings ) );
		settingService.save( setting );
		settingService.flushSettingsCache();
		// Messagebox
		if(csettings.ACCESS_TOKEN_URL NEQ ''){
			var data = notifyService.getAccessToken();
			if(data.success EQ true){
				cbMessageBox.info(data.msg);
			}else{
				cbMessageBox.error(data.msg);
			}
		}
		CBHelper.setNextModuleEvent( "cbSendPulse", "home.index" );
	}

	function contactFormSettings(event,rc,prc) {
		prc.xehNotifySubmit = CBHelper.buildModuleLink("cbSendPulse","home.saveNotify");
		prc.indexForm	= CBHelper.buildModuleLink("cbSendPulse","home.index");
		var args 	= { name="cb_cbSendPulse" };
		var setting = settingService.findWhere( criteria=args );
		if(!isNull(setting)){
			var pairs=deserializeJSON(setting.getValue());
			if(pairs.WEBSITE_URL NEQ '' AND pairs.LIMITVAL NEQ '' AND pairs.OFFSETVAL NEQ ''){
				var data = notifyService.getWebSiteList();
				if(data.success EQ true){
					prc.arrayWebSite = data.data;
					event.setView( view="home/notify",module="cbSendPulse");
				}else{
					cbMessageBox.error(data.msg);
					CBHelper.setNextModuleEvent( "cbSendPulse", "home.index" );
				}
			}
		}
	}

	function saveNotify(event,rc,prc) {
		var args 	= { name="cb_cbSendPulse" };
		var setting = settingService.findWhere( criteria=args );
		if(!isNull(setting)){
			var pairs=deserializeJSON(setting.getValue());
			if(pairs.POST_TASK_URL NEQ ''){
				var data = notifyService.sendPush(rc);
				if(data.success EQ true){
					cbMessageBox.info(data.msg);
				}else{
					cbMessageBox.error(data.msg);
					CBHelper.setNextModuleEvent( "cbSendPulse", "home.index" );
				}
			}
		}
		CBHelper.setNextModuleEvent( "cbSendPulse", "home.index" );
	}

}