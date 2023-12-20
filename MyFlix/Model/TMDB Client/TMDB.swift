//
//  TMDB.swift
//  MyFlix
//
//  Created by Naji Kanounji on 10/28/23.
//

import Foundation

class TMDB {
    
    //    Create a new request token
    //    Get the user to authorize the request token
    //    Create a new session id with the authorized request token
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        static let requestToken = "/authentication/token/new"
        static let sessionWithLogin = "/authentication/token/validate_with_login"
        static let session_id = "/authentication/session/new"
        static let log_out = "authentication/session"
        //        static let favoriteList = "/account/0/favorite/movie"
        //        static let NowPlaying = "/"
        
        case getRequestToken
        case createSessionId
        case login
        case getFavList(String)
        case getWatchList(String)
        case posterImageUrl(String)
        case search(String)
        case credits(String, String)
        case personDetail(String)
        case addToFavorite
        case movieMain(String, String)
        case account
        case userLists
        case logout
        
        
        var stringValue: String {
            switch self {
            case .getRequestToken: return  Endpoints.base + Endpoints.requestToken + Endpoints.apiKeyParam
            case .createSessionId: return Endpoints.base + Endpoints.session_id + Endpoints.apiKeyParam
            case .login: return Endpoints.base + Endpoints.sessionWithLogin + Endpoints.apiKeyParam
            case .getFavList(let type): return Endpoints.base + "/account/\(TMDBClient.Auth.accountId)/favorite/\(type)" + Endpoints.apiKeyParam + "&session_id=\(TMDBClient.Auth.sessionId)"
            case .getWatchList(let type): return Endpoints.base + "/account/\(TMDBClient.Auth.accountId)/watchlist/\(type)" + Endpoints.apiKeyParam + "&session_id=\(TMDBClient.Auth.sessionId)"
            case .posterImageUrl(let path): return "https://image.tmdb.org/t/p/w500/\(path)"
            case .search(let query): return Endpoints.base + "/search/multi" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            case .credits(let type, let id): return Endpoints.base + "/\(type)/\(id)/credits" + Endpoints.apiKeyParam + "&session_id=\(TMDBClient.Auth.sessionId)"
            case .personDetail(let id): return Endpoints.base + "/person/\(id)" + Endpoints.apiKeyParam + "&session_id=\(TMDBClient.Auth.sessionId)"
            case .addToFavorite: return Endpoints.base + "/account/\(TMDBClient.Auth.accountId)" + "/favorite" + Endpoints.apiKeyParam + "&session_id=\(TMDBClient.Auth.sessionId)"
                //MovieMainCall-> sort_by=now_playing || popular || top_rated
            case .movieMain(let type,let sort_by): return Endpoints.base + "/\(type)/\(sort_by)" + Endpoints.apiKeyParam + "&session_id=\(TMDBClient.Auth.sessionId)" + "&language=en-US&page=1"
            case .account: return Endpoints.base + "/account"  + Endpoints.apiKeyParam + "&session_id=\(TMDBClient.Auth.sessionId)"
            case .userLists: return Endpoints.base + "/account/\(TMDBClient.Auth.accountId)/lists"  + Endpoints.apiKeyParam + "&session_id=\(TMDBClient.Auth.sessionId)"
            case .logout: return Endpoints.base + Endpoints.log_out + Endpoints.apiKeyParam

            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    enum MovieSortedBy {
        case nowPlaying
        case popular
        case topRated
        case onTheAir   //justForTV
        
        var stringValue: String {
            switch self {
            case .nowPlaying: return "now_playing"
            case .popular: return "popular"
            case .topRated: return "top_rated"
            case .onTheAir: return "on_the_air"
                
            }
        }
    }
    
    //return URLSessionTask to be easy to canceled,
    //so whenever you call this action you have access to this session task you can cancel it
    class func search(query: String, completion: @escaping ([MultiTypeMediaResponse], Error?) -> Void) -> URLSessionTask {
        let task =  URLSession.shared.dataTask(with: Endpoints.search(query).url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    print(error)
                    
                    completion([], error)
                }
                return
                
            }
            print(String(data: data, encoding: .utf8))
            do {
                let jsonObject = try JSONDecoder().decode(MultiTypeMediaListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonObject.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
        return task
        
    }
    
    class func downloadPosterImage(posterPath: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = Endpoints.posterImageUrl(posterPath).url
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(data,nil)
            }
        }
        task.resume()
    }
    
    class func getRequestToken(completion: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getRequestToken.url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    
                    completion(false, error)
                }
                return
                
            }
            do {
                let jsonObject = try JSONDecoder().decode(RequestTokenResponse.self, from: data)
                TMDBClient.Auth.requestToken = jsonObject.requestToken
                DispatchQueue.main.async {
                    
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func login(userName: String, password: String, completion: @escaping(Bool, Error?) -> Void) {
        let body = LoginRequest(userName: userName, password: password, requestToken: TMDBClient.Auth.requestToken)
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("loginError:", error)
                completion(false, error)
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(RequestTokenResponse.self, from: data)
                
                TMDBClient.Auth.requestToken = jsonResponse.requestToken // this one is authorized request token
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(requestToken: TMDBClient.Auth.requestToken)
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("loginError:", error)
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            do {
                let jsonResponse = try JSONDecoder().decode(SessionResponse.self, from: data)
                TMDBClient.Auth.sessionId = jsonResponse.sessionId
                
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func getFavoriteList(mediaType: String, completion: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getFavList(mediaType).url) { data, response, error in
            guard let data = data else {
                print(error)
                completion(false, error)
                return
            }
            //DEBUGGING
            //                let string = String(data: data, encoding: .utf8)
            //                        print(string)
            
            do {
                let jsonObject = try JSONDecoder().decode(MultiTypeMediaListResponse.self, from: data)
                if (mediaType == "movies") {
                    MovieData.favList = jsonObject.results
                } else if (mediaType == "tv") {
                    MovieData.favTVList = jsonObject.results
                }
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func getWatchList(mediaType: String, completion: @escaping(Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchList(mediaType).url) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            do {
                let jsonObject = try JSONDecoder().decode(MultiTypeMediaListResponse.self, from: data)
                if (mediaType == "movies") {
                    MovieData.movieWatchList = jsonObject.results
                } else if (mediaType == "tv") {
                    MovieData.tvWatchList = jsonObject.results
                }
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    let string = String(data: data, encoding: .utf8)
                    print(string ?? "error")
                    print(error.localizedDescription)
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func getMediaCredits(mediaType: String, mediaID:String, completion: @escaping(MovieCreditResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.credits(mediaType, mediaID).url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let jsonObject = try JSONDecoder().decode(MovieCreditResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(jsonObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    let string = String(data: data, encoding: .utf8)
                    //                    print(string ?? "error")
                    print(error.localizedDescription)
                    completion(nil, error)
                    
                }
            }
        }
        task.resume()
    }
    
    class func getPersonDetails(personID: String, completion: @escaping (ActorDetailResponse?, Error?) -> Void)
    {
        let task = URLSession.shared.dataTask(with: Endpoints.personDetail(personID).url) { data, response, error in
            
            guard let data = data else{
                print(error)
                completion(nil, error)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ActorDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    let string = String(data: data, encoding: .utf8)
                    print(string ?? "error")
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    //mark Movie/TV as favorite
    class func markFavorite(mediaType: String, mediaID: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let body = MarkFavoriteRequest(mediaType: mediaType, mediaId: mediaID, favorite: favorite)
        var request = URLRequest(url: Endpoints.addToFavorite.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(TMDBResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.statusCode == 1 || responseObject.statusCode == 12 || responseObject.statusCode == 13, nil)                    
                }
                //returned statusCode, 1=Success, 12=item updated Successfully, 13=item deleted Successfully
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
        }
        task.resume()
    }
    
    //CompletionHandler should be the jsonObject because this function is for multi options (sortedBy), and handle each result separately
    
    class func getMediaMain (mediaType: String, sortedBy: String, completion: @escaping (MultiTypeMediaListResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.movieMain(mediaType,sortedBy).url) { data, response, error in
            guard let data = data else {
                print(error)
                completion(nil,error)
                return
            }
            do {
                let jsonObject = try JSONDecoder().decode(MultiTypeMediaListResponse.self , from: data)
                completion(jsonObject, nil)
            } catch {
                let string = String(data: data, encoding: .utf8)
                print(string ?? "error")
                print(error.localizedDescription)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func getAccountInfo(completion: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: TMDB.Endpoints.account.url) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            //            let string = String(data: data, encoding: .utf8)
            //            print(string)
            do {
                let jsonObject = try JSONDecoder().decode(ProfileResponse.self, from: data)
                DispatchQueue.main.async {
                    TMDBClient.profileInfo = jsonObject
                    completion(true,nil)
                }
            } catch {
                print(error.localizedDescription)
                completion(false, error)
            }
        }
        task.resume()
    }
    
    class func getAccountLists(completion: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: TMDB.Endpoints.userLists.url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let string = String(data: data, encoding: .utf8)
            print(string)
            do {
                let jsonData = try JSONDecoder().decode(UserListsResponse.self, from: data)
                DispatchQueue.main.async {
                    MovieData.userLists = jsonData.results
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    let string = String(data: data, encoding: .utf8)
                    print(string)
                    completion(false,error)
                }
            }
        }
        task.resume()
    }
    
    class func deleteSessionId(completion: @escaping() -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LogoutRequest(session_id: TMDBClient.Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            TMDBClient.Auth.sessionId = ""
            TMDBClient.Auth.requestToken = ""
            DispatchQueue.main.async {
                completion()
                
            }
        }
        
        task.resume()
    }
}


