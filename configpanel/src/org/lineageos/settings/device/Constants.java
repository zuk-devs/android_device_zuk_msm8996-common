/*
 * Copyright (C) 2016 The CyanogenMod Project
 *           (C) 2017-2018 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.lineageos.settings.device;

import org.lineageos.internal.util.FileUtils;

import java.util.HashMap;
import java.util.Map;

public class Constants {

    // Category keys
    public static final String CATEGORY_FP = "fp_key";

    // Preference keys
    public static final String FP_POCKETMODE_KEY = "fp_pocketmode";
    public static final String FP_WAKEUP_KEY = "fp_wakeup";

    // Nodes
    public static final String FP_WAKEUP_NODE = "/sys/devices/soc/soc:fpc1020/enable_wakeup";
    // Intents
    public static final String CUST_INTENT = "org.lineageos.settings.device.CUST_UPDATE";
    public static final String CUST_INTENT_EXTRA = "pocketmode_service";

    // Holds <preference_key> -> <proc_node> mapping
    public static final Map<String, String> sBooleanNodePreferenceMap = new HashMap<>();
    public static final Map<String, String> sStringNodePreferenceMap = new HashMap<>();

    // Holds <preference_key> -> <default_values> mapping
    public static final Map<String, Object> sNodeDefaultMap = new HashMap<>();

    // Holds <preference_key> -> <user_set_values> mapping
    public static final Map<String, Object[]> sNodeUserSetValuesMap = new HashMap<>();

    // Holds <preference_key> -> <dependency_check> mapping
    public static final Map<String, String[]> sNodeDependencyMap = new HashMap<>();

    public static final String[] sButtonPrefKeys = {
        FP_WAKEUP_KEY
    };

    static {
        sBooleanNodePreferenceMap.put(FP_WAKEUP_KEY, FP_WAKEUP_NODE);

        sNodeDefaultMap.put(FP_WAKEUP_KEY, true);
    }
}
