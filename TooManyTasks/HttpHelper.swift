import Foundation

class HttpHelper {
    
    var delegate: HttpHelperDelegate?
    
    var url: String!
    
    init(url: String) {
        self.url = url
    }
    
    func request(params: [String: Any], method: RequestMethod, onSuccess: (([String: Any]) -> Void)? = nil, onFail: (() -> Void)? = nil) {
        var direct = url!
        print(direct)
        let percentString = params.percentEncoded()
        if let token = AppDelegate.token {
            direct.append("?token=\(token)")
        }
        let endpoint = URL(string: method == .GET && params.count > 0 ? direct + ((AppDelegate.token ?? "" != "") ? percentString : "?" + percentString) : direct)!
        var request = URLRequest(url: endpoint)
        request.httpMethod = method.toMethod()
        if method == .POST {
            request.httpBody = percentString.data(using: .utf8)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil, let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    self.delegate?.onFail()
                    onFail?()
                    return
                }
                self.delegate?.onSuccess(data: json)
                onSuccess?(json)
            }
        }
        task.resume()
    }
    
}

enum RequestMethod {
    case GET
    case POST
    
    fileprivate func toMethod() -> String {
        switch self {
        case .GET:
            return "GET"
        case .POST:
            return "POST"
        }
    }
}

extension Dictionary {
    func percentEncoded() -> String {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
