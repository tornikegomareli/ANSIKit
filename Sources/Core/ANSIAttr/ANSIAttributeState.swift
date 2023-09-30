//  ANSIAttributeState.swift
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

/// Indicates whether any ANSI foreground or background color attributes are currently open.
/// - Note: An "open" state means that a color attribute has been set but not yet reset to default.
internal var isOpenedColor = false

/// Indicates whether any ANSI text style attributes are currently open.
/// - Note: An "open" state means that a style attribute has been set but not yet reset to default.
internal var isOpenedStyle = false
