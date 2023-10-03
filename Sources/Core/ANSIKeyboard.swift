//
//  ANSIKeyboard.swift
//
//
//  Created by Tornike on 30/09/2023.
//

import Foundation

public enum NonPrintableChar: Character {
  case none      = "\u{00}"   // \0 NUL
  case bell      = "\u{07}"   // \a BELL
  case erase     = "\u{08}"   // BS
  case tab       = "\u{09}"   // \t TAB (horizontal)
  case linefeed  = "\u{0A}"   // \n LF
  case vtab      = "\u{0B}"   // \v VT (vertical tab)
  case formfeed  = "\u{0C}"   // \f FF
  case enter     = "\u{0D}"   // \r CR
  case endOfLine = "\u{1A}"   // SUB or EOL
  case escape    = "\u{1B}"   // \e ESC
  case space     = "\u{20}"   // SPACE
  case del       = "\u{7F}"   // DEL
}

public extension NonPrintableChar {
  func char() -> Character {
    return self.rawValue
  }

  func code() -> Int {
    return Int(self.rawValue.asciiValue!)
  }
}

// check for non-printable character
@inlinable public func isNonPrintable(char: Character) -> Bool {
  return char < " " || char == "\u{7F}"
}

// check for non-printable ansi code
@inlinable public func isNonPrintable(code: Int) -> Bool {
  return code < 32 || code == 127
}

public enum ANSIKeyCode: UInt8 {
  case none      = 0    // null
  case up        = 65   // ESC [ A
  case down      = 66   // ESC [ B
  case right     = 67   // ESC [ C
  case left      = 68   // ESC [ D
  case end       = 70   // ESC [ F  or  ESC [ 4~
  case home      = 72   // ESC [ H  or  ESC [ 1~
  case insert    = 2    // ESC [ 2~
  case delete    = 3    // ESC [ 3~
  case pageUp    = 5    // ESC [ 5~
  case pageDown  = 6    // ESC [ 6~

  case f1        = 80   // ESC O P  or  ESC [ 11~
  case f2        = 81   // ESC O Q  or  ESC [ 12~
  case f3        = 82   // ESC O R  or  ESC [ 13~
  case f4        = 83   // ESC O S  or  ESC [ 14~
  case f5        = 15   // ESC [ 15~
  case f6        = 17   // ESC [ 17~
  case f7        = 18   // ESC [ 18~
  case f8        = 19   // ESC [ 19~
  case f9        = 20   // ESC [ 20~
  case f10       = 21   // ESC [ 21~
  case f11       = 23   // ESC [ 23~
  case f12       = 24   // ESC [ 24~
}

public enum ANSIMetaCode: UInt8 {
  case control = 1
  case shift   = 2
  case alt     = 3
}

private func SS3Letter(_ key: UInt8) -> ANSIKeyCode {
  switch key {
  case ANSIKeyCode.f1.rawValue:
    return .f1
  case ANSIKeyCode.f2.rawValue:
    return .f2
  case ANSIKeyCode.f3.rawValue:
    return .f3
  case ANSIKeyCode.f4.rawValue:
    return .f4
  default:
    return .none
  }
}

private func CSILetter(_ key: UInt8) -> ANSIKeyCode {
  let keyMap: [UInt8: ANSIKeyCode] = [
    ANSIKeyCode.up.rawValue: .up,
    ANSIKeyCode.down.rawValue: .down,
    ANSIKeyCode.left.rawValue: .left,
    ANSIKeyCode.right.rawValue: .right,
    ANSIKeyCode.home.rawValue: .home,
    ANSIKeyCode.end.rawValue: .end,
    ANSIKeyCode.f1.rawValue: .f1,
    ANSIKeyCode.f2.rawValue: .f2,
    ANSIKeyCode.f3.rawValue: .f3,
    ANSIKeyCode.f4.rawValue: .f4
  ]
  return keyMap[key] ?? .none
}

