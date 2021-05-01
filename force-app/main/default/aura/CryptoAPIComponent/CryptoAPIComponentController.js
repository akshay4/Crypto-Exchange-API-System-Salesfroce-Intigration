({
    doInit : function(component,event,helper) {
        var action = component.get("c.getInitData");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("From server: ",JSON.stringify(response.getReturnValue()));
                let result = response.getReturnValue();
                component.set('v.cryptoList', result['Crypto']);
                component.set('v.currencyList', result['Currency']);
            }
            else if (state === "INCOMPLETE") {
                alert("Continuation action is INCOMPLETE");
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
    
    getCurrentRate : function(component,event,helper){
        let currentCrypto = component.get("v.selectedCrypto");
        let currentCurrency = component.get("v.selectedCurrency");
        
        if(currentCurrency != undefined && currentCurrency != null && currentCrypto != undefined && currentCrypto != null
           && currentCrypto.length != 0 && currentCurrency.length != 0){
            var action = component.get("c.getExchangeRates");
            action.setParams({
                "assetsType":component.get("v.selectedCrypto"),
                "currencyType":component.get("v.selectedCurrency")
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("From server: ",JSON.stringify(response.getReturnValue()));
                    let result = response.getReturnValue();
                    component.set('v.currentRate', result);
                }
                else if (state === "INCOMPLETE") {
                    alert("Continuation action is INCOMPLETE");
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
        else{
            helper.showToast(component, event, helper, 'Please Select values from the list.');
        }
    },
    
    moniterCoin : function(component,event,helper){
        let currentCrypto = component.get("v.selectedCrypto");
        let currentCurrency = component.get("v.selectedCurrency");
        let rate = component.get("v.currentRate");
        
        var cryptoList = component.get('v.cryptoList');
        var currencyList = component.get('v.currencyList');
        
        for(let key in cryptoList){
            if(cryptoList[key].assetName == currentCrypto){
                currentCrypto = cryptoList[key].assetId;
                break;
            }
        }
        
        for(let key in currencyList){
            if(currencyList[key].assetName == currentCurrency){
                currentCurrency = currencyList[key].assetId;
                break;
            }
        }
        
        if(currentCurrency != undefined && currentCurrency != null && currentCrypto != undefined && currentCrypto != null
           && currentCrypto.length != 0 && currentCurrency.length != 0 && rate != undefined && rate != null && rate.length != 0 ){
            
            var action = component.get("c.moniterCoinUpdateRecord");
            action.setParams({
                "recordId": component.get("v.recordId"),
                "assetsType":currentCrypto,
                "currencyType":currentCurrency,
                "rate":component.get("v.currentRate")
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.showToast(component, event, helper, 'Success. Record Updated.');
                    $A.get('e.force:refreshView').fire();
                }
                else if (state === "INCOMPLETE") {
                    alert("Continuation action is INCOMPLETE");
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
        else{
            helper.showToast(component, event, helper, 'Somthing went wrong. Please check youre exchange rates.');
        }
    },
    
})