package com.smithimage.cordova.googleplus;

/**
 * Created with IntelliJ IDEA.
 * User: robert
 * Date: 01/02/14
 * Time: 14:06 PM
 * To change this template use File | Settings | File Templates.
 */

import android.accounts.AccountManager;
import android.app.Activity;
import android.content.Intent;
import com.google.android.gms.auth.GoogleAuthException;
import com.google.android.gms.auth.GoogleAuthUtil;
import com.google.android.gms.auth.UserRecoverableAuthException;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import java.io.IOException;

public class GooglePlus extends CordovaPlugin {

    private final int AUTH = 0;
    private CallbackContext callbackContext;
    private String clientId;
    private String scopes = "";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if("initialize".equals(action))
            initialize(args);

        if("authenticate".equals(action))
            authenticate(callbackContext);

        return true;
    }

    private void initialize(JSONArray args) throws JSONException {
        if(args.length() > 0)
            this.clientId = args.getString(0);
        if(args.length() > 1){
            for(int i = 0; i < args.getJSONArray(1).length(); i++){
                this.scopes += args.getJSONArray(1).getString(i) + " ";
            }
            this.scopes = this.scopes.trim();
        }
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, final Intent intent) {
        if (requestCode == AUTH && resultCode == Activity.RESULT_OK) {
            cordova.getThreadPool().execute(new getTokenRunnable(intent));
        }
    }

    private void authenticate(CallbackContext callbackContext){
        this.callbackContext = callbackContext;
        cordova.getActivity().runOnUiThread(new showAccountsRunnable());
    }

    private class getTokenRunnable implements Runnable {
        private final Intent intent;

        public getTokenRunnable(Intent intent) {
            this.intent = intent;
        }

        public void run() {
            String accountName = intent.getStringExtra(AccountManager.KEY_ACCOUNT_NAME);
            try {
                String token = GoogleAuthUtil.getToken(
                        cordova.getActivity().getApplicationContext(), accountName, "oauth2:" + scopes);
                callbackContext.success(token);
            }catch (UserRecoverableAuthException e){
                cordova.getActivity().startActivityForResult(e.getIntent(), AUTH);
            }
            catch (IOException e) {
                e.printStackTrace();
                callbackContext.error("Failed to retrieve authtoken");
            } catch (GoogleAuthException e) {
                e.printStackTrace();
                callbackContext.error("Failed to retrieve authtoken");
            } catch (Exception e){
                e.printStackTrace();
                callbackContext.error("Failed to retrieve authtoken");
            }
        }
    }

    private class showAccountsRunnable implements Runnable {
        public void run() {
            Intent intent = AccountManager.newChooseAccountIntent(
                    null, null, new String[]{"com.google"}, true, null, null, null, null);
            cordova.setActivityResultCallback(GooglePlus.this);
            cordova.getActivity().startActivityForResult(intent, AUTH);
        }
    }
}
