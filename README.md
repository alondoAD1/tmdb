# MyLibrarytmdbad

A description of this package.

Intalar con Swift Package manager desde branch "main"

iOS target: v13.0

import MyLibrarytmdbad

Declaraciones

    let apiservice      = ApiService()
    let serverdataMov   = ServerDataMov()
    let serverdataTV    = ServerDataTVShow()

Obtenemos dos tipos de listas

    Movies y TVSeries
        serverdataMov
        serverdataTV

Para obtener los datos mandamos llamar la funcion dependiendo de la informacion que queramos

    Movies
        getAllMovFavoritas
        getAllMovRecomendacion
        getAllMovPopular

    TVSeries
        getAllTVFavoritas
        getAllTVRecomendacion
        getAllTVPopular


Ejemplo para ver la descripción/informacion de cada película o serie. En este caso es para Movies

        apiservice.Apirequest { success, error in
            if success {
                self.serverdataMov.getAllMovPopular { success, error, modeldata in
                    if success {
                        DispatchQueue.main.sync {
                            let VC = DetailsViewController()
                            VC.setImgTrailerMov(movie_ID: String(modeldata[5].id))
                            VC.setMov(modeldata[5])
                            self.present(VC, animated: true, completion: nil)
                        }
                    } else { print("msn error: ", error) }
                }
            } else { print("msn error: ", error) }
        }
        
        
Para verificar la conexión 

        Conexion().monitorNetwork { success in
            if success { self.view.backgroundColor = .red }
            else { self.view.backgroundColor = .white }
        }

Si quieres eliminar los datos 

    @objc func deleteDatos() {
        Storage.deleteStorage()
    }
    
