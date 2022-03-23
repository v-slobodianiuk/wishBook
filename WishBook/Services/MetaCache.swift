//
//  MetaCache.swift
//  WishBook
//
//  Created by Vadym on 22.06.2021.
//

import Foundation
import LinkPresentation

struct MetaCache {

    static func cache(metadata: LPLinkMetadata) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: metadata, requiringSecureCoding: true)
            UserDefaults.standard.setValue(data, forKey: metadata.url!.absoluteString)
        } catch let error {
            print("Error when cachine: \(error.localizedDescription)")
        }
    }

    static func retrieve(urlString: String) -> LPLinkMetadata? {
        do {
            if let data = UserDefaults.standard.object(forKey: urlString) as? Data,
                  let metadata = try NSKeyedUnarchiver.unarchivedObject(ofClass: LPLinkMetadata.self, from: data) {
                return metadata
            } else {
                return nil
            }
        } catch let error {
            print("Error when cachine: \(error.localizedDescription)")
            return nil
        }
    }
}
