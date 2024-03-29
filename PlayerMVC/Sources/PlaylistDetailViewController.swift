//
//  PlaylistDetailViewController.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import UIKit

class PlaylistDetailViewController: UIViewController {

    private let tableView = UITableView(frame: .zero)
    private let playlistId: Int
    private var playlist:Playlist?
    private let service: MusicService
    
    init(id: Int, service: MusicService = MusicService()) {
        self.playlistId = id
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        service.playlist(id: playlistId).onSuccess { (playlist) in
            self.title = playlist.name
            self.playlist = playlist
            self.tableView.reloadData()
        }
    }
}

extension PlaylistDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist?.tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = playlist!.tracks![indexPath.row].name
        return cell
    }
}

extension PlaylistDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = playlist!.tracks![indexPath.row]
        self.navigationController?.pushViewController(TrackDetailViewController(trackId: track.id), animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
