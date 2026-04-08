import Foundation

//let Server_Url = "http://192.168.2.101:8005/api/" //py
let Server_Url = "http://traystorage.us/server/api/" //real server
//let Server_Url = "http://192.168.0.13:8205/api/" //local server

let API_TERM_URL = Server_Url + "app/term?type=term"
let API_PRIVACY_URL = Server_Url + "app/term?type=privacy"
let API_MARKETING_URL = Server_Url + "app/term?type=marketing"

enum API {
    case APP_INFO
    case USER_LOGIN
    case USER_SEND_CERTKEY_EMAIL
    case USER_SEND_CERTKEY_PHONE
    case USER_VERIFY_CERTKEY_EMAIL
    case USER_VERIFY_CERTKEY_PHONE
    case USER_SIGNUP
    case USER_FIND_ID
    case CHECK_LOGIN_ID
    case REQUEST_CODE_FIND
    case REQUEST_CODE_SIGNUP
    case USER_FIND_PWD
    case MAKE_PROFILE
    case CHANGE_PWD
    case DOCUMENT_LIST
    case DOCUMENT_DETAIL
    case DOCUMENT_INSERT
    case DOCUMENT_DELETE
    case DOCUMENT_UPDATE
    case POPUP_INFO
    case ASK_LIST
    case GET_NOTICE_LIST
    case GET_NOTICE_DETAIL
    case FAQ_LIST
    case FAQ_CATE
    case VERSION
    case VIEW_CLICK_POPUP
    case INSERT_ASK
    case UPLOAD_FILES
    case REQUEST_EXIT
    case CANCEL_EXIT
    case GET_AGREE_TERMS
    case GET_AGREE_DETAIL
    case AGREE_TERMS
    
    var url: String {
        switch self {
        case .APP_INFO:
            return "App/app_info"
        case .USER_LOGIN:
            return "user/login"
        case .USER_SEND_CERTKEY_EMAIL:
            return "user/send_certkey_by_email"
        case .USER_SEND_CERTKEY_PHONE:
            return "user/send_certkey_by_phone"
        case .USER_VERIFY_CERTKEY_EMAIL:
            return "user/verify_email"
        case .USER_VERIFY_CERTKEY_PHONE:
            return "user/check_code"
        case .USER_SIGNUP:
            return "user/signup"
        case .REQUEST_CODE_FIND:
            return "user/request_code_for_find"
        case .REQUEST_CODE_SIGNUP:
            return "user/request_code_for_signup"
        case .USER_FIND_ID:
            return "user/find_login_id"
        case .CHECK_LOGIN_ID:
            return "user/check_login_id"
        case .USER_FIND_PWD:
            return "user/find_pwd"
        case .MAKE_PROFILE:
            return "user/profile_update"
        case .CHANGE_PWD:
            return "user/change_pwd"
        case .DOCUMENT_LIST:
            return "app/get_document_list"
        case .DOCUMENT_DETAIL:
            return "app/get_document_detail"
        case .DOCUMENT_INSERT:
            return "app/insert_document"
        case .DOCUMENT_DELETE:
            return "app/delete_document_item"
        case .DOCUMENT_UPDATE:
            return "app/update_document"
        case .POPUP_INFO:
            return "app/popup_info"
        case .ASK_LIST:
            return "app/get_ask_list"
        case .GET_NOTICE_LIST:
            return "app/get_notice_list"
        case .GET_NOTICE_DETAIL:
            return "app/get_notice_detail"
        case .FAQ_LIST:
            return "app/get_faq_list"
        case .FAQ_CATE:
            return "app/get_faq_item_list"
        case .VERSION:
            return "app/version_info"
        case .VIEW_CLICK_POPUP:
            return "app/view_click_popup"
        case .INSERT_ASK:
            return "app/insert_ask"
        case .UPLOAD_FILES:
            return "upload/upload_files"
        case .REQUEST_EXIT:
            return "user/request_exit"
        case .CANCEL_EXIT:
            return "user/cancel_exit"
        case .GET_AGREE_TERMS:
            return "app/get_agree_list"
        case .GET_AGREE_DETAIL:
            return "app/get_agree_detail"
        case .AGREE_TERMS:
            return "user/agree_terms"
        }
    }
}
