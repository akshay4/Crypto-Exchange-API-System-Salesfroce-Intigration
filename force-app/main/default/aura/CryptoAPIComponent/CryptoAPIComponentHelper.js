({
	showToast : function(component, event, helper, messageLog) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": messageLog
        });
        toastEvent.fire();
    },
})