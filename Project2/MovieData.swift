//
//  MovieData.swift
//  Project2
//
//  Created by Thomas Johnson on 10/28/25.
//


import SwiftUI

// `MovieData` holds the entire catalog of movies that can be added.
// `MovieSeed` holds the initial set of movies displayed on app launch.

// Both are loaded from bundled JSON files located in the app’s main bundle

var MovieData: [Movie] = loadJson("MovieData.json")
var MovieSeed: [Movie] = loadJson("MovieSeed.json")

func loadJson<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("\(filename) not found.")
    }
    
    // Try reading the file into memory.
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Could not load \(filename): \(error)")
    }
    
  
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Unable to parse \(filename): \(error)")
    }
}
