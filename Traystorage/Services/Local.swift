import SwiftyJSON
import UIKit

enum Local : String {
    case PREFS_PUSH_KEY = "PREFS_PUSH_KEY"
    case PREFS_PUSH_RECV_DATA = "PREFS_PUSH_RECV_DATA"
    case PREFS_LANGUAGE = "PREFS_LANGUAGE"
    case PREFS_DRIVE_STATE = "PREFS_DRIVE_STATE"

    // app information
    case PREFS_APP_LICENSE = "PREFS_APP_LICENSE"
    case PREFS_APP_PRIVACY = "PREFS_APP_PRIVACY"
    case PREFS_APP_BACKGROUND_IMG = "PREFS_APP_BACKGROUND_IMG"
    case PREFS_APP_CHALLENGE_IMG = "PREFS_APP_CHALLENGE_IMG"
    case PREFS_APP_DRIVE_IMG = "PREFS_APP_DRIVE_IMG"
    case PREFS_APP_LIVE_IMG = "PREFS_APP_LIVE_IMG"
    case PREFS_APP_AUTO_LOGIN = "PREFS_APP_AUTO_LOGIN"
    case PREFS_APP_INTRO_SKIP = "PREFS_APP_INTRO_SKIP"
    
    // user information
    case PREFS_USER_UID = "PREFS_USER_UID"
    case PREFS_USER_ID = "PREFS_USER_ID"
    case PREFS_USER_EMAIL = "PREFS_USER_EMAIL"
    case PREFS_USER_PWD = "PREFS_USER_PWD"
    case PREFS_USER_NAME = "PREFS_USER_NAME"
    case PREFS_USER_PROFILE_IMG = "PREFS_USER_PROFILE_IMG"
    case PREFS_USER_PHONE = "PREFS_USER_PHONE"
    case PREFS_USER_BIRTHDAY = "PREFS_USER_BIRTHDAY"
    case PREFS_USER_GENDER = "PREFS_USER_GENDER"
    case PREFS_USER_STATUS = "PREFS_USER_STATUS"
    case PREFS_USER_ACCESS_TOKEN = "PREFS_USER_ACCESS_TOKEN"
    case PREFS_USER_ALARM_PUSH_YN = "PREFS_USER_ALARM_PUSH_YN"
    case PREFS_USER_ALARM_CHALLENGE_YN = "PREFS_USER_ALARM_CHALLENGE_YN"
    case PREFS_USER_DOCUMENT_CNT = "PREFS_USER_DOCUMENT_COUNT"
    
    case PREFS_APP_VERSION = "PREFS_APP_VERSION"
    case PREFS_DIM_LINK = "PREFS_DIM_LINK"
    
    case PREFS_PHOTO_PERMISSION = "PREFS_PHOTO_PERMISSION"

    public static func setAppVersion(_ version: String) {
        let ud = UserDefaults.standard
        ud.set(version, forKey: PREFS_APP_VERSION.rawValue)
        ud.synchronize()
    }
    
    public static func getAppVersion() -> String? {
        let ud = UserDefaults.standard
        let lang = ud.string(forKey: PREFS_APP_VERSION.rawValue)
        return lang
    }
    
    public static func setLanguage(_ language: String) {
        let ud = UserDefaults.standard
        ud.set(language, forKey: PREFS_LANGUAGE.rawValue)
        ud.synchronize()
    }
    
    public static func getLanguage() -> String! {
        let ud = UserDefaults.standard
        var lang = ud.string(forKey: PREFS_LANGUAGE.rawValue)
        if lang == nil {
            lang = DEFAULT_LANGUAGE
            setLanguage(lang!)
        }
        
        return lang
    }
    
    public static func getPushKey() -> String! {
        let ud: UserDefaults = UserDefaults.standard
        var pushKey = ud.string(forKey: PREFS_PUSH_KEY.rawValue)
        if pushKey == nil {
            pushKey = ""
        }
        
        return pushKey
    }
    
