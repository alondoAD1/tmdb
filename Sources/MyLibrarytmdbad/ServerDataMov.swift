//
//  ServerData.swift
//  tmdbtest
//
//  Created by A on 05/12/21.
//

import Foundation

public class ServerDataMov {
    public init() {}

    let ApiServ         = ApiService()
    let dataCrypt       = CryptData()
    var ApiUserID       = String()
    var ApiSessionID    = String()
    let urlSession      = URLSession.shared
    
    public typealias modelCompletition = (_ success: Bool,_ error: String,_ modeldata: [Result]) -> Void

    public var refreshMovFavoritas = { () -> () in }
    public var ArrayMovFavoritas: [Result] = [] {
        didSet {
            refreshMovFavoritas()
        }
    }
    
    public var refreshMovRecomendacion = { () -> () in }
    public var ArrayMovRecomendacion: [Result] = [] {
        didSet {
            refreshMovRecomendacion()
        }
    }
    
    public var refreshMovPopular = { () -> () in }
    public var ArrayMovPopular: [Result] = [] {
        didSet {
            refreshMovPopular()
        }
    }
    
    public func getAllMovFavoritas(completion: @escaping modelCompletition) {
        ApiUserID       = self.dataCrypt.decrypt(oncryptedText: Storage.userID)
        ApiSessionID    = self.dataCrypt.decrypt(oncryptedText: Storage.sessionID)
        let getFavoritesMethod = "account/\(String(describing: ApiUserID))/favorite/movies"
        let base = ApiServ.baseURLSecureString.appending(getFavoritesMethod).appending("?api_key=").appending(ApiServ.apiKey).appending("&session_id=").appending(ApiSessionID)
       
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: base)!)) { data, response, downloadError in
            if let error = downloadError { completion(false, "Could not complete the request \(error)", self.ArrayMovFavoritas) }
            else {
                do {
                    let result = try JSONDecoder().decode(MovieResult.self, from: data!)
                    self.ArrayMovFavoritas = result.results
                    completion(true, "Array obtenido", self.ArrayMovFavoritas)
                } catch { completion(false, "no se pudieron obetener los datos", self.ArrayMovFavoritas) }
                
            }
        }.resume()
        
    }
    
    public func getAllMovRecomendacion(completion: @escaping modelCompletition) {
        let recomendacionMovies = "movie/343611/recommendations?api_key=7662169d6cde796d24b257cd0f8a268e&language=en-US&page=1"
        let url = ApiServ.baseURLSecureString.appending(recomendacionMovies)
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) {
            (data, req, error) in
            if let error = error { completion(false, "Hubo un error \(error)", self.ArrayMovRecomendacion) }
            do {
                let result = try JSONDecoder().decode(MovieResult.self, from: data!)
                self.ArrayMovRecomendacion = result.results
                completion(true, "Array obtenido", self.ArrayMovRecomendacion)

            } catch { completion(false, "no se pudieron obetener los datos", self.ArrayMovRecomendacion) }

        }.resume()
    }
    
    public func getAllMovPopular(completion: @escaping modelCompletition) {
        let popularMovies = "movie/top_rated?api_key=7662169d6cde796d24b257cd0f8a268e&language=en-US&page=1"
        let url = ApiServ.baseURLSecureString.appending(popularMovies)
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) {
            (data, req, error) in
            if let error = error { completion(false, "Hubo un error \(error)", self.ArrayMovPopular) }
            do {
                let result = try JSONDecoder().decode(MovieResult.self, from: data!)
                self.ArrayMovPopular = result.results
                completion(true, "Array obtenido", self.ArrayMovPopular)

            } catch { completion(false, "no se pudieron obetener los datos", self.ArrayMovPopular) }

        }.resume()
        
    }

    
    
    
}

