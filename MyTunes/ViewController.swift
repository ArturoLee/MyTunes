//
//  ViewController.swift
//  MyTunes
//
//  Created by Arturo Lee on 6/5/19.
//  Copyright © 2019 Arturo Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tunesTableView: UITableView!
    var appleMusicMedia: [AppleMusicMedia] = []
    
    let cellResuseId = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tunesTableView = UITableView(frame: self.view.frame)
        tunesTableView.register(MediaTableViewCell.self, forCellReuseIdentifier: cellResuseId)
        tunesTableView.dataSource = self
        tunesTableView.delegate = self
        self.view.addSubview(tunesTableView)
        setupTableView()
        
        getiTunesMediaData()
        
        navigationItem.title = "MyTunes"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appleMusicMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tunesTableView.dequeueReusableCell(withIdentifier: cellResuseId, for: indexPath) as! MediaTableViewCell
        cell.media = appleMusicMedia[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func setupTableView() {
        tunesTableView.translatesAutoresizingMaskIntoConstraints = false
        tunesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tunesTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tunesTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tunesTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
    }
    
    //MARK: Model
    
    func getiTunesMediaData() {
        let url = URL(string:"https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/30/explicit.json")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "ServerError")
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            if let dic = json! as? [String:Any], let feed = dic["feed"] as? [String:Any], let results = feed["results"] as? [[String:Any]] {
                self.appleMusicMedia = []
                for i in 0..<results.count {
                    let media = results[i]
                    if let musicMedia = AppleMusicMedia(feedResult: media) {
                        self.appleMusicMedia.append(musicMedia)
                        self.fetchArtworkFor(index: i)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tunesTableView.reloadData()
            }
        }
        task.resume()
    }
    
    func fetchArtworkFor(index:Int) {
        let media = appleMusicMedia[index]
        let url = URL(string: media.artworkUrl100)
        let task = URLSession.shared.dataTask(with: url!) {data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "ServerError")
                return
            }
            self.appleMusicMedia[index].image = UIImage(data: data)
            DispatchQueue.main.async {
                self.tunesTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
        task.resume()
    }

}

struct AppleMusicMedia {
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
