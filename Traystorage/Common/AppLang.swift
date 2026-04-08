import Foundation

func getLangString(_ forKey: String) -> String! {
    let lang = Language.shared().get(locale: gAppLanguage)?.string(forKey)
    if lang == nil {
        return forKey
    }
    return lang
}
