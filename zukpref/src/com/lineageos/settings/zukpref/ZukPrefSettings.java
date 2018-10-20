/*
 *  LeEco Extras Settings Module
 *  Made by @andr68rus 2017
 */

package com.lineageos.settings.zukpref;

import android.app.ActionBar;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.Intent;
import android.os.Bundle;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceActivity;
import android.preference.PreferenceScreen;
import android.preference.SwitchPreference;
import android.preference.Preference.OnPreferenceClickListener;
import android.preference.PreferenceScreen;
import android.provider.Settings;
import android.view.Menu;
import android.view.MenuItem;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.Date;

import android.util.Log;
import android.os.SystemProperties;
import java.io.*;
import android.widget.Toast;
import android.preference.ListPreference;

import com.lineageos.settings.zukpref.R;

public class ZukPrefSettings extends PreferenceActivity implements OnPreferenceChangeListener {
	private static final boolean DEBUG = false;
	private static final String TAG = "ZukPref";

        private Preference mKcalPref;

    private Context mContext;
    private SharedPreferences mPreferences;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.zuk_settings);
        mKcalPref = findPreference("kcal");
                mKcalPref.setOnPreferenceClickListener(new Preference.OnPreferenceClickListener() {
                     @Override
                     public boolean onPreferenceClick(Preference preference) {
                         Intent intent = new Intent(getApplicationContext(), DisplayCalibration.class);
                         startActivity(intent);
                         return true;
                     }
                });
        mContext = getApplicationContext();
}

    private void setEnable(String key, boolean value) {
	if(value) {
 	      SystemProperties.set(key, "1");
    	} else {
    		SystemProperties.set(key, "0");
    	}
    	if (DEBUG) Log.d(TAG, key + " setting changed");
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            onBackPressed();
            return true;
        }
        return false;
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        final String key = preference.getKey();
        boolean value;
        String strvalue;
        if (DEBUG) Log.d(TAG, "Preference changed.");
    	value = (Boolean) newValue;
    	((SwitchPreference)preference).setChecked(value);
    	setEnable(key,value);
	return true;
    }
}
