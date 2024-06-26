/*
 * Copyright (C) 2020 The Android Open Source Project
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
 * limitations under the License.
 */

package android.hardware.security.sharedsecret;
import android.hardware.security.sharedsecret.SharedSecretParameters;

/**
 * Shared Secret definition.
 *
 * An ISharedSecret enables any service that implements this interface to establish a shared secret
 * with one or more other services such as ISecureClock, TEE IKeymintDevice, StrongBox
 * IKeymintDevice, etc. The shared secret is a 256-bit HMAC key and it is further used to generate
 * secure tokens with integrity protection. There are three steps to establish a shared secret
 * between the collaborating services:
 *
 * Step 1: During Android startup the system calls each service that implements this interface to
 * get the shared secret parameters. This is done using getSharedSecretParameters method defined
 * below.
 * Step 2: The system lexicographically sorts the shared secret parameters received from each
 * service and then sends these sorted parameter list to each service in a computeSharedSecret
 * method defined below. The services individually computes the shared secret and returns back
 * the 32 byte sharing check hash value generated by using the computed shared secret.
 * Step 3: The system collects sharing check hash values from each service and evaluates them. If
 * they are all equal, then the shared secret generation is considered to be successful else it is
 * considered to have failed.
 * @hide
 */
@VintfStability
interface ISharedSecret {
    /**
     * String used as label in the shared key derivation. See computeSharedSecret below.
     */
    const String KEY_AGREEMENT_LABEL = "KeymasterSharedMac";

    /**
     * String used as context in the computation of the sharingCheck. See computeSharedSecret
     * below.
     */
    const String KEY_CHECK_LABEL = "Keymaster HMAC Verification";

    /**
     * This method is the first step in the process for agreeing on a shared key.  It is called by
     * Android during startup.  The system calls it on each of the HAL instances and collects the
     * results in preparation for the second step.
     *
     * @return The SharedSecretParameters to use.  As specified in the SharedSecretParameters
     *         documentation, the seed must contain the same value in every invocation
     *         of the method on a given device, and the nonce must return the same value for every
     *         invocation during a boot session.
     */
    SharedSecretParameters getSharedSecretParameters();

    /**
     * This method is the second and final step in the process for agreeing on a shared key.  It is
     * called by Android during startup.  The system calls it on each of the HAL instances, and
     * sends to it all of the SharedSecretParameters returned by all HAL instances.
     *
     * This method computes the shared 32-byte HMAC key ``H'' as follows (all HAL instances perform
     * the same computation to arrive at the same result):
     *
     *     H = CKDF(key = K,
     *              context = P1 || P2 || ... || Pn,
     *              label = KEY_AGREEMENT_LABEL)
     *
     * where:
     *
     *     ``CKDF'' is the standard AES-CMAC KDF from NIST SP 800-108 in counter mode (see Section
     *           5.1 of the referenced publication).  ``key'', ``context'', and ``label'' are
     *           defined in the standard.  The counter is prefixed and length L appended, as shown
     *           in the construction on page 12 of the standard.  The label string is UTF-8 encoded.
     *
     *     ``K'' is a pre-established shared secret.  The mechanism for establishing this shared
     *           secret is implementation-defined.  Any method of securely establishing K that
     *           ensures that an attacker cannot obtain or derive its value is acceptable.
     *
     *     ``||'' represents concatenation.
     *
     *     ``Pi'' is the i'th SharedSecretParameters value in the params vector. Encoding of an
     *           SharedSecretParameters is the concatenation of its two fields, i.e. seed || nonce.
     *
     * Note that the label "KeymasterSharedMac" is the 18-byte UTF-8 encoding of the string.
     *
     * @param params is an array of SharedSecretParameters The lexicographically sorted
     * SharedSecretParameters data returned by all HAL instances when getSharedSecretParameters
     * was called.
     *
     * @return sharingCheck A 32-byte value used to verify that all the HAL instances have
     *         computed the same shared HMAC key.  The sharingCheck value is computed as follows:
     *
     *             sharingCheck = HMAC(H, KEY_CHECK_LABEL)
     *
     *         The string is UTF-8 encoded, 27 bytes in length.  If the returned values of all
     *         HAL instances don't match, clients must assume that HMAC agreement
     *         failed.
     */
    byte[] computeSharedSecret(in SharedSecretParameters[] params);
}
