//
//  ANSIAttribute.swift
//
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

public enum ANSIAttr: UInt8 {
  /* text styling */
  case normal         = 0
  case bold           = 1
  case dim            = 2
  case italic         = 3
  case underline      = 4
  case blink          = 5
  case overline       = 6
  case inverse        = 7
  case hidden         = 8
  case strike         = 9
  case noBold         = 21
  case noDim          = 22
  case noItalic       = 23
  case noUnderline    = 24
  case noBlink        = 25
  case noOverline     = 26
  case noInverse      = 27
  case noHidden       = 28
  case noStrike       = 29
  /* foreground text coloring */
  case black          = 30
  case red            = 31
  case green          = 32
  case brown          = 33
  case blue           = 34
  case magenta        = 35
  case cyan           = 36
  case gray           = 37
  case fore256Color   = 38
  case `default`      = 39
  case darkGray       = 90
  case lightRed       = 91
  case lightGreen     = 92
  case yellow         = 93
  case lightBlue      = 94
  case lightMagenta   = 95
  case lightCyan      = 96
  case white          = 97
  /* background text coloring */
  case onBlack        = 40
  case onRed          = 41
  case onGreen        = 42
  case onBrown        = 43
  case onBlue         = 44
  case onMagenta      = 45
  case onCyan         = 46
  case onGray         = 47
  case back256Color   = 48
  case onDefault      = 49
  case onDarkGray     = 100
  case onLightRed     = 101
  case onLightGreen   = 102
  case onYellow       = 103
  case onLightBlue    = 104
  case onLightMagenta = 105
  case onLightCyan    = 106
  case onWhite        = 107
}
