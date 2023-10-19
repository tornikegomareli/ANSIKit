//
//  ANSIKeyboard.swift
//
//
//  Created by Tornike on 02/10/2023.
//

import Foundation

/// Represents non-printable ASCII characters.
public enum NonPrintableChar: Character {
  /// Null character.
  case none      = "\u{00}"   // \0 NUL

  /// Bell character.
  case bell      = "\u{07}"   // \a BELL

  /// Backspace character.
  case erase     = "\u{08}"   // BS

  /// Horizontal tab character.
  case tab       = "\u{09}"   // \t TAB (horizontal)

  /// Linefeed character.
  case linefeed  = "\u{0A}"   // \n LF

  /// Vertical tab character.
  case vtab      = "\u{0B}"   // \v VT (vertical tab)

  /// Formfeed character.
  case formfeed  = "\u{0C}"   // \f FF

  /// Enter (Carriage return) character.
  case enter     = "\u{0D}"   // \r CR

  /// End-of-line character.
  case endOfLine = "\u{1A}"   // SUB or EOL

  /// Escape character.
  case escape    = "\u{1B}"   // \e ESC

  /// Space character.
  case space     = "\u{20}"   // SPACE

  /// Delete character.
  case del       = "\u{7F}"   // DEL

  /// Returns the `Character` value of the non-printable character.
  public func char() -> Character {
    return self.rawValue
  }

  /// Returns the ASCII code of the non-printable character.
  public func code() -> Int {
    return Int(self.rawValue.asciiValue!)
  }
}

/// Checks if a character is non-printable.
///
/// - Parameter char: The character to check.
/// - Returns: `true` if the character is non-printable, `false` otherwise.
@inlinable public func isNonPrintable(char: Character) -> Bool {
  return char < " " || char == "\u{7F}"
}

/// Checks if an ASCII code is non-printable.
///
/// - Parameter code: The ASCII code to check.
/// - Returns: `true` if the code is non-printable, `false` otherwise.
@inlinable public func isNonPrintable(code: Int) -> Bool {
  return code < 32 || code == 127
}

/// Represents ANSI key codes for various keyboard actions.
public enum ANSIKeyCode: UInt8 {
  /// Represents no key or a null action.
  case none      = 0    // null

  /// Represents the Up arrow key.
  case up        = 65   // ESC [ A

  /// Represents the Down arrow key.
  case down      = 66   // ESC [ B

  /// Represents the Right arrow key.
  case right     = 67   // ESC [ C

  /// Represents the Left arrow key.
  case left      = 68   // ESC [ D

  /// Represents the End key.
  case end       = 70   // ESC [ F  or  ESC [ 4~

  /// Represents the Home key.
  case home      = 72   // ESC [ H  or  ESC [ 1~

  /// Represents the Insert key.
  case insert    = 2    // ESC [ 2~

  /// Represents the Delete key.
  case delete    = 3    // ESC [ 3~

  /// Represents the Page Up key.
  case pageUp    = 5    // ESC [ 5~

  /// Represents the Page Down key.
  case pageDown  = 6    // ESC [ 6~

  /// Represents the F1 function key.
  case f1        = 80   // ESC O P  or  ESC [ 11~

  /// Represents the F2 function key.
  case f2        = 81   // ESC O Q  or  ESC [ 12~

  /// Represents the F3 function key.
  case f3        = 82   // ESC O R  or  ESC [ 13~

  /// Represents the F4 function key.
  case f4        = 83   // ESC O S  or  ESC [ 14~

  /// Represents the F5 function key.
  case f5        = 15   // ESC [ 15~

  /// Represents the F6 function key.
  case f6        = 17   // ESC [ 17~

  /// Represents the F7 function key.
  case f7        = 18   // ESC [ 18~

  /// Represents the F8 function key.
  case f8        = 19   // ESC [ 19~

  /// Represents the F9 function key.
  case f9        = 20   // ESC [ 20~

  /// Represents the F10 function key.
  case f10       = 21   // ESC [ 21~

  /// Represents the F11 function key.
  case f11       = 23   // ESC [ 23~

  /// Represents the F12 function key.
  case f12       = 24   // ESC [ 24~
}

/// Represents ANSI meta codes.
public enum ANSIMetaCode: UInt8 {
  /// Control key.
  case control = 1

  /// Shift key.
  case shift   = 2

  /// Alt key.
  case alt     = 3
}

/// Maps SS3 letter to ANSI key code.
///
/// - Parameter key: The SS3 letter code.
/// - Returns: The corresponding ANSI key code.
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

/// Maps CSI letter to ANSI key code.
///
/// - Parameter key: The CSI letter code.
/// - Returns: The corresponding ANSI key code.
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

/// Maps CSI number to ANSI key code.
///
/// - Parameter key: The CSI number code.
/// - Returns: The corresponding ANSI key code.
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

/// Checks if the given ASCII code corresponds to a letter (A-Z).
///
/// - Parameter key: ASCII code of the character.
/// - Returns: `true` if it's a letter, `false` otherwise.
internal func isLetter(_ key: Int) -> Bool {
  return (65...90 ~= key)
}

/// Checks if the given ASCII code corresponds to a number (0-9).
///
/// - Parameter key: ASCII code of the character.
/// - Returns: `true` if it's a number, `false` otherwise.
internal func isNumber(_ key: Int) -> Bool {
  return (48...57 ~= key)
}

/// Checks if the given character is a letter (A-Z).
///
/// - Parameter chr: The character to check.
/// - Returns: `true` if it's a letter, `false` otherwise.
internal func isLetter(_ chr: Character) -> Bool {
  return ("A"..."Z" ~= chr)
}

/// Checks if the given character is a number (0-9).
///
/// - Parameter chr: The character to check.
/// - Returns: `true` if it's a number, `false` otherwise.
internal func isNumber(_ chr: Character) -> Bool {
  return ("0"..."9" ~= chr)
}

/// Checks if the given string contains a letter (A-Z).
///
/// - Parameter str: The string to check.
/// - Returns: `true` if it contains a letter, `false` otherwise.
internal func isLetter(_ str: String) -> Bool {
  return ("A"..."Z" ~= str)
}

/// Checks if the given string contains a number (0-9).
///
/// - Parameter str: The string to check.
/// - Returns: `true` if it contains a number, `false` otherwise.
internal func isNumber(_ str: String) -> Bool {
  return ("0"..."9" ~= str)
}

/// Maps CSI meta character to ANSI meta codes.
///
/// - Parameter key: CSI meta character.
/// - Returns: Array of corresponding ANSI meta codes.
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

/// Reads a key press and returns its ANSI key code and meta codes.
///
/// - Returns: Tuple containing the ANSI key code and meta codes.
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

/// Handles CSI commands to determine the ANSI key code.
///
/// - Returns: Tuple containing the ANSI key code, value, and key.
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

/// Handles CSI numbers to determine the ANSI key code and value.
///
/// - Parameter key: Initial number from the CSI command.
/// - Returns: Tuple containing the ANSI key code and value.
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

/// Handles CSI meta characters to determine the ANSI meta codes.
///
/// - Returns: Array of corresponding ANSI meta codes.
private func handleCSIMeta() -> [ANSIMetaCode] {
    let cmd = String(readChar())
    return isNumber(cmd) ? CSIMeta(UInt8(cmd)!) : []
}
