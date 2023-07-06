//
//  NewsFeedService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//
// Helpful Source: https://nsscreencast.com/episodes/390-podcast-app-parsing-feeds

import Foundation
import FeedKit

class RssArticle: Identifiable {
    let id = UUID()
    var title: String
    var description: String?
    var link: URL
    var imageLink: URL?
    var publishDate: Date

    init(title: String, description: String? = nil, link: URL, imageLink: URL?, publishDate: Date) {
        self.title = title
        self.description = description
        self.link = link
        self.imageLink = imageLink
        self.publishDate = publishDate
    }
}

enum RssArticleLoadingError : Error {
    case dataTaskFailed(Error)
    case networkingError(Error)
    case requestFailed(Int)
    case serverError(Int)
    case notFound
    case feedParsingError(Error)
    case missingAttribute(String)
    case recievedJsonError
    case recievedAtomError
    case shouldNeverOccurError
}

class NewsFeedService: NewsFeedRepository {
    let fetchUrl: URL

    init(fetchUrl: URL) {
        self.fetchUrl = fetchUrl
    }

    func fetch(feed: URL, completion: @escaping (Swift.Result<[RssArticle], RssArticleLoadingError>) -> Void) {

        // TODO: Look into a cache policy that tries to check HEAD. If request for HEAD does not work issue an error that there is a connection problem
        // and then load the cached data. Oherwise then request for the data if, according to the HEAD response, it changed from the cached data already loaded.
        // If the HEAD response says the cached data is the same as on the server than just load the cached data.
        let req = URLRequest(url: feed, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)

        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.dataTaskFailed(error)))
                }
                return
            }

            let http = response as! HTTPURLResponse
            switch http.statusCode {
            case 200:
                if let data = data {
                    self.loadFeed(data: data, completion: completion)
                }

            case 404:
                DispatchQueue.main.async {
                    completion(.failure(.notFound))
                }

            case 500...599:
                DispatchQueue.main.async {
                    completion(.failure(.serverError(http.statusCode)))
                }
            default:
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(http.statusCode)))
                }
            }
        }.resume()
    }

    private func loadFeed(data: Data, completion: @escaping (Swift.Result<[RssArticle], RssArticleLoadingError>) -> Void) {
        let parser = FeedParser(data: data)
        parser.parseAsync { parseResult in

            let result: Swift.Result<[RssArticle], RssArticleLoadingError>
            do {
                switch parseResult {
                case .success(let success):
                    switch success {
                    case .atom(_):
                        result = .failure(.recievedAtomError)
//                        result = try .success(self.convert(atom: atom))
                    case .rss(let rss):
                        result = try .success(self.convert(rss: rss))
                    case .json(_):
                        result = .failure(.recievedJsonError)
                    }
                case .failure(let error):
                    result = .failure(.feedParsingError(error))
                }
            } catch let error as RssArticleLoadingError {
                result = .failure(error)
            } catch {
                result = .failure(.shouldNeverOccurError)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func convert(rss: RSSFeed) throws -> [RssArticle] {
        guard let items = rss.items else { throw RssArticleLoadingError.missingAttribute("rss items") }
        var articles = [RssArticle]()
        for item in items {
            guard let title = item.title else { throw RssArticleLoadingError.missingAttribute("title")  }
            guard let linkString = item.link, let link = URL(string: linkString) else { throw RssArticleLoadingError.missingAttribute("link") }
            guard let publishDate = item.pubDate else { throw RssArticleLoadingError.missingAttribute("pubDate") }
            let description = item.description
            let imageLink = URL(string: item.enclosure?.attributes?.url ?? "")

            let article = RssArticle(title: title, description: description, link: link,
                                     imageLink: imageLink, publishDate: publishDate)
            articles.append(article)
        }

        return articles
    }
}
