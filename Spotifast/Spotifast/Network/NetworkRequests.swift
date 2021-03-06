//
//  NetworkRequests.swift
//  Spotifast
//  Created by Mohammed Drame on 12/12/20.

import Foundation

public enum HTTPMethod: String {
    case get, post, put, delete
}

enum Header {
    case GETHeader(accessToken: String)
    case POSTHeader
    
    func buildHeader() -> [String:String] {
        switch self {
        case .GETHeader (let accessToken):
            return ["Accept": "application/json",
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(accessToken)"
            ]
        case .POSTHeader:
            let SPOTIFY_API_AUTH_KEY = "Basic \((Key.SPOTIFY_API_CLIENT_ID + ":" + Key.SPOTIFY_API_CLIENT_SECRET).data(using: .utf8)!.base64EncodedString())"
            return ["Authorization": SPOTIFY_API_AUTH_KEY,
                    "Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}

enum EndingPath {
    case userInfo
    case userFavoriteArtists(type: UserFavoriteAristTypes)
    case artist(id: String)
    case artists(ids: [String])
    case artistTopTracks(artistId: String, country: Country)
    case search(q: String, type: SpotifyCaseTypes)
    case playlist(id: String)
    case tracks(ids: [String])
    case token
    
    func buildPath() -> String {
        switch self {
        case .token:
            return "token"
            
        case .userInfo:
            return "me"
            
        case .userFavoriteArtists(let type):
            return "user/top/\(type)"
            
        case .artist(let id):
            return "artist/\(id)"
            
        case .artists (let ids):
            return "artists&ids=\(ids.joined(separator: ","))"
            
        case .search(let q, let type):
            let convertSpacesToProperURL = q.replacingOccurrences(of: " ", with: "%20")
            return "search?q=\(convertSpacesToProperURL)&type=\(type)"
            
        case .artistTopTracks(let id, let country):
            return "artists/\(id)/top-tracks?country=\(country)"
            
        case .playlist (let id):
            return "playlists/\(id)"
            
        case .tracks(let ids):
            return "tracks/?ids=\(ids.joined(separator: ","))"
        }
    }
}

struct BasicRequestBuilder: RequestBuilder {
    var method: HTTPMethod
    var headers: [String: String] = [:]
    var baseURL: String
    var path: String
    var params: [String:Any]?
}

struct APIClient {
    
    private let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        session = URLSession(configuration: configuration)
    }
    
    public func call(request: NetworkRequest) {
        let urlRequest = request.builder.toURLRequest()
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            let result: Result<Data, Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(data ?? Data())
            }
            
            DispatchQueue.main.async {
                request.completion(result)
            }
        }.resume()
    }
    
    internal func getSpotifyAccessCodeURL() -> URL {
        
        let paramDictionary = ["client_id" : Key.SPOTIFY_API_CLIENT_ID,
                               "redirect_uri" : Key.REDIRECT_URI,
                               "response_type" : Key.RESPONSE_TYPE,
                               "scope" : Key.USER_SCOPES.joined(separator: "%20")
        ] as [String : Any]
        
        let mapToHTMLQuery = paramDictionary.map { key, value in
            
            return "\(key)=\(value)"
        }
        
        let stringQuery = mapToHTMLQuery.joined(separator: "&")
        let accessCodeBaseURL = "https://accounts.spotify.com/authorize"
        let fullURL = URL(string: accessCodeBaseURL.appending("?\(stringQuery)"))
        
        return fullURL!
    }
    
}

public protocol RequestBuilder {
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var baseURL: String { get }
    var path: String { get }
    var params: [String:Any]? { get }
    
    func toURLRequest() -> URLRequest
}

public extension RequestBuilder {
    
    func toURLRequest() -> URLRequest {
        
        let fullURL = URL(string: baseURL + path)
        var request = URLRequest(url: fullURL!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue.uppercased()
        
        if let params = params {
            if var components = URLComponents(url: fullURL!, resolvingAgainstBaseURL: false)  {
                components.queryItems = [URLQueryItem]()
                
                for (key, value) in params {
                    let queryItem = URLQueryItem(name: key, value: "\(value)")
                    components.queryItems?.append(queryItem)
                }
                request.url = components.url
            }
        }
        return request
    }
}

struct NetworkRequest {
    let builder: RequestBuilder
    let completion: (Result<Data, Error>) -> Void
    
    static func buildRequest(method: HTTPMethod, header: [String:String], baseURL: String, path: String, params: [String:Any]?=nil, completion: @escaping (Result<Data, Error>) -> Void) -> NetworkRequest {
        
        let builder = BasicRequestBuilder(method: method, headers: header, baseURL: baseURL, path: path, params: params)
        
        return NetworkRequest(builder: builder, completion: completion)
    }
    
