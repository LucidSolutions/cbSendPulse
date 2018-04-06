component {

	// Module Properties
	this.title 				= "Send Pulse";
	this.author 			= "Lucid Outsourcing Solutions";
	this.webURL 			= "https://lucidsolutions.in/";
	this.description 		= "This is an awesome Send Pulse Web Push Notification module";
	this.version			= "1.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbSendPulse";

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			clientId='',
			clientSecret=''
			,access_token_url='https://api.sendpulse.com/oauth/access_token'
			,website_url='https://api.sendpulse.com/push/websites'
			,limitVal='10'
			,offsetVal='0'
			,post_task_url='https://api.sendpulse.com/push/tasks'
		};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="home",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Binder Mappings
		// binder.map( "Alias" ).to( "#moduleMapping#.model.MyService" );
		binder.map("notifyService@cbSendPulse").to("#moduleMapping#.models.notifyService");


	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Let's add ourselves to the main menu in the Modules section
		var menuService = controller.getWireBox().getInstance( "AdminMenuService@cb" );
		// Add Menu Contribution
		menuService.addSubMenu(topMenu=menuService.MODULES,name="cbSendPulse",label="Send Pulse",href="#menuService.buildModuleLink('cbSendPulse','home')#" );
	}

	/**
	* Fired when the module is activated by ContentBox
	*/
	function onActivate(){
		var settingService = controller.getWireBox().getInstance("SettingService@cb");
		// store default settings
		var findArgs = {name="cb_cbSendPulse"};
		var setting = settingService.findWhere(criteria=findArgs);
		if( isNull(setting) ){
			var args = {name="cb_cbSendPulse", value=serializeJSON( settings )};
			var cFormSettings = settingService.new(properties=args);
			settingService.save( cFormSettings );
		}

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		// Let's remove ourselves to the main menu in the Modules section
		var menuService = controller.getWireBox().getInstance( "AdminMenuService@cb" );
		// Remove Menu Contribution
		menuService.removeSubMenu(topMenu=menuService.MODULES,name="cbSendPulse" );
	}

	/**
	* Fired when the module is deactivated by ContentBox
	*/
	function onDeactivate(){
		var settingService = controller.getWireBox().getInstance("SettingService@cb");
		var args = {name="cb_cbSendPulse"};
		var setting = settingService.findWhere(criteria=args);
		if( !isNull(setting) ){
			settingService.delete( setting );
		}

	}

}