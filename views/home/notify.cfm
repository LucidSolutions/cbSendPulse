<cfoutput>
 #getModel( "messagebox@cbMessagebox" ).renderit()#
<div class="row">
    <div class="col-md-12" id="main-content-slot">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <i class="fa fa-bell"></i>
                    Send Web Push Notification
                </h3>
                <div class="actions">
                    <p class="text-center">
                        <a type="button" class="btn btn-default btn-sm" value="Cancle" href="#prc.indexForm#">
                            <i class="fa fa-reply"></i> Cancel
                        </a>
                    </p>
                </div>
            </div>
            <div class="panel-body">
                <form id="notify-form" method="post" action="#prc.xehNotifySubmit#" role="form">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="control-label" for="msgTitle">*Message Title</label>
                                <div class="controls">
                                    <input id="msgTitle" type="text" name="msgTitle" class="form-control" placeholder="Message Title up to 50 characters" required="required" maxlength="50" value="#event.getValue('msgTitle')#">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="control-label" for="webSite">*Website</label>
                                <select class="form-control" id="webSite" name="webSite" required="required">
                                    <cfloop array="#prc.arrayWebSite#" index="i">
                                        <option value="#trim(i.id)#" <cfif event.getValue('webSite') EQ trim(i.id)>selected</cfif>
                                            >#trim(i.url)#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-2">                
                            <div class="form-group">
                                <label for="ttlSettings">Push lifetime</label>
                                <select id="ttlSettings" name="ttlSettings" class="form-control input-sm">
                                    <option value="900" <cfif event.getValue('ttlSettings') EQ 900>selected</cfif>>15 minutes</option>
                                    <option value="1800" <cfif event.getValue('ttlSettings') EQ 1800>selected</cfif>>30 minutes</option>
                                    <option value="3600" <cfif event.getValue('ttlSettings') EQ 3600>selected</cfif>>1 hour</option>
                                    <option value="21600" <cfif event.getValue('ttlSettings') EQ 21600>selected</cfif>>6 hours</option>
                                    <option value="86400" <cfif event.getValue('ttlSettings') EQ 86400>selected</cfif>>24 hours</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">                
                            <div class="form-group">
                                <label class="control-label" for="webLink">*Link for Notification</label>
                                <a data-toggle="modal"><i class="fa fa-question-circle" title="" data-original-title="Navigation link; if it’s not specified, the website URL will be used"></i></a>
                                <div class="controls">
                                    <input id="webLink" type="url" name="webLink" class="form-control" placeholder="Link for Notification" required="required" maxlength="100"  value="#event.getValue('webLink')#">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">                
                            <div class="form-group">
                                <label class="control-label" for="msgBody">*Notification Message</label>
                                <div class="controls">
                                    <textarea id="msgBody" name="msgBody" class="form-control" placeholder="Notification Message up to 125 characters" rows="4" required="required" class="form-control" maxlength="125">#event.getValue('msgBody')#</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">            
                        <div class="col-md-12">
                            <input type="submit" class="btn btn-success btn-send" value="Submit">
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</cfoutput>