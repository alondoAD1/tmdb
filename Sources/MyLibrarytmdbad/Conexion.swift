//
//  Conexion.swift
//  tmdbtest
//
//  Created by A on 06/12/21.
//

import Foundation
import Network


public class Conexion {
    public init() {}
    
    public typealias conexionComplet = (_ success: Bool) -> Void

    public func monitorNetwork(completion: @escaping conexionComplet) {
        let mon: NWPathMonitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        mon.pathUpdateHandler = { p in
            if p.status == .satisfied {
                DispatchQueue.main.async {
                    print("Satisfied") // add animation connection
                    completion(false)
                }
            } else if p.status == .requiresConnection {
                DispatchQueue.main.async {
                    print("Requires Connection") // add animation no connection
                    completion(true)

                }
            } else if p.status == .unsatisfied {
                DispatchQueue.main.async {
                    print("Unsatisfied") // add animation no connection
                    completion(true)

                }
            } else {
                DispatchQueue.main.async {
                    print("Unknown") // add animation no connection
                    completion(true)
                }
            }
        }
        mon.start(queue: queue)

        
    }


     
}
