//
//  ServerDataTVShow.swift
//  tmdbtest
//
//  Created by A on 05/12/21.
//

import Foundation

public class ServerDataTVShow {
    public init() {}

    let ApiServ         = ApiService()
    let dataCrypt       = CryptData()
    var ApiUserID       = Int()
    var ApiSessionID    = String()
    let urlSession      = URLSession.shared
    
    public typealias modelCompletition = (_ success: Bool,_ error: String,_ modeldata: [Resultseries]) -> Void

    public var refreshTVFavoritas = { () -> () in }
    public var ArrayTVFavoritas: [Resultseries] = [] {
        didSet {
            refreshTVFavoritas()
        }
    }
    
    public var refreshTVRecomendacion = { () -> () in }
    public var ArrayTVRecomendacion: [Resultseries] = [] {
        didSet {
            refreshTVRecomendacion()
        }
    }
    
    public var refreshTVPopular = { () -> () in }
    public var ArrayTVPopular: [Resultseries] = [] {
        didSet {
            refreshTVPopular()
        }
    }
    
    public func getAllTVFavoritas(completion: @escaping modelCompletition) {
        ApiUserID = Int(dataCrypt.decrypt(oncryptedText: Storage.userID))!
        ApiSessionID = dataCrypt.decrypt(oncryptedText: Storage.sessionID)
        let getFavoritesMethod = "account/\(String(describing: ApiUserID))/favorite/tv"
        let base = ApiServ.baseURLSecureString.appending(getFavoritesMethod).appending("?api_key=").appending(ApiServ.apiKey).appending("&session_id=").appending(ApiSessionID)
       
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: base)!)) { data, response, downloadError in
            if let error = downloadError { completion(false, "Could not complete the request \(error)", self.ArrayTVFavoritas) }
            else {
                do {
                    let result = try JSONDecoder().decode(TVResult.self, from: data!)
                    self.ArrayTVFavoritas = result.results
                    completion(true, "Array obtenido", self.ArrayTVFavoritas)
                } catch { completion(false, "no se pudieron obetener los datos", self.ArrayTVFavoritas) }
                
            }
        }.resume()
        
    }
    
    //Para obtener recomendaciones se escogio el ID de la serie de loki
    public func getAllTVRecomendacion(completion: @escaping modelCompletition) {
        let recomendacionMovies = "tv/84958/recommendations?api_key=7662169d6cde796d24b257cd0f8a268e&language=en-US&page=1"
        let url = ApiServ.baseURLSecureString.appending(recomendacionMovies)
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) {
            (data, req, error) in
            if let error = error { completion(false, "Hubo un error \(error)", self.ArrayTVRecomendacion) }
            do {
                let result = try JSONDecoder().decode(TVResult.self, from: data!)
                self.ArrayTVRecomendacion = result.results
                completion(true, "Array obtenido", self.ArrayTVRecomendacion)

            } catch { completion(false, "no se pudieron obetener los datos", self.ArrayTVRecomendacion) }

        }.resume()
    }
    
    public func getAllTVPopular(completion: @escaping modelCompletition) {
        let popularMovies = "tv/top_rated?api_key=7662169d6cde796d24b257cd0f8a268e&language=en-US&page=2"
        let url = ApiServ.baseURLSecureString.appending(popularMovies)
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) {
            (data, req, error) in
            if let error = error { completion(false, "Hubo un error \(error)", self.ArrayTVPopular) }
            do {
                let result = try JSONDecoder().decode(TVResult.self, from: data!)
                self.ArrayTVPopular = result.results
                completion(true, "Array obtenido", self.ArrayTVPopular)

            } catch { completion(false, "no se pudieron obetener los datos", self.ArrayTVPopular) }

        }.resume()
        
    }
    
}
