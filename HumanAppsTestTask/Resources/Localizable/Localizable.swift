// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AlertCompletion {
    /// Failed to save the image
    internal static let failed = L10n.tr("Localizable", "AlertCompletion.failed", fallback: "Failed to save the image")
    /// OK
    internal static let ok = L10n.tr("Localizable", "AlertCompletion.ok", fallback: "OK")
    /// The image has been successfully saved
    internal static let successfully = L10n.tr("Localizable", "AlertCompletion.successfully", fallback: "The image has been successfully saved")
  }
  internal enum AlertPermission {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "AlertPermission.cancel", fallback: "Cancel")
    /// Go to settings
    internal static let goToSettings = L10n.tr("Localizable", "AlertPermission.goToSettings", fallback: "Go to settings")
    /// Photo access required
    internal static let photoAccess = L10n.tr("Localizable", "AlertPermission.photoAccess", fallback: "Photo access required")
    /// Photos
    internal static let photos = L10n.tr("Localizable", "AlertPermission.photos", fallback: "Photos")
  }
  internal enum Main {
    /// Click me, please
    internal static let clickMe = L10n.tr("Localizable", "Main.clickMe", fallback: "Click me, please")
    /// Save
    internal static let save = L10n.tr("Localizable", "Main.save", fallback: "Save")
  }
  internal enum Tabbar {
    /// Main
    internal static let main = L10n.tr("Localizable", "Tabbar.main", fallback: "Main")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "Tabbar.settings", fallback: "Settings")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
