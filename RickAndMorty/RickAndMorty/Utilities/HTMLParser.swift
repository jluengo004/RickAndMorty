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
            
            let paragraphs = html.components(separatedBy: "<p>").dropFirst().dropFirst()
            let synopsis = paragraphs.compactMap { $0.components(separatedBy: "</p>").first }
                                    .filter { !$0.contains("<") }.first
            
            return .success((imageString,synopsis))
        } catch {
            return .failure(.decodingError("HTTMLParser"))
        }
    }
    
}