    public static func setPushKey(_ key: String) {
        let ud: UserDefaults = UserDefaults.standard
        ud.set(key, forKey: PREFS_PUSH_KEY.rawValue)
        ud.synchronize()
    }
    
    public static func getPushData() -> [AnyHashable: Any]? {
        return (UserDefaults.standard.object(forKey: PREFS_PUSH_RECV_DATA.rawValue) as? [AnyHashable: Any])
    }
    
    public static func setPushData(_ value: [AnyHashable: Any]) {
        UserDefaults.standard.set(value, forKey: PREFS_PUSH_RECV_DATA.rawValue)
    }

    public static func deleteUser() {
        let ud: UserDefaults = UserDefaults.standard
        ud.removeObject(forKey: PREFS_USER_UID.rawValue)
        ud.removeObject(forKey: PREFS_USER_ID.rawValue)
        ud.removeObject(forKey: PREFS_USER_EMAIL.rawValue)
        ud.removeObject(forKey: PREFS_USER_PWD.rawValue)
        ud.removeObject(forKey: PREFS_USER_NAME.rawValue)
        ud.removeObject(forKey: PREFS_USER_PROFILE_IMG.rawValue)
        ud.removeObject(forKey: PREFS_USER_PHONE.rawValue)
        ud.removeObject(forKey: PREFS_USER_BIRTHDAY.rawValue)
        ud.removeObject(forKey: PREFS_USER_GENDER.rawValue)
        ud.removeObject(forKey: PREFS_USER_STATUS.rawValue)
        ud.removeObject(forKey: PREFS_USER_ACCESS_TOKEN.rawValue)
        ud.removeObject(forKey: PREFS_USER_ALARM_PUSH_YN.rawValue)
        ud.removeObject(forKey: PREFS_USER_ALARM_CHALLENGE_YN.rawValue)
        ud.removeObject(forKey: PREFS_USER_DOCUMENT_CNT.rawValue)
        
        ud.synchronize()
    }
    
    public static func setUser(_ user: ModelUser) {
        let ud: UserDefaults = UserDefaults.standard
        
        ud.set(user.uid, forKey: PREFS_USER_UID.rawValue)
        ud.set(user.email, forKey: PREFS_USER_EMAIL.rawValue)
        ud.set(user.pwd, forKey: PREFS_USER_PWD.rawValue)
        ud.set(user.name, forKey: PREFS_USER_NAME.rawValue)
        ud.set(user.profile_img, forKey: PREFS_USER_PROFILE_IMG.rawValue)
        ud.set(user.phone, forKey: PREFS_USER_PHONE.rawValue)
        ud.set(user.birthday, forKey: PREFS_USER_BIRTHDAY.rawValue)
        ud.set(user.gender, forKey: PREFS_USER_GENDER.rawValue)
        ud.set(user.status, forKey: PREFS_USER_STATUS.rawValue)
        ud.set(user.access_token, forKey: PREFS_USER_ACCESS_TOKEN.rawValue)
        ud.set(user.document_cnt, forKey: PREFS_USER_DOCUMENT_CNT.rawValue)
        
        ud.synchronize()
    }
    
    public static func getUser() -> (
        uid: String?,
        email: String?,
        pwd: String?,
        name: String?,
        profile_img: String?,
        phone: String?,
        birthday: String?,
        gender: String?,
        status: Int?,
        access_token: String?,
        documentCount: Int?) {
        let ud: UserDefaults = UserDefaults.standard
        return (
            uid: ud.string(forKey: PREFS_USER_UID.rawValue),
            email: ud.string(forKey: PREFS_USER_EMAIL.rawValue),
            pwd: ud.string(forKey: PREFS_USER_PWD.rawValue),
            name: ud.string(forKey: PREFS_USER_NAME.rawValue),
            profile_img: ud.string(forKey: PREFS_USER_PROFILE_IMG.rawValue),
            phone: ud.string(forKey: PREFS_USER_PHONE.rawValue),
            birthday: ud.string(forKey: PREFS_USER_BIRTHDAY.rawValue),
            gender: ud.string(forKey: PREFS_USER_GENDER.rawValue),
            status: ud.integer(forKey: PREFS_USER_STATUS.rawValue),
            access_token: ud.string(forKey: PREFS_USER_ACCESS_TOKEN.rawValue),
            documentCount: ud.integer(forKey: PREFS_USER_DOCUMENT_CNT.rawValue)
        )
    }
    
