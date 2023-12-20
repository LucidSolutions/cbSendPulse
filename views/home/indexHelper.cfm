<cfoutput>
<!--- Custom JS --->
<script>

document.addEventListener("DOMContentLoaded", function (event) {
   // pointers
   $settingForm     = $( "##setting-form" );
    // initialize validator and add a custom form submission logic
    $settingForm.validate();

	$("##ciBtn").click(function(){
        if ($("##clientId").attr("type")=="text") {
            $("##clientId").prop("type", "password")
            $("##ciBtn").text('Show');
        }else{
            $("##clientId").prop("type", "text")
            $("##ciBtn").text('Hide');
        }
    });
    $("##csBtn").click(function(){
        if ($("##clientSecret").attr("type")=="text") {
            
            $("##clientSecret").prop("type", "password")
            $("##csBtn").text('Show');
        }else{
            $("##clientSecret").prop("type", "text")
            $("##csBtn").text('Hide');
        }
    });
});

</script>
</cfoutput>
