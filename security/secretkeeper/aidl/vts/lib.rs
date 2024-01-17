/*
 * Copyright (C) 2023 The Android Open Source Project
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

//! Test helper functions.

pub mod dice_sample;

// Constants for DICE map keys.

/// Map key for authority hash.
pub const AUTHORITY_HASH: i64 = -4670549;
/// Map key for config descriptor.
pub const CONFIG_DESC: i64 = -4670548;
/// Map key for component name.
pub const COMPONENT_NAME: i64 = -70002;
/// Map key for component version.
pub const COMPONENT_VERSION: i64 = -70003;
/// Map key for security version.
pub const SECURITY_VERSION: i64 = -70005;
/// Map key for mode.
pub const MODE: i64 = -4670551;
