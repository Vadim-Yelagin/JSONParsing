//
//  JSON.swift
//  JSONParsing
//
//  Created by Vadim Yelagin on 06/10/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import Foundation

public final class JSON {

	public enum Error: ErrorType {
		case NoValue(json: JSON)
		case TypeMismatch(json: JSON)
	}

	public struct ValidationError: ErrorType {
		public init(json: JSON, message: String?) {
			self.json = json
			self.message = message
		}
		public let json: JSON
		public let message: String?
	}

	public let parentLink: (JSON, String)?
	public let object: AnyObject?

	public init(_ object: AnyObject?) {
		self.object = object
		self.parentLink = nil
	}

	public init(_ object: AnyObject?, parent: JSON, key: String) {
		self.object = object
		self.parentLink = (parent, key)
	}

	public var pathFromRoot: String {
		if let (parent, key) = self.parentLink {
			return "\(parent.pathFromRoot)/\(key)"
		} else {
			return ""
		}
	}

	public subscript(key: String) -> JSON {
		let value = (object as? NSDictionary)?[key]
		return JSON(value, parent: self, key: key)
	}

	public var array: [JSON] {
		if let arr = object as? [AnyObject] {
			return arr.enumerate().map {
				idx, item in
				JSON(item, parent: self, key: "\(idx)")
			}
		} else {
			return [self]
		}
	}

	public var optional: JSON? {
		if object == nil || object is NSNull {
			return nil
		} else {
			return self
		}
	}

	public func parse<T: JSONParsing>() throws -> T {
		return try T.parse(self)
	}

}

postfix operator ^ { }

public postfix func ^ <T: JSONParsing> (json: JSON) throws -> T {
	return try json.parse()
}
