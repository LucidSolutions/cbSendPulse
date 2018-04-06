<cfoutput>
<form id="notify-form" method="post" action="#prc.xehNotifySubmit#" role="form">
    <input type="hidden" name="_returnTo" value="#cb.linkSelf()#">
    #getModel( "messagebox@cbMessagebox" ).renderit()#
    <div class="panel panel-default">
        <div class="panel-heading">
            <h3><i class="fa fa-bell fa-lg"></i> Send Pulse Push Notification</h3>
        </div>
        <div class="panel-body">
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="control-label" for="msgTitle">Message Title</label>
                        <div class="controls">
                            <input id="msgTitle" type="text" name="msgTitle" class="form-control" placeholder="Message Title up to 50 characters" required="required" maxlength="50">
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label class="control-label" for="webSite">Website</label>
                        <select class="form-control" id="webSite" name="webSite" required="required">
                            <cfloop array="#prc.arrayWebSite#" item="i">
                                <option value="#trim(i.id)#">#trim(i.url)#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="col-md-2">                
                    <div class="form-group">
                        <label for="ttlSettings">Push lifetime</label>
                        <select id="ttlSettings" name="ttlSettings" class="form-control input-sm">
                            <option value="900">15 minutes</option>
                            <option value="1800">30 minutes</option>
                            <option value="3600">1 hour</option>
                            <option value="21600">6 hours</option>
                            <option value="86400" selected="">24 hours</option>
                        </select>
                    </div>
                </div>
            </div>
             <div class="row">
                <div class="col-md-12">                
                    <div class="form-group">
                        <label class="control-label" for="webLink">Link for Notification</label>
                        <a data-toggle="modal"><i class="fa fa-question-circle" title="" data-original-title="Navigation link; if it’s not specified, the website URL will be used"></i></a>
                        <div class="controls">
                            <input id="webLink" type="url" name="webLink" class="form-control" placeholder="Link for Notification" required="required" maxlength="100">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">                
                    <div class="form-group">
                        <label class="control-label" for="msgBody">Notification Message</label>
                        <div class="controls">
                            <textarea id="msgBody" name="msgBody" class="form-control" placeholder="Notification Message up to 125 characters" rows="4" required="required" class="form-control" maxlength="125"></textarea>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">            
                <div class="col-md-12">
                    <input type="submit" class="btn btn-success btn-send" value="Submit">
                    <a type="button" class="btn btn-info btn-send" value="Cancle" href="#prc.indexForm#">Cancel</a>
                </div>
            </div>
        </div>
    </div>
</form>
</cfoutput>