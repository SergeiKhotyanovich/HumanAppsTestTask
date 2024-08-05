// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum Lufga {
    internal static let black = FontConvertible(name: "Lufga-Black", family: "Lufga", path: "Lufga-Black.ttf")
    internal static let blackItalic = FontConvertible(name: "Lufga-BlackItalic", family: "Lufga", path: "Lufga-BlackItalic.ttf")
    internal static let bold = FontConvertible(name: "Lufga-Bold", family: "Lufga", path: "Lufga-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "Lufga-BoldItalic", family: "Lufga", path: "Lufga-BoldItalic.ttf")
    internal static let extraBold = FontConvertible(name: "Lufga-ExtraBold", family: "Lufga", path: "Lufga-ExtraBold.ttf")
    internal static let extraBoldItalic = FontConvertible(name: "Lufga-ExtraBoldItalic", family: "Lufga", path: "Lufga-ExtraBoldItalic.ttf")
    internal static let extraLight = FontConvertible(name: "Lufga-ExtraLight", family: "Lufga", path: "Lufga-ExtraLight.ttf")
    internal static let extraLightItalic = FontConvertible(name: "Lufga-ExtraLightItalic", family: "Lufga", path: "Lufga-ExtraLightItalic.ttf")
    internal static let italic = FontConvertible(name: "Lufga-Italic", family: "Lufga", path: "Lufga-Italic.ttf")
    internal static let light = FontConvertible(name: "Lufga-Light", family: "Lufga", path: "Lufga-Light.ttf")
    internal static let lightItalic = FontConvertible(name: "Lufga-LightItalic", family: "Lufga", path: "Lufga-LightItalic.ttf")
    internal static let medium = FontConvertible(name: "Lufga-Medium", family: "Lufga", path: "Lufga-Medium.ttf")
    internal static let mediumItalic = FontConvertible(name: "Lufga-MediumItalic", family: "Lufga", path: "Lufga-MediumItalic.ttf")
    internal static let regular = FontConvertible(name: "Lufga-Regular", family: "Lufga", path: "Lufga-Regular.ttf")
    internal static let semiBold = FontConvertible(name: "Lufga-SemiBold", family: "Lufga", path: "Lufga-SemiBold.ttf")
    internal static let semiBoldItalic = FontConvertible(name: "Lufga-SemiBoldItalic", family: "Lufga", path: "Lufga-SemiBoldItalic.ttf")
    internal static let thin = FontConvertible(name: "Lufga-Thin", family: "Lufga", path: "Lufga-Thin.ttf")
    internal static let thinItalic = FontConvertible(name: "Lufga-ThinItalic", family: "Lufga", path: "Lufga-ThinItalic.ttf")
    internal static let all: [FontConvertible] = [black, blackItalic, bold, boldItalic, extraBold, extraBoldItalic, extraLight, extraLightItalic, italic, light, lightItalic, medium, mediumItalic, regular, semiBold, semiBoldItalic, thin, thinItalic]
  }
  internal static let allCustomFonts: [FontConvertible] = [Lufga.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
