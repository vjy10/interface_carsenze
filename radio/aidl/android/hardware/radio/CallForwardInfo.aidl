/*
 * Copyright (C) 2021 The Android Open Source Project
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

package android.hardware.radio;

import android.hardware.radio.CallForwardInfoStatus;

/**
 * See also com.android.internal.telephony.gsm.CallForwardInfo
 */
@VintfStability
parcelable CallForwardInfo {
    /**
     * For queryCallForwardStatus() status is DISABLE (Not used by vendor code currently)
     * For setCallForward() status must be DISABLE, ENABLE, INTERROGATE, REGISTRATION, ERASURE
     */
    CallForwardInfoStatus status;
    /**
     * From TS 27.007 7.11 "reason"
     */
    int reason;
    /**
     * From TS 27.007 +CCFC/+CLCK "class". See table for Android mapping from MMI service code.
     * 0 means user doesn't input class.
     */
    int serviceClass;
    /**
     * From TS 27.007 7.11 "type"
     */
    int toa;
    /**
     * From TS 27.007 7.11 "number"
     */
    String number;
    int timeSeconds;
}