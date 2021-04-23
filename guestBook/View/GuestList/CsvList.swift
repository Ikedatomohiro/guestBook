//
//  CsvList.swift
//  guestBook
//
//  Created by Tomohiro Ikeda on 2021/04/18.
//

import UIKit

class CsvList {
    
    fileprivate var csvHeader: String = ""
    fileprivate var retualList: String = ""
    fileprivate var csvBody: String = ""
    
    func outputGuestList(_ guests: [Guest], _ retuals: [Retual]) -> Data? {
        csvHeader = setCsvHeader(retuals)
        for guest in guests {
            let guestData = "\"\(guest.guestName)\",\"\(guest.companyName)\",\"\(guest.telNumber)\",\"\(guest.zipCode)\",\"\(guest.address)\"\n"
            csvBody = csvBody + guestData
        }
        let csvList = csvHeader + csvBody
        let data: Data? = csvList.data(using: .utf8)
        return data
    }
    
    fileprivate func setCsvHeader(_ retuals: [Retual]) -> String {
        retualList = setRetualList(retuals)
        csvHeader = "\"御芳名\",\"会社名\",\"電話番号\",\"郵便番号\",\"御住所\"," + retualList + "\n"
        return csvHeader
    }
    
    fileprivate func setRetualList(_ retuals: [Retual]) -> String {
        for retual in retuals {
            if retualList != "" {
                retualList = retualList + ","
            }
            retualList = retualList + "\"\(retual.retualName)\""
        }
        return retualList
    }
}
