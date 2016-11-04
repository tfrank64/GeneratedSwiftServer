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

public struct PropertyDefinition {
    public enum PropertyType:String {
        case string
        case number
        case boolean
        case object
        case array
    }
    let name: String
    let type: PropertyType
    let isRequired: Bool
    let isId: Bool
    let defaultValue: Any?
    func sameTypeAs(object: Any) -> Bool {
        switch type {
        case .string: return object is String
        case .number: return object is Int || object is Float || object is Double
        case .boolean: return object is Bool
        case .object: return true
        case .array: return object is [Any] || object is [AnyObject] || object is NSArray
        }
    }
    func sameTypeAs(json: JSON) -> Bool {
        return (convertValue(fromJSON: json) != nil)
    }
    static func convertValue(fromString string: String, to type: PropertyType) -> Any? {
        switch type {
        case .string: return string
        case .number: return Int(string) ?? Float(string) ?? Double(string)
        case .boolean: return Bool(string)
        case .object: return string
        case .array: return nil
        }
    }
    static func convertValue(fromJSON json: JSON, to type: PropertyType) -> Any? {
        switch type {
        case .string:  return json.string
        case .number:  return json.number
        case .boolean: return json.bool
        case .object:  return (json.type == .dictionary ? json.object : nil)
        case .array:   return (json.type == .array      ? json.object : nil)
        }
    }
    func convertValue(fromString string: String) -> Any? {
        return PropertyDefinition.convertValue(fromString: string, to: type)
    }
    func convertValue(fromJSON json: JSON) -> Any? {
        return PropertyDefinition.convertValue(fromJSON: json, to: type)
    }
}
