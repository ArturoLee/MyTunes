//
//  MediaAPI.swift
//  MyTunes
//
//  Created by Arturo Lee on 6/6/19.
//  Copyright © 2019 Arturo Lee. All rights reserved.
//

import Foundation
import UIKit
import UIImageColors

class MediaAPI {
    static func getMedia(type: MediaType, feed: FeedType, fetchSize: Int, _ completion: @escaping (_ media: [MusicMedia]?) -> Void) {
        let url = URL(string:"https://rss.itunes.apple.com/api/v1/us/\(type.rawValue)/\(feed.rawValue)/all/\(fetchSize)/explicit.json")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "ServerError")
                completion(nil)
                return
            }
            let mediaResults = self.parseJSON(data)
            completion(mediaResults)
            
        }
        task.resume()
    }
    
    static func getArtwork(artworkURL:String, _ completion: @escaping (_ image: UIImage?) -> Void) {
        let url = URL(string: artworkURL)
        let task = URLSession.shared.dataTask(with: url!) {data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "ServerError")
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }
        task.resume()
    }
    
    static func parseJSON(_ musicData: Data) -> [MusicMedia]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FeedData.self, from: musicData)
            var allMusicMedia: [MusicMedia] = []
            for result in decodedData.feed.results {
                allMusicMedia.append(MusicMedia(media: result))
            }
            return allMusicMedia
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

enum MediaType: String {
    case iTunes = "itunes-music"
    case apple = "apple-music"
}

enum FeedType: String {
    case topSongs = "top-songs"
    case topAlbums = "top-albums"
}

struct FeedData: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let results: [Media]
}

struct Media: Codable {
    let name: String
    let artistName: String
    let artworkUrl100: String
}

struct MusicMedia {
    let media: Media
    var image: UIImage?
    var colors: UIImageColors?
}
