//
//  DetailsViewController.swift
//  GoNet Examen
//
//  Created by A on 26/11/21.
//

import UIKit
import WebKit

public class DetailsViewController: UIViewController {
        
    let apiservice = ApiService()
    
    lazy var scrollViewDetaill: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    lazy var imageBackgroundPath: UIImageView = {
        let item = UIImageView()
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var blurBackgroundPath: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    lazy var imagePosterPath: UIImageView = {
        let item = UIImageView()
        item.layer.cornerRadius = 20
        item.clipsToBounds = true
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var blurPosterPath: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    lazy var titulo: UILabel = {
        let item = UILabel()
        item.backgroundColor = .clear
        item.numberOfLines = 0
        item.lineBreakMode = .byWordWrapping
        item.textColor = UIColor(named: "Texto")
        item.font = item.font.withSize(26)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var date: UILabel = {
        let item = UILabel()
        item.backgroundColor = .clear
        item.numberOfLines = 0
        item.lineBreakMode = .byWordWrapping
        item.textColor = UIColor(named: "Texto")
        item.font = item.font.withSize(20)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var vote_average: UILabel = {
        let item = UILabel()
        item.backgroundColor = .clear
        item.numberOfLines = 0
        item.lineBreakMode = .byWordWrapping
        item.textColor = UIColor(named: "Texto")
        item.font = item.font.withSize(20)
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var overview: UILabel = {
        let item = UILabel()
        item.backgroundColor = .clear
        item.numberOfLines = 0
        item.lineBreakMode = .byWordWrapping
        item.textColor = UIColor(named: "Texto")
        item.font = item.font.withSize(26)
        item.textAlignment = .justified
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var viewConter: UIView = {
        let item = UIView()
        item.backgroundColor = .clear
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var viewReproductor: UIView = {
        let item = UIView()
        item.backgroundColor = .clear
        item.layer.cornerRadius = 20
        item.clipsToBounds = true
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var imagenReproductor: UIImageView = {
        let item = UIImageView()
        item.backgroundColor = .clear
        item.isHidden = false
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var imgReproducir: UIImageView = {
        let item = UIImageView()
        item.image = UIImage(systemName: "play.circle.fill")
        item.tintColor = .white
        item.isUserInteractionEnabled = true
        item.isHidden = true
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()
    
    lazy var ytPlayer: WKWebView = {
        let item = WKWebView()
        item.isUserInteractionEnabled = true
        item.backgroundColor = .clear
        item.isHidden = false
        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.constraintUI()
        imgReproducir.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.playVideo(tapGesture:)) )  )
    }
    
    @objc func playVideo(tapGesture: UITapGestureRecognizer) {
        imgReproducir.isHidden = true
        imagenReproductor.isHidden = true
    }
    
    
    var dataTrailerArray = [MovieTrailerresult]()
    var dataArray = [MovieTrailerresult]()
    var globalURLPlay = String()
    public func setImgTrailerMov(movie_ID: String) {
    let url = "https://api.themoviedb.org/3/movie/\(movie_ID)/videos?api_key=7662169d6cde796d24b257cd0f8a268e&language=en-US&page=1"
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { (data, req, error) in
            self.globalURLPlay = ""
            self.dataTrailerArray.removeAll()
            self.dataArray.removeAll()
            do {
                let result = try JSONDecoder().decode(MovieTrailer.self, from: data!)
                DispatchQueue.main.async {
                    self.dataTrailerArray = result.results
                    
                    for i in 0..<self.dataTrailerArray.count{
                        let type = result.results[i].type
                        
                        if type == "Trailer" {
                            self.dataArray = result.results
                            let imgUrlKey = self.dataArray[0].key!

                            let url = "https://i.ytimg.com/vi/\(imgUrlKey)/sddefault.jpg"
                            self.imagenReproductor.loadimagenUsandoCacheConURLString(urlString: url)
                            self.globalURLPlay = imgUrlKey
                            
                            guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(imgUrlKey)") else { return }
                            self.ytPlayer.load( URLRequest(url: youtubeURL) )
                            self.imgReproducir.isHidden = false

                        }

                    }

                }
            } catch {
                
            }
        }.resume()
    }
    
    public func setImgTrailerTV(TV_ID: String) {
        let url = apiservice.baseURLSecureString.appending("tv/\(TV_ID)/videos?api_key=7662169d6cde796d24b257cd0f8a268e&language=en-US&page=1")
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { (data, req, error) in
            self.globalURLPlay = ""
            self.dataTrailerArray.removeAll()
            self.dataArray.removeAll()
            do {
                let result = try JSONDecoder().decode(MovieTrailer.self, from: data!)

                DispatchQueue.main.async {
                    self.dataTrailerArray = result.results
                    
                    for i in 0..<self.dataTrailerArray.count{
                        let type = result.results[i].type
                        
                        if type == "Trailer" {
                            self.dataArray = result.results
                            let imgUrlKey = self.dataArray[0].key!
                            
                            let url = "https://i.ytimg.com/vi/\(imgUrlKey)/sddefault.jpg"

                            self.imagenReproductor.loadimagenUsandoCacheConURLString(urlString: url)
                            self.globalURLPlay = imgUrlKey
                            
                            guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(imgUrlKey)") else { return }
                            self.ytPlayer.load( URLRequest(url: youtubeURL) )
                            self.imgReproducir.isHidden = false

                        }

                    }

                }
            } catch {
                
            }
        }.resume()
    }
    
    public func setMov(_ data: Result) {
        let urlbackdrop = "https://image.tmdb.org/t/p/w300" + data.backdrop_path
        let urlpost = "https://image.tmdb.org/t/p/w300" + data.poster_path
                   
        imageBackgroundPath.image = nil
        imageBackgroundPath.loadimagenUsandoCacheConURLString(urlString: urlbackdrop)
        
        imagePosterPath.image = nil
        imagePosterPath.loadimagenUsandoCacheConURLString(urlString: urlpost)
        imagenReproductor.image = nil

        titulo.text = data.title
        date.text = data.release_date
        vote_average.text = String(data.vote_average) + " / " + "10"
        overview.text = "Override \n\n" + data.overview

    }
    
    public func setTV(data: Resultseries) {
        let urlbackdrop = "https://image.tmdb.org/t/p/w300" + data.backdrop_path
        let urlpost = "https://image.tmdb.org/t/p/w300" + data.poster_path
    
        imageBackgroundPath.image = nil
        imageBackgroundPath.loadimagenUsandoCacheConURLString(urlString: urlbackdrop)
    
        imagePosterPath.image = nil
        imagePosterPath.loadimagenUsandoCacheConURLString(urlString: urlpost)
        imagenReproductor.image = nil
    
        titulo.text = data.name
        date.text = data.first_air_date
        vote_average.text = String(data.vote_average) + " / " + "10"
        overview.text = "Override \n\n" + data.overview
    }
    
    public func constraintUI() {
        view.addSubview(scrollViewDetaill)
        self.scrollViewDetaill.addSubview(blurBackgroundPath)
        self.scrollViewDetaill.addSubview(imageBackgroundPath)
        self.scrollViewDetaill.addSubview(imagePosterPath)
        self.scrollViewDetaill.addSubview(titulo)
        self.scrollViewDetaill.addSubview(date)
        self.scrollViewDetaill.addSubview(vote_average)
        self.scrollViewDetaill.addSubview(viewReproductor)
        self.scrollViewDetaill.addSubview(overview)
        self.viewReproductor.addSubview(ytPlayer)
        self.viewReproductor.addSubview(imagenReproductor)
        self.viewReproductor.addSubview(imgReproducir)

        self.imageBackgroundPath.alpha = 0.35

        NSLayoutConstraint.activate([
            scrollViewDetaill.topAnchor.constraint(equalTo: view.topAnchor),
            scrollViewDetaill.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollViewDetaill.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollViewDetaill.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageBackgroundPath.topAnchor.constraint(equalTo: scrollViewDetaill.topAnchor, constant: 0),
            imageBackgroundPath.leftAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.leftAnchor, constant: 0),
            imageBackgroundPath.rightAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.rightAnchor, constant: 0),
            imageBackgroundPath.heightAnchor.constraint(equalToConstant: 230),
            
            blurBackgroundPath.topAnchor.constraint(equalTo: scrollViewDetaill.topAnchor, constant: 0),
            blurBackgroundPath.leftAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.leftAnchor, constant: 0),
            blurBackgroundPath.rightAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.rightAnchor, constant: 0),
            blurBackgroundPath.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            imagePosterPath.topAnchor.constraint(equalTo: scrollViewDetaill.topAnchor, constant: 70),
            imagePosterPath.leftAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.leftAnchor, constant: 15),
            imagePosterPath.heightAnchor.constraint(equalToConstant: 200),
            imagePosterPath.widthAnchor.constraint(equalToConstant: 130),
            
            titulo.topAnchor.constraint(equalTo: scrollViewDetaill.topAnchor, constant: 70),
            titulo.leftAnchor.constraint(equalTo: imagePosterPath.rightAnchor, constant: 20),
            titulo.rightAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            date.topAnchor.constraint(equalTo: titulo.bottomAnchor, constant: 15),
            date.leftAnchor.constraint(equalTo: imagePosterPath.rightAnchor, constant: 20),
            date.rightAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            vote_average.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 10),
            vote_average.leftAnchor.constraint(equalTo: imagePosterPath.rightAnchor, constant: 20),
            vote_average.rightAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            viewReproductor.topAnchor.constraint(equalTo: imagePosterPath.bottomAnchor, constant: 20),
            viewReproductor.leftAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.leftAnchor, constant: 15),
            viewReproductor.rightAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.rightAnchor, constant: -15),
            viewReproductor.heightAnchor.constraint(equalToConstant: 250),
            
            imagenReproductor.topAnchor.constraint(equalTo: viewReproductor.topAnchor),
            imagenReproductor.leftAnchor.constraint(equalTo: viewReproductor.leftAnchor),
            imagenReproductor.rightAnchor.constraint(equalTo: viewReproductor.rightAnchor),
            imagenReproductor.bottomAnchor.constraint(equalTo: viewReproductor.bottomAnchor),
            
            ytPlayer.topAnchor.constraint(equalTo: viewReproductor.topAnchor),
            ytPlayer.leftAnchor.constraint(equalTo: viewReproductor.leftAnchor),
            ytPlayer.rightAnchor.constraint(equalTo: viewReproductor.rightAnchor),
            ytPlayer.bottomAnchor.constraint(equalTo: viewReproductor.bottomAnchor),

            imgReproducir.centerXAnchor.constraint(equalTo: viewReproductor.centerXAnchor),
            imgReproducir.centerYAnchor.constraint(equalTo: viewReproductor.centerYAnchor),
            imgReproducir.heightAnchor.constraint(equalToConstant: 75),
            imgReproducir.widthAnchor.constraint(equalToConstant: 75),
                        
            overview.topAnchor.constraint(equalTo: viewReproductor.bottomAnchor, constant: 20),
            overview.leftAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.leftAnchor, constant: 15),
            overview.rightAnchor.constraint(equalTo: scrollViewDetaill.safeAreaLayoutGuide.rightAnchor, constant: -15),
            overview.bottomAnchor.constraint(equalTo: scrollViewDetaill.bottomAnchor, constant: -20),
            
        ])
        
    }


}
