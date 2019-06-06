//
//  MediaAPI.swift
//  MyTunes
//
//  Created by Arturo Lee on 6/6/19.
//  Copyright © 2019 Arturo Lee. All rights reserved.
//

import Foundation
import UIKit

class MediaAPI {
    static func getMedia(type: MediaType, feed: FeedType, fetchSize: Int, _ completion: @escaping (_ media: [MusicMedia]?) -> Void) {
        let url = URL(string:"https://rss.itunes.apple.com/api/v1/us/\(type.rawValue)/\(feed.rawValue)/all/\(fetchSize)/explicit.json")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "ServerError")
                completion(nil)
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            var mediaResults: [MusicMedia] = []
            if let dic = json! as? [String:Any], let feed = dic["feed"] as? [String:Any], let results = feed["results"] as? [[String:Any]] {
                for i in 0..<results.count {
                    let media = results[i]
                    if let musicMedia = MusicMedia(feedResult: media) {
                        mediaResults.append(musicMedia)
                    }
                }
            }
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
}

enum MediaType: String {
    case iTunes = "itunes-music"
    case apple = "apple-music"
}

enum FeedType: String {
    case topSongs = "top-songs"
    case topAlbums = "top-albums"
}

//Rename
struct MusicMedia {
    init?(feedResult: [String:Any]) {
        guard let gArtistId = feedResult["artistId"] as? String,
            let gArtistName = feedResult["artistName"] as? String,
            let gArtistURL = feedResult["artistUrl"] as? String,
            let gArtworkUrl100 = feedResult["artworkUrl100"] as? String,
            let gCopyright = feedResult["copyright"] as? String,
            let gId = feedResult["id"] as? String,
            let gKind = feedResult["kind"] as? String,
            let gName = feedResult["name"] as? String,
            let gReleaseDate = feedResult["releaseDate"] as? String,
            let gUrl = feedResult["url"] as? String
            else {
                return nil
        }
        artistId = gArtistId
        artistName = gArtistName
        artistUrl = gArtistURL
        artworkUrl100 = gArtworkUrl100
        copyright = gCopyright
        id = gId
        kind = gKind
        name = gName
        releaseDate = gReleaseDate
        url = gUrl
    }
    let artistId: String
    let artistName: String
    let artistUrl: String
    let artworkUrl100: String
    let copyright: String
    let id: String
    let kind: String
    let name: String
    let releaseDate: String
    let url: String
    var image: UIImage?
}