private func CSINumber(_ key: UInt8) -> ANSIKeyCode {
  let keyMap: [UInt8: ANSIKeyCode] = [
    1: .home,
    4: .end,
    ANSIKeyCode.insert.rawValue: .insert,
    ANSIKeyCode.delete.rawValue: .delete,
    ANSIKeyCode.pageUp.rawValue: .pageUp,
    ANSIKeyCode.pageDown.rawValue: .pageDown,
    11: .f1,
    12: .f2,
    13: .f3,
    14: .f4,
    ANSIKeyCode.f5.rawValue: .f5,
    ANSIKeyCode.f6.rawValue: .f6,
    ANSIKeyCode.f7.rawValue: .f7,
    ANSIKeyCode.f8.rawValue: .f8,
    ANSIKeyCode.f9.rawValue: .f9,
    ANSIKeyCode.f10.rawValue: .f10,
    ANSIKeyCode.f11.rawValue: .f11,
    ANSIKeyCode.f12.rawValue: .f12
  ]

  return keyMap[key] ?? .none
}

internal func isLetter(_ key: Int) -> Bool {
  return (65...90 ~= key)
}

internal func isNumber(_ key: Int) -> Bool {
  return (48...57 ~= key)
}

internal func isLetter(_ chr: Character) -> Bool {
  return ("A"..."Z" ~= chr)
}

internal func isNumber(_ chr: Character) -> Bool {
  return ("0"..."9" ~= chr)
}

internal func isLetter(_ str: String) -> Bool {
  return ("A"..."Z" ~= str)
}

internal func isNumber(_ str: String) -> Bool {
  return ("0"..."9" ~= str)
}

private func CSIMeta(_ key: UInt8) -> [ANSIMetaCode] {
  switch key {
  case  2:
    return [.shift]
  case  3:
    return [.alt]
  case  4:
    return [.shift, .alt]
  case  5:
    return [.control]
  case  6:
    return [.shift, .control]
  case  7:
    return [.alt, .control]
  case  8:
    return [.shift, .alt, .control]
  default: return []
  }
}

public func readKey() -> (code: ANSIKeyCode, meta: [ANSIMetaCode]) {
    let wasNonBlocking = isNonBlockingMode
    if !wasNonBlocking {
        enableNonBlockingTerminal()
    }

    var code = ANSIKeyCode.none
    let meta: [ANSIMetaCode] = []

    guard keyPressed() else {
        return (code, meta)
    }

    var cmd = ESC
    var val: Int
    var key: Int

    while true {
        cmd.append(readChar())

        if cmd == CSI {
            (code, val, key) = handleCSICommand()
            if code != .none {
                break
            }
        } else if cmd == SS3 {
            key = readCode()
            if isLetter(key) {
                code = SS3Letter(UInt8(key))
            }
            break
        } else {
            break
        }
    }

    if !wasNonBlocking {
        disableNonBlockingTerminal()
    }

    return (code, meta)
}

private func handleCSICommand() -> (ANSIKeyCode, Int, Int) {
    var code = ANSIKeyCode.none
    var val = 0
    let key = readCode()

    if isLetter(key) {
        code = CSILetter(UInt8(key))
        return (code, val, key)
    } else if isNumber(key) {
        (code, val) = handleCSINumbers(Int(key))
        return (code, val, key)
    }

    return (code, val, key)
}

private func handleCSINumbers(_ key: Int) -> (ANSIKeyCode, Int) {
    var code = ANSIKeyCode.none
    var val: Int = key
    var cmd = String(val)
    var chr: Character

    repeat {
        chr = readChar()
        if isNumber(chr) {
            cmd.append(chr)
        }
    } while isNumber(chr)

    val = Int(cmd)!

    if chr == ";" {
        _ = handleCSIMeta()
    } else {
        code = CSINumber(UInt8(val))
    }

    return (code, val)
}

private func handleCSIMeta() -> [ANSIMetaCode] {
    let cmd = String(readChar())
    return isNumber(cmd) ? CSIMeta(UInt8(cmd)!) : []
}
