//
//  Global.swift
//  Log
//
//  Created by Point on 10/28/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import UIKit

var gMeInfo = SnsUserInfo()

// ------------------------------
// Typedef
// ------------------------------

public enum SnsType: Int {
  case Naver = 1
  case Kakao = 2
  case Google = 4
  
  var value: Int {
    return self.rawValue
  }
}

public enum SnsGenderType: Int {
  case Man = 1
  case Woman = 2

  var value: Int {
    return self.rawValue
  }
  
  var string: String {
    switch self {
    case .Man:
      return "M"
    default:
      return "W"
    }
  }
}

// naver key
let kConsumerKey = "ykGP3ZZn6tpOPEGqKFQa"
let kConsumerSecret = "rD_hVCCFpW"
let kServiceAppUrlScheme = "traystorageen"

let GOOGLEKEY = "1014352638153-ujrmupt1pi52nh46vgkqvol8e6g8gl7n.apps.googleusercontent.com"
let GOOGLE_SCHEMA = "com.googleusercontent.apps.1014352638153-ujrmupt1pi52nh46vgkqvol8e6g8gl7n"
