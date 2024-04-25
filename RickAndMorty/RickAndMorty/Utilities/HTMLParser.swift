//
//  HTMLParser.swift
//  RickAndMorty
//
//  Created by Jon Luengo on 5/9/23.
//
import SwiftSoup
import Foundation

final class HTTMLParser {
    
    func parse(html: String) -> Result<(String?, String?), ServiceErrors> {
        do {
            let document: Document = try SwiftSoup.parse(html)
            
            let imageClass = try document.getElementsByClass("image image-thumbnail")
            let imageHTML = try imageClass.get(0).html()
            let imageSplit = imageHTML.components(separatedBy: "<img src=").last
            let imageString = imageSplit?.components(separatedBy: "\"")[1]
            
            let synopsisClass = html.components(separatedBy: "<p>")[2]
            let synopsis = synopsisClass.components(separatedBy: "</p>").first
            
            return .success((imageString,synopsis))
        } catch {
            return .failure(.decodingError("HTTMLParser"))
        }
    }
    
}
