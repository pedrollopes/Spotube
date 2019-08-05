//
//  SpotifyPlaylistWorker.swift
//  Spotube
//
//  Created by Thiago M Faria on 02/08/19.
//  Copyright © 2019 Thiago Machado Faria. All rights reserved.
//

import UIKit

protocol SpotifyPlaylistWorkerProtocol: class {
    
    var remoteDataManager: SpotifyPlaylistAPIInputProtocol? { get set }
    
    var interactor: SpotifyPlaylistWorkerDelegate? { get set }
    
    func spotifyRequestList(request: Playlist.FetchPlayList.Request, pagination: PaginationWorker)
    
}

protocol SpotifyPlaylistOutputProtocol: class {
    
    func fetchPlayListSpotify(itens: SpotifyPlaylist?)
    
}

class SpotifyPlaylistWorker: SpotifyPlaylistWorkerProtocol {
    
    var remoteDataManager: SpotifyPlaylistAPIInputProtocol?
    
    var interactor: SpotifyPlaylistWorkerDelegate?
    
    func spotifyRequestList(request: Playlist.FetchPlayList.Request, pagination: PaginationWorker) {
        remoteDataManager?.callAPIPlaylist(request: request, pagination: pagination)
    }
}

extension SpotifyPlaylistWorker: SpotifyPlaylistOutputProtocol {
    
    func fetchPlayListSpotify(itens: SpotifyPlaylist?) {
        
        interactor?.spotifyPlayList(itens: itens)
    }
}
