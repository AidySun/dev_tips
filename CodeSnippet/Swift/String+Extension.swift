
// get localized string from Bundle for specific language
extension String {
    var localized: String {
        
        if let lang = Locale(identifier: myidentifier).languageCode {
            Bundle.setLanguage(lang)
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


// this will get localized from Localizable.strings
extension String {
    var localizedStr: String {
        return NSLocalizedString(self, comment: "")
    }
}
// usage: "plus".localizedStr

