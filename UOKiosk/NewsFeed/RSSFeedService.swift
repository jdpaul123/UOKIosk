//
//  RSSFeedService.swift
//  UOKiosk
//
//  Created by Jonathan Paul on 6/27/23.
//
// Helpful Source: https://nsscreencast.com/episodes/390-podcast-app-parsing-feeds

import Foundation
import FeedKit

class RssArticle  {
    var title: String?
    var description: String?
    var link: URL?
}

enum RssArticleLoadingError : Error {
    case networkingError(Error)
    case requestFailed(Int)
    case serverError(Int)
    case notFound
    case feedParsingError(Error)
    case missingAttribute(String)
    case recievedJsonError(String)
    case shouldNeverOccurError
}

class RSSFeedService {
    static let feedUrl = URL(string: "https://www.dailyemerald.com/search/?f=rss&t=article&c=news&l=50&s=start_time&sd=desc")!

    func fetch(feed: URL, completion: @escaping (Swift.Result<[RssArticle], RssArticleLoadingError>) -> Void) {

        let req = URLRequest(url: feed, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)

        URLSession.shared.dataTask(with: req) { data, response, error in
            if let _ = error {
                DispatchQueue.main.async {
                    // TODO: Show Error on UI in banner
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
                    case .atom(let atom):
                        result = try .success(self.convert(atom: atom))
                    case .rss(let rss):
                        result = try .success(self.convert(rss: rss))
                    case .json(_):
                        result = .failure(.recievedJsonError("Should not have got json back"))
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

    private func convert(atom: AtomFeed) throws -> [RssArticle] {
        guard let entries = atom.entries else { throw RssArticleLoadingError.missingAttribute("atom entries") }
        var articles = [RssArticle]()
        for entry in entries {
            guard let title = entry.title else { throw RssArticleLoadingError.missingAttribute("title")  }
            let description = entry.summary?.value
            guard let links = entry.links, links.count > 0 else { throw RssArticleLoadingError.missingAttribute("links") }
            guard let link: URL = URL(string: links[0].attributes?.href ?? "") else { throw RssArticleLoadingError.missingAttribute("link") }

            let article = RssArticle()
            article.title = title
            article.description = description
            article.link = link
            articles.append(article)
        }

        return articles
    }

    private func convert(rss: RSSFeed) throws -> [RssArticle] {
        guard let items = rss.items else { throw RssArticleLoadingError.missingAttribute("rss items") }
        var articles = [RssArticle]()
        for item in items {
            guard let title = item.title else { throw RssArticleLoadingError.missingAttribute("title")  }
            let description = item.description
            guard let linkString = item.link, let link = URL(string: linkString) else { throw RssArticleLoadingError.missingAttribute("link") }
            let article = RssArticle()
            article.title = title
            article.description = description
            article.link = link
            articles.append(article)
        }

        return articles
    }
}
