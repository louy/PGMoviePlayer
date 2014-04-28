package com.l0uy.phonegap;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import android.content.Intent;
import android.net.Uri;
import android.util.Log;


public class PGMoviePlayer extends CordovaPlugin {
	private static final String LOG_TAG = "PGMoviePlayer";
	
    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    	super.initialize(cordova, webView);
    }
    
    @Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		Log.d(LOG_TAG, "execute: " + action);
    	if( action.equals("play") ) {
    		String MovieLink = args.optString(0);
    		
    		Intent viewMediaIntent = new Intent();   
    		viewMediaIntent.setAction(android.content.Intent.ACTION_VIEW);
    		viewMediaIntent.setDataAndType(Uri.parse(MovieLink), "video/*");
    		viewMediaIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
    		
	        try {
	        	cordova.getActivity().startActivity(viewMediaIntent);
	        } catch (Exception e) {
	        	Log.d(LOG_TAG, "error: " + e.getMessage());
	            return false;
	        }

    		return true;
    	} else {
    		return false;
    	}
	}
}
