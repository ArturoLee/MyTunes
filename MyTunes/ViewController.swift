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
    var fetchedMedia: [MusicMedia] = []
    let cellResuseId = "cell"
    
    let mediaControl = UISegmentedControl(items: ["iTunes", "Apple"])
    let feedControl = UISegmentedControl(items: ["Songs", "Albums"])
    var selectedMedia: MediaType {
        get {
            if mediaControl.selectedSegmentIndex == 0 {
                return .iTunes
            }
            return .apple
        }
    }
    var selectedFeed: FeedType {
        get {
            if feedControl.selectedSegmentIndex == 0 {
                return .topSongs
            }
            return .topAlbums
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSegmentedControls()
        requestMediaData()
        
        navigationItem.title = "Top 50"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedMedia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tunesTableView.dequeueReusableCell(withIdentifier: cellResuseId, for: indexPath) as! MediaTableViewCell
        cell.media = fetchedMedia[indexPath.row]
        cell.rankLabel.text = String(indexPath.row+1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func setupTableView() {
        tunesTableView = UITableView(frame: self.view.frame)
        tunesTableView.register(MediaTableViewCell.self, forCellReuseIdentifier: cellResuseId)
        tunesTableView.dataSource = self
        tunesTableView.delegate = self
        self.view.addSubview(tunesTableView)
        tunesTableView.translatesAutoresizingMaskIntoConstraints = false
        tunesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tunesTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tunesTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tunesTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        tunesTableView.allowsSelection = false
        tunesTableView.separatorStyle = .none
    }
    
    func setupSegmentedControls() {
        mediaControl.selectedSegmentIndex = 0
        feedControl.selectedSegmentIndex = 0
        mediaControl.addTarget(self, action: #selector(requestMediaData), for: .valueChanged)
        feedControl.addTarget(self, action: #selector(requestMediaData), for: .valueChanged)
        let controlStack = UIStackView()
        controlStack.axis = .horizontal
        controlStack.alignment = UIStackView.Alignment.center
        controlStack.spacing = 5
        controlStack.translatesAutoresizingMaskIntoConstraints = false
        controlStack.addArrangedSubview(mediaControl)
        controlStack.addArrangedSubview(feedControl)
        navigationItem.titleView = controlStack
    }
    
    @objc func requestMediaData() {
        MediaAPI.getMedia(type: selectedMedia, feed: selectedFeed, fetchSize: 50) { (mediaResults) in
            guard let results = mediaResults else {
                self.fetchedMedia = []
                DispatchQueue.main.async {self.tunesTableView.reloadData()}
                return
            }
            self.fetchedMedia = results
            self.requestArtwork()
            DispatchQueue.main.async {self.tunesTableView.reloadData()}
        }
    }
    
    func requestArtwork() {
        for i in 0..<self.fetchedMedia.count {
            let media = fetchedMedia[i]
            MediaAPI.getArtwork(artworkURL: media.artworkUrl100) { (image) in
                self.fetchedMedia[i].image = image
                DispatchQueue.main.async {
                    self.tunesTableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .none)
                }
            }
        }
    }

}