    static func verifyAccessToken(code: String, completion: @escaping (Result<Tokens, Error>) -> Void) -> NetworkRequest {
        
        NetworkRequest.buildRequest(method: .post,
                                    header: Header.POSTHeader.buildHeader(),
                                    baseURL: SpotifyURL.authBaseURL.rawValue,
                                    path: EndingPath.token.buildPath(),
                                    params: Parameters.tokenCode(accessCode: code).buildParameters()) { (result) in
            
            result.decoding(Tokens.self, completion: completion)
        }
    }
    static func refreshAccessToken(completion: @escaping (Result<Tokens, Error>) -> Void) -> NetworkRequest? {
        
        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else {return nil}
        
        return NetworkRequest.buildRequest(method: .post,
                                           header: Header.POSTHeader.buildHeader(),
                                           baseURL: SpotifyURL.authBaseURL.rawValue,
                                           path: EndingPath.token.buildPath(),
                                           params: Parameters.buildParameters(.tokenRefreshCode(refreshToken: refreshToken))()) { result in
            result.decoding(Tokens.self, completion: completion)
        }
        
    }
    
    static func verifyExpiredToken(token: String, completion: @escaping (Result<ExpiredToken, Error>) -> Void) -> NetworkRequest {
        
        NetworkRequest.buildRequest(method: .get,
                                    header: Header.GETHeader(accessToken: token).buildHeader(),
                                    baseURL: SpotifyURL.APICallBase.rawValue,
                                    path: EndingPath.userInfo.buildPath()) { (result) in
            
            result.decoding(ExpiredToken.self, completion: completion)
        }
    }
    
    static func getFavoriteUserArtists(token: String, completions: @escaping (Result<UserFavoriteArtists, Error>) -> Void) -> NetworkRequest {
        let apiClient = APIClient(configuration: URLSessionConfiguration.default)
        
        apiClient.call(request: .verifyExpiredToken(token: token, completion: { (expiredToken) in
            switch expiredToken {
            case .failure(_):
                print("token still valid")
            case .success(_):
                print("token expired")
                apiClient.call(request: refreshAccessToken(completion: { (refreshToken) in
                    switch refreshToken {
                    case .failure(_):
                        print("no refresh token returned")
                    case .success(let refresh):
                        //print(refresh.accessToken)
                        UserDefaults.standard.set(refresh.accessToken, forKey: "token")
                        apiClient.call(request: .getFavoriteUserArtists(token: refresh.accessToken, completions: completions))
                    //                        print("Call",SpotifyURL.APICallBase.rawValue)
                    //                        print("END",EndingPath.userFavoriteArtists(type: .artists).buildPath())
                    
                    }
                })!)
            }
        }))
        
        let urlString = "https://api.spotify.com/v1/me/top/artists"
        let session = URLSession.shared
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        session.dataTask(with: request as URLRequest){ data, response, error in
            
            if let responseData = data
            {
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                }catch{
                    print("Could not serialize")
                }
            }
            
        }.resume()
        
        
        return NetworkRequest.buildRequest(method: .get,
                                           header: Header.GETHeader(accessToken: token).buildHeader(),
                                           baseURL: SpotifyURL.APICallBase.rawValue,
                                           path: EndingPath.userFavoriteArtists(type: .artists).buildPath(),
                                           params:Parameters.durationOfTime(range:"time_range").buildParameters()) { (result) in
            result.decoding(UserFavoriteArtists.self, completion: completions)
            
        }
        
    }
    
    static func getFavoriteUserSongs(ids: [String], token: String, completions: @escaping (Result<ArtistTopSongs, Error>) -> Void) -> NetworkRequest {
        
        let apiClient = APIClient(configuration: URLSessionConfiguration.default)
        
        apiClient.call(request: .verifyExpiredToken(token: token, completion: { (expiredToken) in
            switch expiredToken {
            case .failure(_):
                print("token is valid")
            case .success(_):
                print("token expired")
                apiClient.call(request: refreshAccessToken(completion: { (refreshToken) in
                    switch refreshToken {
                    case .failure(_):
                        print("no refresh token returned")
                    case .success(let refresh):
                        UserDefaults.standard.set(refresh.accessToken, forKey: "token")
                        apiClient.call(request: .getFavoriteUserSongs(ids: ids, token: refresh.accessToken, completions: completions))
                    }
                })!)
            }
        }))
        
        return NetworkRequest.buildRequest(method: .get,
                                           header: Header.GETHeader(accessToken: token).buildHeader(),
                                           baseURL: SpotifyURL.APICallBase.rawValue,
                                           path: EndingPath.tracks(ids: ids).buildPath(), params: Parameters.durationOfTime(range: "time_range").buildParameters()) {
            (result) in
            
            result.decoding(ArtistTopSongs.self, completion: completions)
            
        }
        
    }
    
