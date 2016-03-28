//
//  JSONParsing.swift
//  JSONParsing
//
//  Created by Vadim Yelagin on 06/10/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import Foundation

public protocol JSONParsing {

	static func parse(json: JSON) throws -> Self

}

// JSONParsingPrimitive types get extracted directly with a type check

public protocol JSONParsingPrimitive: JSONParsing {}

public extension JSONParsingPrimitive {

	public static func parse(json: JSON) throws -> Self {
		if let object = json.object {
			if let res = object as? Self {
				return res
			} else {
				throw JSON.Error.TypeMismatch(json: json)
			}
		} else {
			throw JSON.Error.NoValue(json: json)
		}
	}

}

extension String: JSONParsingPrimitive {}

extension Bool: JSONParsingPrimitive {}

extension Int: JSONParsingPrimitive {}

extension Double: JSONParsingPrimitive {}

// JSONParsingRawString types are enums with JSONParsing-conforming RawType-s

public protocol JSONParsingRawRepresentable: RawRepresentable, JSONParsing {
	associatedtype RawValue: JSONParsing
}

public extension JSONParsingRawRepresentable {

	public static func parse(json: JSON) throws -> Self {
		if let enumVal = try Self(rawValue: json^) {
			return enumVal
		} else {
			throw JSON.Error.TypeMismatch(json: json)
		}
	}

}
