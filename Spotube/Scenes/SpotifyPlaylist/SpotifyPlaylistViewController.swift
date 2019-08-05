//
//  SpotifyPlaylistViewController.swift
//  Spotube
//
//  Created by Thiago M Faria on 03/08/19.
//  Copyright © 2019 Thiago Machado Faria. All rights reserved.
//

import UIKit
import Kingfisher
import JGProgressHUD

protocol SpotifyPlaylistDisplayLogic: class {
    
    var interactor: SpotifyPlaylistBusinessLogic? { get set }
    
    var wireFrame: SpotifyPlaylistWireframeProtocol? { get set }
    
    var navigation: UINavigationController? { get }
    
    func displayFetchedPlaylist(viewModel: Playlist.FetchPlayList.ViewModel)
}

class SpotifyPlaylistViewController: UIViewController {

    var interactor: SpotifyPlaylistBusinessLogic?
    
    var wireFrame: SpotifyPlaylistWireframeProtocol?
    
    var navigation: UINavigationController? {
        return self.navigationController
    }
    
    @IBOutlet weak var playListTbv: UITableView!
    
    var itens: [Playlist.FetchPlayList.ViewModel.DisplayedPlayList] = []
    
    var user: SpotifyLogin.FetchUser.ViewModel.DisplayedUser?
    
    let hud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confTb()
        setupNavigation()
        confHUD()
        fetchPlayList()
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        if let nome = user?.displayName {
             self.title = "Olá \(nome)"
        }
        
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func confTb() {
        
        let customCell = UINib(nibName: "SpotifyPlaylistViewCell", bundle: nil)
        playListTbv.register(customCell, forCellReuseIdentifier: "playlistCell")
        playListTbv.rowHeight = UITableView.automaticDimension
        playListTbv.estimatedRowHeight = 50
    }
    
    func confHUD() {
        hud.textLabel.text = "Carregando"
    }
    
    func fetchPlayList(){
        hud.show(in: self.view)
        if let id = user?.id, let token = user?.token {
            let request = Playlist.FetchPlayList.Request(token: token, userId: id)
            interactor?.playListSpotify(request: request)
        }
    }
}

extension SpotifyPlaylistViewController: SpotifyPlaylistDisplayLogic {
   
    func displayFetchedPlaylist(viewModel: Playlist.FetchPlayList.ViewModel) {
        itens = viewModel.displayedPlaylist
        playListTbv.reloadData()
        hud.dismiss()
    }
}

extension SpotifyPlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayedList = itens[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as! SpotifyPlaylistViewCell
        let url = URL.init(string: displayedList.image)
        cell.albumImg?.kf.setImage(with: url)
        cell.albumLb?.text = displayedList.name
        cell.ownerLb?.text = "criador: \(displayedList.owner)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let displayedList = itens[indexPath.row]
        print("You tapped cell number\(indexPath.row) : \(displayedList.name).")
    }
}

extension SpotifyPlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == itens.count - 2 {
            if let id = user?.id, let token = user?.token {
                let request = Playlist.FetchPlayList.Request(token: token, userId: id)
                interactor?.playListSpotify(request: request)
            }
        }
    }
}