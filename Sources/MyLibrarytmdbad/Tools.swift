//
//  imageURL.swift
//  GoNet Examen
//
//  Created by A on 26/11/21.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    public func loadimagenUsandoCacheConURLString(urlString: String){
        
        self.image = nil
        if let cacheImagen = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cacheImagen
            return
            
        }
    
    let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                
                if error != nil {
                    print(error as Any)
                    return
                }
                
                DispatchQueue.main.async {
                    if let imageDescargada = UIImage(data: data){
                        imageCache.setObject(imageDescargada, forKey: urlString as AnyObject)
                        self.image = imageDescargada
                    }
                }
            }
        }
        task.resume()
    
    
    }
    
}

