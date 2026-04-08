import Foundation
import UIKit

class LocaleString {
    private var entities = [String: String?]()
    
    public func set(key: String, val: String) {
        entities[key] = val
    }
    
    public func string(_ key: String) -> String! {
        if entities[key] == nil {
            return ""
        }
        return entities[key]!
    }
}

class Language: NSObject, XMLParserDelegate {
    private static var privateShared: Language?
    private var entities = [String: LocaleString?]()
    
    private var _locale: String = ""
    private var _name: String = ""
    private var _value: String = ""
    
    class func shared() -> Language {
        guard let s = privateShared else {
            privateShared = Language()
            return privateShared!
        }
        return s
    }
    
    public func load(locale: String!) {
        let path = Bundle.main.path(forResource: locale, ofType: "xml")
        if path == nil {
            return
        }
        
        _locale = locale
        entities[locale] = LocaleString()
        
        let parser = XMLParser(contentsOf: URL(fileURLWithPath: path!))
        parser?.delegate = self
        parser?.parse()
    }
    
    public func get(locale: String!) -> LocaleString? {
        return entities[locale] as? LocaleString
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "string" {
            //print("start", elementName)
            for (key, value) in attributeDict {
                if key == "name" {
                    _name = value
                    _value = ""
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "string" {
            //print("end", elementName)
            if _name.isEmpty == false {
                let ls = entities[_locale] as? LocaleString
                _value = _value.replaceAll("\\n", with: "\n")
                ls?.set(key: _name, val: _value)
                _name = ""
            }
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        //print(string)
        if _name.isEmpty == false {
            _value = _value + string
        }
    }
}
