//
//  Shower.swift
//  Shower Ticker
//  Brian Steuber and Tyler Gonzalez
//  Final Project
//
//  Created by Tyler Gonzalez on 11/29/20.
//

import Foundation

/*
class Shower: Codable {
    var time: String
    var date: Date
    var waterSaved: Double
    
    static let pListURL: URL = {
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectoryURL.appendPathComponent("showerArray").appendingPathExtention("plist")
        return fileURL
    }()
    
    static func saveShowersToFile(showers: [Shower]) {
        let encoder = PropertyListEncoder
        
        if let showersData = try? encoder.encode(showers) {
            try? showersData.write(to: pListURL)
        }
    }
    
    static func loadShowersFromFile() -> [Shower]? {
        let decoder = PropertyListDecoder
        
        if let showersData = try? Data(contentsOf: pListURL), let decodedShowers = try? decoder.decode([Shower].self, from: showersData) {
            return decodedShowers
        }
        return nil
    }
 }*/
