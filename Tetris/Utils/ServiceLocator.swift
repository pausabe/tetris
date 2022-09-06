//
//  ServiceLocator.swift
//  Tetris
//
//  Created by Pau Sabé Martínez on 6/9/22.
//

class ServiceLocator {

    static let shared = ServiceLocator()
    private init(){}
    
    private lazy var services: [String: AnyObject] = [:]

    func addService<T>(service: T) {
        let serviceKey = "\(type(of: service))"
        services[serviceKey] = service as AnyObject
    }

    func getService<T>() -> T? {
        var serviceKey = "\(T.self)"
        serviceKey = serviceKey.replacingOccurrences(of: "Protocol", with: "")
        return services[serviceKey] as? T
    }
}
