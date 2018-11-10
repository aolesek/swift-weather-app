//
//  TableItem.swift
//  oleweather-2
//
//  Created by arek on 07/11/2018.
//  Copyright © 2018 aolesek. All rights reserved.
//

import Foundation
import UIKit

enum ConditionsType : String, CaseIterable  {
    case sn, sl, h, t, hr, lr, s, hc, lc, c
}

class ConditionsTypeImageProvider {
    
    let type: ConditionsType;
    
    init(typeEnum: ConditionsType) {
        self.type = typeEnum
    }
    
    static func getImage(abbr: String) -> UIImage? {
        let type = ConditionsType.init(rawValue: abbr)
        if let unwrappedType = type {
            let provider = ConditionsTypeImageProvider(typeEnum: unwrappedType)
            return provider.weatherImage
        }
        return nil
    }
    
    var weatherImage: UIImage {
        switch type {
        case .sn:
            return UIImage(named: "sn.png")!
        case .sl:
            return UIImage(named: "sl.png")!
        case .h:
            return UIImage(named: "h.png")!
        case .t:
            return UIImage(named: "t.png")!
        case .hr:
            return UIImage(named: "hr.png")!
        case .lr:
            return UIImage(named: "lr.png")!
        case .s:
            return UIImage(named: "s.png")!
        case .hc:
            return UIImage(named: "hc.png")!
        case .lc:
            return UIImage(named: "lc.png")!
        case .c:
            return UIImage(named: "c.png")!

        }
    }
}
