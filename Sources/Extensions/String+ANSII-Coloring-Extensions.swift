//
//  String+ANSII-Coloring-Extensions.swift
//
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

public extension String {
  internal func color(_ aColor: ANSIAttr) -> String {
    guard !self.isEmpty else { return self }

    if isOpenedColor {
      return CSI+"\(aColor.rawValue)m" + self
    } else {
      return CSI+"\(aColor.rawValue)m" + self +
      CSI+"\(ANSIAttr.`default`.rawValue);\(ANSIAttr.onDefault.rawValue)m"
    }
  }

  /// Look at https://jonasjacek.github.io/colors/ for list of 256 xterm colors
  func foreColor(_ aColor: UInt8) -> String {
    guard !self.isEmpty && (1...255 ~= aColor) else {
      return self
    }
    
    if isOpenedColor {
      return CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(aColor)m" + self
    } else {
      return CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(aColor)m" + self +
      CSI+"\(ANSIAttr.`default`.rawValue)m"
    }
  }
  
  func withForeColor(_ aColor: UInt8) -> String {
    return foreColor(aColor)
  }

  func backColor(_ aColor: UInt8) -> String {
    guard !self.isEmpty && (1...255 ~= aColor) else {
      return self
    }
    
    if isOpenedColor {
      return CSI+"\(ANSIAttr.back256Color.rawValue);5;\(aColor)m" + self
    } else {
      return CSI+"\(ANSIAttr.back256Color.rawValue);5;\(aColor)m" + self +
      CSI+"\(ANSIAttr.onDefault.rawValue)m"
    }
  }
  
  func withBackColor(_ aColor: UInt8) -> String {
    return backColor(aColor)
  }
  
  func colors(_ fore: UInt8, _ back: UInt8) -> String {
    guard !self.isEmpty && (1...255 ~= fore) && (1...255 ~= back) else {
      return self
    }
    
    if isOpenedColor {
      return CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(fore)m" +
      CSI+"\(ANSIAttr.back256Color.rawValue);5;\(back)m" + self
    } else {
      return CSI+"\(ANSIAttr.fore256Color.rawValue);5;\(fore)m" +
      CSI+"\(ANSIAttr.back256Color.rawValue);5;\(back)m" + self +
      CSI+"\(ANSIAttr.`default`.rawValue);\(ANSIAttr.onDefault.rawValue)m"
    }
  }
  
  func withColors(_ fore: UInt8, _ back: UInt8) -> String {
    return colors(fore, back)
  }
}
