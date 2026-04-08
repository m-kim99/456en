import Foundation
import SwiftyJSON

public class ModelReserve: ModelBase {
    var schedule_num: Int!
    var note: String!
    var start_date: String!
    var start_time: String!
    var end_time: String!
    var time_length: Int!
    var unit_price: Int!
    var date_offset: Int!
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        schedule_num = json["schedule_num"].intValue
        note = json["note"].stringValue
        start_date = json["start_date"].stringValue
        start_time = json["start_time"].stringValue
        end_time = json["end_time"].stringValue
        time_length = json["time_length"].intValue
        unit_price = json["unit_price"].intValue
        date_offset = json["date_offset"].intValue
    }
    
    init(dumyIndex: Int!) {
        super.init()
        
        if dumyIndex % 4 == 0 {
            schedule_num = 1
            note = ""
            start_date = "2021-12-03"
            start_time = "23:00"
            end_time = "01:00"
            time_length = 120
            date_offset = 1
        } else if dumyIndex % 4 == 1 {
            schedule_num = 1
            note = ""
            start_date = "2021-12-03"
            start_time = "06:00"
            end_time = "08:00"
            time_length = 120
            date_offset = 1
        } else if dumyIndex % 4 == 2 {
            schedule_num = 1
            note = ""
            start_date = "2021-12-03"
            start_time = "08:00"
            end_time = "09:30"
            time_length = 90
            date_offset = 1
        } else {
            schedule_num = 1
            note = ""
            start_date = "2021-12-03"
            start_time = "04:30"
            end_time = "06:00"
            time_length = 90
            date_offset = 1
        }
    }
}

//extension ModelReserve: Equatable {
//    public static func ==(left: ModelReserve, right: ModelReserve) -> Bool {
//        return
//        (left.schedule_num == right.schedule_num &&
//         left.note == right.note &&
//         left.start_date == right.start_date &&
//         left.start_time == right.start_time &&
//         left.end_time == right.end_time &&
//         left.time_length == right.time_length &&
//         left.unit_price == right.unit_price &&
//         left.date_offset == right.date_offset)
//    }
//}

public class ModelReserveList: ModelList {
    var contents = [ModelReserve?]()
    
    override init() {
        super.init()
    }
    
    override init(_ json: JSON) {
        super.init(json)
        
        let arr = json["contents"]
        if arr != .null {
            for (_, m) in arr {
                contents.append(ModelReserve(m))
            }
        }
    }
}