    static func getArtistPlaylist(token: String, playlistId: String, completions: @escaping (Result<Playlist, Error>) -> Void) -> NetworkRequest {
        
        let apiClient = APIClient(configuration: URLSessionConfiguration.default)
        
        apiClient.call(request: .verifyExpiredToken(token: token, completion: { (expiredToken) in
            switch expiredToken {
            case .failure(_):
                print("token still valid")
            case .success(_):
                print("token expired")
                apiClient.call(request: refreshAccessToken(completion: { (refreshToken) in
                    switch refreshToken {
                    case .failure(_):
                        print("refresh token not found")
                    case .success(let refresh):
                        print(refresh.accessToken)
                        UserDefaults.standard.set(refresh.accessToken, forKey: "token")
                        apiClient.call(request: .getArtistPlaylist(token: refresh.accessToken, playlistId: playlistId, completions: completions))
                    }
                })!)
            }
        }))
        
        return NetworkRequest.buildRequest(method: .get,
                                           header: Header.GETHeader(accessToken: token).buildHeader(),
                                           baseURL: SpotifyURL.APICallBase.rawValue,
                                           path: EndingPath.playlist(id: playlistId).buildPath()) { (result) in
            
            result.decoding(Playlist.self, completion: completions)
            
        }
        
    }
    
    static func artistBestSongs(id: String, token: String, completion: @escaping(Result<ArtistTopSongs, Error>) -> Void) -> NetworkRequest {
        let apiClient = APIClient(configuration: URLSessionConfiguration.default)
        
        apiClient.call(request: .verifyExpiredToken(token: token, completion: { (expiredToken) in
            switch expiredToken {
            case .failure(_):
                print("token still valid")
            case .success(_):
                print("token expired")
                apiClient.call(request: refreshAccessToken(completion: { (refreshToken) in
                    switch refreshToken {
                    case .failure(_):
                        print("refresh token not found")
                    case .success(let refresh):
                        UserDefaults.standard.set(refresh.accessToken, forKey: "token")
                        apiClient.call(request: .artistBestSongs(id: id, token: refresh.accessToken, completion: completion))
                    }
                })!)
            }
        }))
        
        return NetworkRequest.buildRequest(method: .get,
                                           header: Header.GETHeader(accessToken: token).buildHeader(),
                                           baseURL: SpotifyURL.APICallBase.rawValue,
                                           path: EndingPath.artistTopTracks(artistId: id, country: .US).buildPath()) { result in
            result.decoding(ArtistTopSongs.self, completion: completion)
        }
        
    }
    
    static func getUserInfo(token: String, completion: @escaping (Result<UserModel, Error>) -> Void) -> NetworkRequest {
        
        NetworkRequest.buildRequest(method: .get,
                                    header: Header.GETHeader(accessToken: token).buildHeader(),
                                    baseURL: SpotifyURL.APICallBase.rawValue,
                                    path: EndingPath.userInfo.buildPath()) { result in
            
            result.decoding(UserModel.self, completion: completion)
        }
    }
    
    static func search(token: String, q: String, type: SpotifyCaseTypes, completion: @escaping (Any) -> Void) -> NetworkRequest {
        NetworkRequest.buildRequest(method: .get,
                                    header: Header.GETHeader(accessToken: token).buildHeader(),
                                    baseURL: SpotifyURL.APICallBase.rawValue,
                                    path: EndingPath.search(q: q, type: type).buildPath()) { (result) in
            
            switch type {
            case .artist:
                result.decoding(SearchArtists.self, completion: completion)
            case .track:
                result.decoding(SearchSongs.self, completion: completion)
            default:
                print("unable to find search")
            }
        }
        
    }
    
}

public extension Result where Success == Data, Failure == Error {
    
    func decoding<M: JSONModel>(_ model: M.Type, completion: @escaping (Result<M, Error>) -> Void) {
        
        DispatchQueue.global().async {
            let result = self.flatMap { data -> Result<M, Error> in
                do {
                    let decoder = M.decoder
                    let model = try decoder.decode(M.self, from: data)
                    return .success(model)
                } catch {
                    return .failure(error)
                }
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}


