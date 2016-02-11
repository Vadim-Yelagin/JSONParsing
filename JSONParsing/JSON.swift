//
//  JSON.swift
//  JSONParsing
//
//  Created by Vadim Yelagin on 06/10/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import Foundation

final class JSON {

	enum Error: ErrorType {
		case NoValue(json: JSON)
		case TypeMismatch(json: JSON)
	}

	struct ValidationError: ErrorType {
		let message: String?
	}

	let parentLink: (JSON, String)?
	let object: AnyObject?

	init(_ object: AnyObject?) {
		self.object = object
		self.parentLink = nil
	}

	init(_ object: AnyObject?, parent: JSON, key: String) {
		self.object = object
		self.parentLink = (parent, key)
	}

	var pathFromRoot: String {
		if let (parent, key) = self.parentLink {
			return "\(parent.pathFromRoot)/\(key)"
		} else {
			return ""
		}
	}

	subscript(key: String) -> JSON {
		let value = (object as? NSDictionary)?[key]
		return JSON(value, parent: self, key: key)
	}

	var array: [JSON] {
		if let arr = object as? [AnyObject] {
			return arr.enumerate().map {
				idx, item in
				JSON(item, parent: self, key: "\(idx)")
			}
		} else {
			return [self]
		}
	}

	var optional: JSON? {
		if object == nil || object is NSNull {
			return nil
		} else {
			return self
		}
	}

	func parse<T: JSONParsing>() throws -> T {
		return try T.parse(self)
	}

}

postfix operator ^ { }

postfix func ^ <T: JSONParsing> (json: JSON) throws -> T {
	return try json.parse()
}
