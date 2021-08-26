//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Nicolò Pasini on 26/08/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

internal struct FeedImageMapper: Decodable {
	private static var OK_200: Int { return 200 }

	private struct Root: Decodable {
		let items: [Image]

		var images: [FeedImage] {
			return items.map { $0.image }
		}
	}

	private struct Image: Decodable {
		private enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case url = "image_url"
			case location = "image_loc"
			case description = "image_desc"
		}

		let id: UUID
		let url: URL
		let location: String?
		let description: String?

		var image: FeedImage {
			return FeedImage(id: id, description: description, location: location, url: url)
		}
	}

	internal static func map(data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == FeedImageMapper.OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(root.images)
	}
}
