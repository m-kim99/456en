//
//  UserInfo.swift
//  Log
//
//  Created by Point on 10/28/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

open class SnsUserInfo: NSObject {
  // MARK: - Member vars

  var user_id = 0
  var user_email = ""
  var user_password = ""
  var user_sns_id = ""
  var user_name = ""
  var user_birth = ""
  var user_login_type: SnsType!
  var user_photo_url = ""

  // MARK: - Login user

  static var me: SnsUserInfo!
}
