//
//  BusInfoParser.swift
//  TMT
//
//  Created by Choi Minkyeong on 10/9/24.
//

import Foundation

class BusInfoParser: NSObject, XMLParserDelegate {
    var currentElement = ""
    var arrmsg1 = ""
    var arrmsg2 = ""
    var vehId1 = "" // 버스 도착 정보 API에서 제공하는 첫번째로 도착하는 버스 고유 번호
    var vehId2 = "" // 버스 도착 정보 API에서 제공하는 두번째로 도착하는 버스 고유 번호
    var vehId = "" // 버스 위치 정보 API에서 제공하는 버스 고유 번호
    var nextStId = ""
    
    func parseXML(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "arrmsg1":
            arrmsg1 += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "arrmsg2":
            arrmsg2 += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "vehId1":
            vehId1 += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "vehId2":
            vehId2 += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "nextStId":
            nextStId += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "vehId":
            vehId += string.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("==============================")
        print("arrmsg1: \(arrmsg1)")
        print("arrmsg2: \(arrmsg2)")
        print("vehId1: \(vehId1)")
        print("vehId2: \(vehId2)")
        print("==============================")
        print("vehId: \(vehId)")
        print("nextStId: \(nextStId)")
        print("==============================")
    }
}
