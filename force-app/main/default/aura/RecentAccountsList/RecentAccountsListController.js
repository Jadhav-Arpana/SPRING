({
    doInit: function(component, event, helper) {
        var action = component.get("c.getRecentlyCreatedAccounts");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accountList", response.getReturnValue());
            } else {
                console.log("Error: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})
