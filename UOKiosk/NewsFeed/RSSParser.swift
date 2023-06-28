//
//  RSSParser.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//
// Source: https://medium.com/@MedvedevTheDev/xmlparser-working-with-rss-feeds-in-swift-86224fc507dc

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    var xmlParser: XMLParser!
    var currentElement = "" // Holds the value of the current XML tag
    var foundCharacters = "" // Holds the value of said tag (characters encapsulated by the tag)
    var currentData = [String:String]() // Holds each feed item reconstructed
    var parsedData = [[String:String]]() // Holds each completed news article entry (represents the entirety of a single RSS feed
    var isHeader = true // Lets us know whether we're parsing an actual feed item or its header (which also has a title, description, and so on)

    func startParsingWithContentsOfURL(rssUrl: URL, with completion: (Bool)->()) {
        let parser = XMLParser(contentsOf: rssUrl)
        parser?.delegate = self
        if let flag = parser?.parse() {
            // handle last item in feed
            parsedData.append(currentData)
            completion(flag)
        }
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName

        // news items start at <item> tag, we're not interested in header
        if currentElement == "item" || currentElement == "entry" {
            // at this point we're working with n+1 entry
            if !isHeader {
                parsedData.append(currentData)
            }
            isHeader = false
        }

        if !isHeader {
            // handle article thumbnails
            if currentElement == "media:thumbnail" || currentElement == "media:content" {
                foundCharacters += attributeDict["url"]!
            }
        }
    }

    // keep relevant tag content
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !isHeader {
            if currentElement == "title" || currentElement == "link" || currentElement == "description" || currentElement == "content"
                || currentElement == "pubDate" || currentElement == "author" || currentElement == "dc:creator"
                || currentElement == "content:encoded" {
                foundCharacters += string
                foundCharacters = foundCharacters.deleteHTMLTags(tags: ["a", "p", "div", "img"])
            }
        }
    }

    // look at closing tag
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if !foundCharacters.isEmpty {
            foundCharacters = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            currentData[currentElement] = foundCharacters
            foundCharacters = ""
        }
    }
}

extension String {
    func deleteHTMLTag(tag: String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }

    func deleteHTMLTags(tags: [String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
}