    public static func setAppInfo(_ model: ModelAppInfo) {
        let ud: UserDefaults = UserDefaults.standard
        
        ud.set(model.license, forKey: PREFS_APP_LICENSE.rawValue)
        ud.set(model.privacy, forKey: PREFS_APP_PRIVACY.rawValue)
        ud.set(model.background_img, forKey: PREFS_APP_BACKGROUND_IMG.rawValue)
        ud.set(model.challenge_img, forKey: PREFS_APP_CHALLENGE_IMG.rawValue)
        ud.set(model.drive_img, forKey: PREFS_APP_DRIVE_IMG.rawValue)
        ud.set(model.live_img, forKey: PREFS_APP_LIVE_IMG.rawValue)
        
        ud.synchronize()
    }
    
    public static func getAppInfo() -> (
        license: String?,
        privacy: String?,
        background_img: String?,
        challenge_img: String?,
        drive_img: String?,
        live_img: String?) {
        let ud: UserDefaults = UserDefaults.standard
        return (
            license: ud.string(forKey: PREFS_APP_LICENSE.rawValue),
            privacy: ud.string(forKey: PREFS_APP_PRIVACY.rawValue),
            background_img: ud.string(forKey: PREFS_APP_BACKGROUND_IMG.rawValue),
            challenge_img: ud.string(forKey: PREFS_APP_CHALLENGE_IMG.rawValue),
            drive_img: ud.string(forKey: PREFS_APP_DRIVE_IMG.rawValue),
            live_img: ud.string(forKey: PREFS_APP_LIVE_IMG.rawValue)
        )
    }
    
    public static func setDriveState(_ state: String) {
        let ud: UserDefaults = UserDefaults.standard
        ud.set(state, forKey: PREFS_DRIVE_STATE.rawValue)
        ud.synchronize()
    }
    
    public static func getDriveState() -> (
        String?) {
        let ud: UserDefaults = UserDefaults.standard
        return (
            ud.string(forKey: PREFS_DRIVE_STATE.rawValue)
        )
    }
    
    public static func deleteDriveState() {
        let ud: UserDefaults = UserDefaults.standard
        ud.removeObject(forKey: PREFS_DRIVE_STATE.rawValue)
        
        ud.synchronize()
    }
    
    public static func setNeverShowPopup(_ never: Bool) {
        let ud: UserDefaults = UserDefaults.standard
        ud.set(never, forKey: "never_show_popup")
        ud.synchronize()
    }
    
    public static func getNeverShowPopup() -> Bool! {
        let ud: UserDefaults = UserDefaults.standard
        let never = ud.bool(forKey: "never_show_popup")        
        return never
    }
    
    public static func removeAutoLogin() {
        let ud: UserDefaults = UserDefaults.standard
        ud.removeObject(forKey: PREFS_APP_AUTO_LOGIN.rawValue)
        ud.synchronize()
    }
    
    public static func getDimLink() -> String! {
        let ud = UserDefaults.standard
        var pushKey = ud.string(forKey: PREFS_DIM_LINK.rawValue)
        if pushKey == nil {
            pushKey = ""
        }
        
        return pushKey
    }
    
    public static func setDimLink(_ key: String) {
        let ud = UserDefaults.standard
        ud.set(key, forKey: PREFS_DIM_LINK.rawValue)
        ud.synchronize()
    }

}
