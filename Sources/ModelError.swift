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

enum ModelError: Error {
    case requiredPropertyMissing(name: String)
    case extraneousProperty(name: String)
    case propertyTypeMismatch(name: String, type: String, value: String, valueType: String)
    func defaultMessage() -> String {
        switch self {
        case let .requiredPropertyMissing(name): return "Required property \(name) not provided"
        case let .extraneousProperty(name):      return "Property \(name) not found"
        case let .propertyTypeMismatch(name, type, value, valueType):
            return "Provided value (\(value)) for property '\(name)' has type (\(valueType))" +
                   " which is not compatible with the property type (\(type))"
        }
    }
}
