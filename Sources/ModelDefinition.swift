/*
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import SwiftyJSON
import Foundation

public struct ModelDefinition {
    enum Error: Swift.Error {
        case invalidSchema(String)
    }
    let name: String
    let plural: String
    let className: String
    let properties: [String:PropertyDefinition]

    init(json: JSON) throws {
        if let name = json["name"].string { // TODO can't seem to guard let to assign to an instance var :(
            self.name = name
        } else {
            throw ModelDefinition.Error.invalidSchema("missing model name")
        }
        if let plural = json["plural"].string { // TODO can't seem to guard let to assign to an instance var :(
            self.plural = plural
        } else {
            // TODO maybe not throw here and instead default the plural?
            throw ModelDefinition.Error.invalidSchema("missing plural name for model '\(name)'")
        }
        if let className = json["classname"].string {
            self.className = className
        } else {
            throw ModelDefinition.Error.invalidSchema("missing class name for model '\(name)'")
        }
        var properties_: [String:PropertyDefinition] = [:]
        for (property,definition) in json["properties"].dictionaryValue {
            guard properties_[property] == nil else {
                throw ModelDefinition.Error.invalidSchema("duplicate property '\(property)' in model '\(name)'")
            }
            guard let typeName = definition["type"].string else {
                throw ModelDefinition.Error.invalidSchema("missing type for property '\(property)' in model \(name)")
            }
            guard let type = PropertyDefinition.PropertyType(rawValue: typeName) else {
                throw ModelDefinition.Error.invalidSchema("unrecognized type '\(typeName)' for property '\(property)' in model '\(name)'")
            }
            let isRequired = definition["required"].bool ?? false
            let isId = definition["id"].bool ?? false
            let defaultValue = PropertyDefinition.convertValue(fromJSON: definition["default"], to: type)
            properties_[property] = PropertyDefinition(name: property, type: type, isRequired: isRequired, isId: isId, defaultValue: defaultValue)
        }
        properties = properties_
    }
}
