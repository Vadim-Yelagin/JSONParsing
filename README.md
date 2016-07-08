# JSONParsing [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Usage example:

	struct Page<T: JSONParsing> {
		var page: Int = 0
		var pageSize: Int = 0
		var total: Int = 0
		var previous: String?
		var next: String?
		var content: [T] = []
	}

	extension Page: JSONParsing {
		static func parse(json: JSON) throws -> Page {
			return try Page(
				page: json["page"]^,
				pageSize: json["pageSize"]^,
				total: json["total"]^,
				previous: json["previous"].optional.map(^),
				next: json["next"].optional.map(^),
				content: json["content"].array.map(^)
			)
		}
	}
	
	
