<cfoutput>
     #getModel( "messagebox@cbMessagebox" ).renderit()#
<div class="row">
    <div class="col-md-12" id="main-content-slot">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <i class="fa fa-bell"></i>
                    Send Pulse Web Push Notification - Settings
                </h3>
                <div class="actions">
                   
                    <p class="text-center">
                        <a type="button" class="btn btn-sm btn-primary" href="#prc.xehNotifyForm#"><i class="fa fa-bullhorn"></i>Send Notification</a>
                    </p>
                </div>
            </div>
            
            <div class="panel-body">
            <form id="setting-form" method="post" action="#prc.xehContactSetting#" role="form">
                    

                        <div class="panel-body">
                           
                            <div class="row">
                                <div class="col-md-12">
                                    <h3>API Information:</h3>
                                    <p>
                                        The necessary parameters to obtain the key can be found in the private account settings page found on the following URL <a href="https://login.sendpulse.com/settings" target="_blank">https://login.sendpulse.com/settings</a> in the API tab. - <a href="https://sendpulse.com/integrations/api" target="_blank">Click Here for API Details</a>  
                                        </p>
                                    <hr/>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label" for="clientId">*Client ID:</label>
                                        <div class="controls">
                                            <input type="password" name="clientId" required="required" size="50" class="form-control" id="clientId" value="#event.getValue('clientId')#" placeholder="Client ID">
                                            <button type="button" id="ciBtn" class="badge badge-info">Show</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">                
                                    <div class="form-group">
                                        <label class="control-label" for="clientSecret">*Client Secret:</label>
                                        <div class="controls">
                                            <input type="password" name="clientSecret" required="required" size="50" class="form-control" id="clientSecret" value="#event.getValue('clientSecret')#" placeholder="Client Secret">
                                            <button type="button" id="csBtn" class="badge badge-info">Show</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <h3>Other Information:</h3>
                                    <hr/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label" for="access_token_url">*API URL for Authorization</label>
                                        <a data-toggle="modal"><i class="fa fa-question-circle" title="" data-original-title="https://api.sendpulse.com/oauth/access_token, To get the key you have to send a POST request to referenced in each request to the API"></i></a>
                                        <div class="controls">
                                            <input id="access_token_url" type="url" name="access_token_url" class="form-control" placeholder="API URL for Authorization" value="#event.getValue('access_token_url')#" maxlength="100" required="required">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">                
                                    <div class="form-group">
                                        <label class="control-label" for="website_url">*API URL for Retrieving a list of websites</label>
                                        <a data-toggle="modal"><i class="fa fa-question-circle" title="" data-original-title="https://api.sendpulse.com/push/websites/?limit=10&offset=2, To retrieve a list of websites a GET request."></i></a>
                                        <div class="controls">
                                            <input id="website_url" type="url" name="website_url" class="form-control"  placeholder="API URL for Retrieving a list of websites" value="#event.getValue('website_url')#" maxlength="100" required="required">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="control-label" for="limitVal">*Maximum number of websites list</label>
                                        <a data-toggle="modal"><i class="fa fa-question-circle" title="" data-original-title="Total number of websites list"></i></a>
                                        <div class="controls">
                                            <input id="limitVal" type="number" name="limitVal" class="form-control" placeholder="Maximum number of websites list" value="#event.getValue('limitVal')#" max="50" min="1" required="required">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">                
                                    <div class="form-group">
                                        <label class="control-label" for="offsetVal">*Starting Point for websites list</label>
                                        <a data-toggle="modal"><i class="fa fa-question-circle" title="" data-original-title="Offset (stating the first record to display) for websites list"></i></a>
                                        <div class="controls">
                                            <input id="offsetVal" type="number" name="offsetVal" class="form-control"   placeholder="Starting Point for websites list" value="#event.getValue('offsetVal')#" max="5" min="0" required="required">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="control-label" for="post_task_url">*API URL for creating a new Campaign</label>
                                        <a data-toggle="modal"><i class="fa fa-question-circle" title="" data-original-title="https://api.sendpulse.com/push/tasks, To retrieve a list of sent push campaigns a GET request."></i></a>
                                        <div class="controls">
                                            <input id="post_task_url" type="url" name="post_task_url" class="form-control" placeholder="API URL for creating a new Campaign" value="#event.getValue('post_task_url')#" maxlength="100" required="required">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-actions">
                                 <input type="submit" class="btn btn-danger" value="Save" id="submitBtn">
                            </div>    
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</cfoutput>
