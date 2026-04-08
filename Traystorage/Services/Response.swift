import Foundation
import SwiftyJSON

public enum ResponseResultCode: Int {
    case SUCCESS = 0
    case ERROR_SERVER=101
    case ERROR_DB=102
    case ERROR_PARAM=103
    case ERROR_ACCESS_TOKEN=104
    case ERROR_VERIFY_CODE=105
    case ERROR_USER_NO_EXIST=202
    case ERROR_ID_DUPLICATED=203
    case ERROR_NICKNAME_DUPLICATED=204
    case ERROR_PHONE_DUPLICATED=206
    case ERROR_USER_CHECKING=207
    case ERROR_UPLOAD=208
    case ERROR_USER_PAUSED=209
    case ERROR_USER_EXIT=210
    case ERROR_WRONG_PWD=211
    case ERROR_EMAIL_DUPLICATED=212
    case ERROR_USER_DUPLICATED=214
    case ERROR_ALREADY_CHECKED=215
    case ALREADY_USER_FREE_PAY=300
}


/**
 *  Parse API response data.
 */
func ParseResponse(api: API, json: JSON) throws -> ModelBase? {
    switch api {
    case .APP_INFO:
        return ModelAppInfo(json)
    case .USER_LOGIN:
        return ModelUser(json)
    case .REQUEST_CODE_FIND:
        return ModelBase(json)
    case .REQUEST_CODE_SIGNUP:
        return ModelBase(json)
    case .USER_VERIFY_CERTKEY_PHONE:
        return ModelBase(json)
    case .USER_FIND_ID:
        return ModelUser(json)
    case .USER_SIGNUP:
        return ModelUser(json)
    case .USER_FIND_PWD:
        return ModelBase(json)
    case .MAKE_PROFILE:
        return ModelUser(json)
    case .DOCUMENT_LIST:
        return ModelDocumentList(json)
    case .DOCUMENT_INSERT:
        return ModelDocument(json)
    case .ASK_LIST:
        return ModelCardList(json)
    case .GET_NOTICE_LIST:
        return ModelNoticeList(json)
    case .GET_NOTICE_DETAIL:
        return ModelNotice(json)
    case .FAQ_LIST:
        return ModelFAQList(json)
    case .FAQ_CATE:
        return ModelFAQCateList(json)
    case .VERSION:
        return ModelVersion(json)
    case .POPUP_INFO:
        return ModelPopupList(json)
    case .VIEW_CLICK_POPUP:
        return ModelBase(json)
    case .INSERT_ASK:
        return ModelBase(json)
    case .UPLOAD_FILES:
        return ModelUploadFileList(json)
    case .CANCEL_EXIT:
        return ModelUser(json)
    case .GET_AGREE_TERMS:
        return ModelAgreementList(json)
    case .GET_AGREE_DETAIL:
        return ModelAgreement(json)
    case .REQUEST_EXIT:
        return ModelBase(json)
    case .DOCUMENT_DETAIL:
        return ModelDocument(json)
    default:
        break
    }
    
    return nil
}
