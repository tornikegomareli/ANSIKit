//
//  ANSIAttributeUtilities.swift
//
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

public func setStyle(_ style: ANSIAttr = .normal) {
  guard 1...9 ~= style.rawValue || 21...29 ~= style.rawValue else {
    return
  }
  
  write(CSI+"\(style.rawValue)m")
  isOpenedStyle = true
}

public func isStyle(_ style: UInt8) -> Bool {
  return (style > 0 && style < 10) ||
  (style > 20 && style < 30)
}

public func setColor(fore: ANSIAttr = .`default`, back: ANSIAttr = .onDefault) {
  // check for foreground color value
  if fore.rawValue >= 30 && fore.rawValue <= 37 ||
     fore.rawValue >= 90 && fore.rawValue <= 97 ||
     fore.rawValue == ANSIAttr.`default`.rawValue {
    write(CSI+"\(fore.rawValue)m") }
  // check for background color value
  if back.rawValue >=  40 && back.rawValue <=  47 ||
     back.rawValue >= 100 && back.rawValue <= 107 ||
     back.rawValue == ANSIAttr.onDefault.rawValue {
    write(CSI+"\(back.rawValue)m") }
  isOpenedColor = true
}

public func setColors(_ fore: UInt8, on back: UInt8) {
  guard 1...255 ~= fore && 1...255 ~= back else {
    return
  }

  write(CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(fore)m" +
        CSI+"\(ANSIAttr.back256Color.rawValue);5;\(back)m")
  isOpenedColor = true
}

public func setDefault(color: Bool = true, style: Bool = false) {
  if color {
    write(CSI+"\(ANSIAttr.`default`.rawValue);\(ANSIAttr.onDefault.rawValue)m")
    isOpenedColor = false
  }

  if style {
    write(CSI+"\(ANSIAttr.normal.rawValue)m")
    isOpenedStyle = false
  }
}

public func isForeColor(_ color: UInt8) -> Bool {
  return (color >= 30 && color <= 37) ||
  (color >= 90 && color <= 97)
}

public func isBackColor(_ color: UInt8) -> Bool {
  return (color >= 40 && color <= 47) ||
  (color >= 100 && color <= 107)
}

public func isColor(_ color: UInt8) -> Bool {
  return isForeColor(color) || isBackColor(color)
}

public func foreToBack(_ color: ANSIAttr) -> ANSIAttr {
  if color.rawValue >= 30 && color.rawValue <= 37 ||
     color.rawValue >= 90 && color.rawValue <= 97 ||
     color.rawValue == ANSIAttr.onDefault.rawValue {
    return ANSIAttr(rawValue: color.rawValue+10)!
  } else {
    return color
  }
}

public func backToFore(_ color: ANSIAttr) -> ANSIAttr {
  if color.rawValue >=  40 && color.rawValue <=  47 ||
     color.rawValue >= 100 && color.rawValue <= 107 ||
     color.rawValue == ANSIAttr.onDefault.rawValue {
    return ANSIAttr(rawValue: color.rawValue-10)!
  } else {
    return color
  }
}

// remove all ANSI attributes from a string that has ANSI style/color
public func stripAttributes(from text: String) -> String {
  guard !text.isEmpty else { return text }

  // ANSI attribute is always started with ESC and ended by `m`
  var txt = text.split(separator: NonPrintableChar.escape.char())
  for (i, sub) in txt.enumerated() {
    if let end = sub.firstIndex(of: "m") {
      txt[i] = sub[sub.index(after: end)...]
    }
  }
  return txt.joined()
}
