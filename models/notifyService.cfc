component singleton{

	property name="settingService"		inject="id:settingService@cb";

	function init(){
		variables.token  = '';
		variables.errorCodeList={
   			'8':'Empty data',
			'10':'Empty sender email address',
			'11':'Can’t find recipients addresses',
			'13':'Empty email message content field',
			'14':'Can’t find email address with a specified ID',
			'17':'Can’t find email address',
			'19':'Email address already exists',
			'20':'You are not allowed to use free mail services',
			'21':'Can’t find email address on activation',
			'97':'Invalid email address type. You are not allowed to use free mail services.',
			'201':'Empty mailing list name',
			'203':'This mailing list name already exists',
			'213':'Mailing list not found',
			'303':'Can’t find email addresses in the mailing list',
			'400':'Can’t find such SMTP user. Please, create SMTP service account.',
			'502':'Can’t find email address',
			'602':'Can’t find campaign. Probably, it has already been sent.',
			'701':'Empty sender name or email address',
			'703':'Can’t find mailing list',
			'704':'Can’t find sender',
			'707':'Not enough funds on your account balance',
			'711':'You should wait for 15 minutes before creating new campaign on the same mailing list.',
			'720':'Empty subject field',
			'721':'Empty email message content field',
			'722':'Can’t find mailing list ID',
			'799':'Wrong send date. It must be in such format: Y-m-d H:i:s and can not be less than the current date',
			'800':'Invalid operation',
			'802':'Can’t find campaign',
			'901':'Empty sender name field',
			'902':'Chosen email address is already used',
			'903':'Empty sender email address field',
			'904':'Email address is blacklisted',
			'905':'You have reached the limit of available sender addresses',
			'906':'Email address syntax error',
			'1101':'Empty email address field',
			'1003':'The specified sender doesn’t exist',
			'1004':'Activation code was sent. You should wait for 15 minutes before the next try.',
			'1005':'Confirmation sending error',
			'1104':'Can’t find activation code'
   		};
		return this;
	}



	function getAccessToken(){
		var args 	= { name="cb_cbSendPulse" };
		var setting = settingService.findWhere( criteria=args );
		var pairs = deserializeJSON(setting.getValue());

		var resJson = {'success':false,'data':{},'msg':''};

		cfhttp(method="post", url="#pairs.ACCESS_TOKEN_URL#", result="resultAccess") {
			cfhttpparam(name="grant_type", type="formfield", value="client_credentials");
			cfhttpparam(name="client_id", type="formfield", value="#pairs.CLIENTID#");
			cfhttpparam(name="client_secret", type="formfield", value="#pairs.CLIENTSECRET#");
		}
		if(isJson(resultAccess.filecontent)){
			var tempData = deserializeJSON(resultAccess.filecontent);
		}

		if(resultAccess.errordetail EQ '' AND resultAccess.status_code EQ 200){
			resJson['success'] = true;
			resJson['data'] = tempData;
			resJson['msg'] = 'Details Saved & Updated!';
		}else{ 
			if(isDefined("tempData")){
				if(isStruct(tempData) AND structKeyExists(tempData,"message") AND tempData.message EQ 'Not Found'){
					resJson['msg'] = 'API URL '&tempData.message;
				}else{
					if(structKeyExists(tempData,"error_code") AND structKeyExists(variables.errorCodeList,tempData.error_code)){
						resJson['msg'] = tempData.message&'<br/>'&variables.errorCodeList[tempData.error_code];
					}else{
						resJson['msg'] = tempData.message;
					}
				}
			}else{
				resJson['msg'] = 'Incorrect API, Correct is:- '&resultAccess.responseheader.Location;
			}
		}	
		return resJson;		
	}


	function getWebSiteList(){

		var args 	= { name="cb_cbSendPulse" };
		var setting = settingService.findWhere( criteria=args );
		var pairs=deserializeJSON(setting.getValue());
		var resJson = {'success':false,'data':{},'msg':''};
		var acc = getAccessToken();
		if(acc.success EQ true){
			cfhttp(method="get", url="#pairs.WEBSITE_URL#/?limit=#pairs.LIMITVAL#&offset=#pairs.OFFSETVAL#", result="resultWebSite") {
				cfhttpparam(type="header" name="Authorization", value="#acc.data.token_type# #acc.data.access_token#");
			}

			if(resultWebSite.errordetail EQ '' AND resultWebSite.status_code EQ 200){
				resJson['success'] = true;
				resJson['data'] = deserializeJSON(resultWebSite.filecontent);
				
			}else{
				if(isJson(resultWebSite.filecontent)){
					if(structKeyExists(deserializeJSON(resultWebSite.filecontent),"message")){
						resJson['msg'] = 'API URL '&deserializeJSON(resultWebSite.filecontent).message;
					}
					if(structKeyExists(deserializeJSON(resultWebSite.filecontent),"error_description")){
						resJson['msg'] = resJson['msg']&' API URL '&deserializeJSON(resultWebSite.filecontent).error_description;
					}
				}else{
					resJson['msg'] = 'Incorrect API, Correct is:- '&resultWebSite.responseheader.Location;
				}
			}
			return resJson;

		}else{
			return acc;
		}	

	}

	function sendPush(rc){
		var args 	= { name="cb_cbSendPulse" };
		var setting = settingService.findWhere( criteria=args );
		var pairs=deserializeJSON(setting.getValue());
		var resJson = {'success':false,'data':{},'msg':''};
		var acc = getAccessToken();

		if(acc.success EQ true){
				cfhttp(method="post", url="#pairs.POST_TASK_URL#", result="sendNotify") {
				    cfhttpparam(type="header" name="Authorization", value="#acc.data.token_type# #acc.data.access_token#");
					cfhttpparam(name="title", type="formfield", value="#rc.msgTitle#");
					cfhttpparam(name="body", type="formfield", value="#rc.msgBody#");
					cfhttpparam(name="website_id", type="formfield", value="#rc.webSite#");
					cfhttpparam(name="ttl", type="formfield", value="#rc.ttlSettings#");
					cfhttpparam(name="link", type="formfield", value="#rc.webLink#");
				}
				if(isJson(sendNotify.filecontent)){
					var tempData = deserializeJSON(sendNotify.filecontent);
				}
				if(sendNotify.errordetail EQ '' AND sendNotify.status_code EQ 200){
					resJson['success'] = true;
					resJson['msg'] = "Notification Sent!!";
				}else{
					if(isDefined('tempData')){
						if(tempData.message EQ 'Not Found'){
							resJson['msg'] ='API URL '&tempData.message;
						}else{
							if(structKeyExists(tempData,"error_code") AND structKeyExists(variables.errorCodeList,tempData.error_code)){
								resJson['msg'] =tempData.message&'<br/>'&variables.errorCodeList[tempData.error_code];
							}else{
								resJson['msg'] =tempData.message;
							}							
						}
					}else{
						resJson['msg'] = 'Incorrect API, Correct is:- '&sendNotify.responseheader.Location;
					}
				}
				return resJson;
		}else{
			return acc;
		}	

	}
}	