//
//  Realm+Init.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/03/2023.
//

import Combine
import Foundation
import RealmSwift

extension Realm {
    static func createRealm(configuration: Realm.Configuration, queue: DispatchQueue? = nil) -> Realm {
        let realm = try! Realm(configuration: configuration, queue: queue)
        return realm
    }

    static func createRealmPublisher(configuration: Realm.Configuration = .defaultConfiguration,
                                     callbackQueue: DispatchQueue = .main) -> AnyPublisher<Realm, Swift.Error> {
        AnyPublisher<Realm, Swift.Error>.create { subscriber in
            Realm.asyncOpen(configuration: configuration, callbackQueue: callbackQueue) { result in
                switch result {
                case let .success(realm):
                    subscriber.send(realm)
                    subscriber.send(completion: .finished)
                case let .failure(failure):
                    subscriber.send(completion: .failure(failure))
                }
            }
            return AnyCancellable {}
        }
    }
}

// MARK: - RealmManagerType

protocol RealmManagerType {
    func add(_ object: Object, update: Realm.UpdatePolicy)
    func add<S: Sequence>(_ objects: S, update: Realm.UpdatePolicy) where S.Iterator.Element: Object
    func create<T: AsymmetricObject>(_ type: T.Type, value: [String: Any])
    func create<T: Object>(_ type: T.Type, value: [String: Any], update: Realm.UpdatePolicy)

    func objects<Element: RealmFetchable>(_ type: Element.Type) -> Results<Element>
    func objects<Element: RealmFetchable>(_ type: Element.Type, predicate: NSPredicate) -> Results<Element>
    func objects<Element: RealmFetchable>(_ type: Element.Type, isIncluded: (Query<Element>) -> Query<Bool>) -> Results<Element>
    func object<Element: Object, KeyType>(ofType type: Element.Type, forPrimaryKey key: KeyType) -> Element?

    func delete(_ object: Object)
    func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object
    func delete<Element: Object>(_ objects: List<Element>)
    func delete<Element: Object>(_ objects: Results<Element>)
    func deleteAll()
    func deleteFile() throws -> Bool
}

extension RealmManagerType {
    func add(_ object: Object, update: Realm.UpdatePolicy = .error) {
        add(object, update: update)
    }

    func add<S: Sequence>(_ objects: S, update: Realm.UpdatePolicy = .error) where S.Iterator.Element: Object {
        add(objects, update: update)
    }

    func create(_ type: (some AsymmetricObject).Type, value: [String: Any] = [:]) {
        create(type, value: value)
    }

    func create(_ type: (some Object).Type, value: [String: Any] = [:], update: Realm.UpdatePolicy = .error) {
        create(type, value: value, update: update)
    }
}

// MARK: - RealmManager

final class RealmManager: RealmManagerType {
    private let configurationBuilder: () -> Realm.Configuration
    private let queueBuilder: () -> DispatchQueue

    private lazy var configuration: Realm.Configuration = configurationBuilder()
    private lazy var queue: DispatchQueue = queueBuilder()
    private lazy var concurrentQueue = DispatchQueue.global(qos: .default)

    private var realm: Realm {
        Realm.createRealm(configuration: configuration)
    }

    private var realmPublisher: AnyPublisher<Realm, Error> {
        Realm.createRealmPublisher(configuration: configuration, callbackQueue: queue)
    }

    init(configuration: @autoclosure @escaping () -> Realm.Configuration,
         queue: @autoclosure @escaping () -> DispatchQueue) {
        self.configurationBuilder = configuration
        self.queueBuilder = queue
    }
}

extension RealmManager {
    @discardableResult
    private func writeAsync(_ block: @escaping (Realm) -> Void, onComplete: ((Swift.Error?) -> Void)? = nil) -> AsyncTransactionId {
        let realm = realm
        return realm.writeAsync({ block(realm) }, onComplete: onComplete)
    }

    private func delete(objects: [some Object]) {
        guard !objects.isEmpty else { return }

        let freezeObjects = objects.map { $0.freeze() }
        let block: (Realm) -> Void = { realm in
            let objects = freezeObjects.compactMap { object -> Object? in
                let objectType = type(of: object)
                guard let primaryKey = objectType.primaryKey() else {
                    return nil
                }
                let managedObject = realm.object(ofType: objectType, forPrimaryKey: object.value(forKey: primaryKey))
                return managedObject
            }
            realm.delete(objects)
        }

        writeAsync(block)
    }
}

extension RealmManager {
    func add(_ object: Object, update: Realm.UpdatePolicy = .error) {
        let freezeObject = object.isFrozen ? object.freeze() : object
        writeAsync { realm in
            realm.add(freezeObject, update: update)
        }
    }

    func add<S: Sequence>(_ objects: S, update: Realm.UpdatePolicy = .error) where S.Iterator.Element: Object {
        let freezeObjects = objects.map { $0.isFrozen ? $0.freeze() : $0 }
        writeAsync { realm in
            realm.add(freezeObjects, update: update)
        }
    }

    func create(_ type: (some AsymmetricObject).Type, value: [String: Any] = [:]) {
        writeAsync { realm in
            realm.create(type, value: value)
        }
    }

    func create(_ type: (some Object).Type, value: [String: Any] = [:], update: Realm.UpdatePolicy = .error) {
        writeAsync { realm in
            realm.create(type, value: value, update: update)
        }
    }
}

extension RealmManager {
    func objects<Element: RealmFetchable>(_ type: Element.Type) -> Results<Element> {
        realm.objects(type)
    }

    func objects<Element: RealmFetchable>(_ type: Element.Type, predicate: NSPredicate) -> Results<Element> {
        realm.objects(type).filter(predicate)
    }

    func objects<Element: RealmFetchable>(_ type: Element.Type, isIncluded: (Query<Element>) -> Query<Bool>) -> Results<Element> {
        realm.objects(type).where(isIncluded)
    }

    func object<Element: Object>(ofType type: Element.Type, forPrimaryKey key: some Any) -> Element? {
        realm.object(ofType: type, forPrimaryKey: key)
    }
}

extension RealmManager {
    func delete(_ object: Object) {
        delete(objects: [object])
    }

    func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        delete(objects: Array(objects))
    }

    func delete(_ objects: List<some Object>) {
        delete(objects: Array(objects))
    }

    func delete(_ objects: Results<some Object>) {
        delete(objects: Array(objects))
    }

    func deleteAll() {
        writeAsync { realm in
            realm.deleteAll()
        }
    }

    func deleteFile() throws -> Bool {
        try Realm.deleteFiles(for: configuration)
    }
}
