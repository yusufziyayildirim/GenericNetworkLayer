# GenericNetworkLayer

## **Technologies Used**

- **URLSession:** URLSession is a foundational framework for making network requests in iOS applications.
- **MVVM (Model-View-ViewModel):** MVVM is an architectural pattern used to organize code by separating data presentation (ViewModel) from the user interface (View).
- **Singleton Pattern:** The Singleton Pattern is a creational design pattern that ensures a class has only one instance and provides a global point of access to that instance.
- **Dependency Injection:** Dependency Injection is a design pattern that promotes loose coupling between objects by providing dependencies (such as services or data) from the outside rather than creating them internally.
- **Delegate Pattern:** The Delegate Pattern is used for communication between objects and is often employed in this project for parsing JSON responses into data models.
- **Async/Await:** Async/Await is a modern Swift feature that simplifies asynchronous programming by allowing developers to write asynchronous code in a more sequential and readable manner, enhancing the project's overall maintainability and readability.


## **Network Manager using Swift**

Let's start by explaining the code in the NetworkHelper.swift file, and then we'll delve into how it relates to the overall network layer.

### NetworkHelper.swift

This Swift file defines a set of protocols and extensions that serve as the foundation for building a generic network layer. Here's a breakdown of the key components in this file:

##

#### `HTTPMethod` Enum

```Swift
enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
```
- This enum defines common HTTP methods as cases, representing GET, POST, PUT, and DELETE.

##

#### `EndpointProtocol` Protocol

```Swift
protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var queryParams: [String: Any]? { get }
    var multipartFormData: [(name: String, filename: String, data: Data)]? { get }
}
```
- This protocol defines the structure for creating network request endpoints. It includes properties like baseURL, path, method, header, queryParams, and multipartFormData, allowing you to specify various details of an API endpoint.

##

#### `makeUrlRequest()` Extension Method

```Swift
extension EndpointProtocol {
    
    func makeUrlRequest() -> URLRequest {
        guard var components = URLComponents(string: baseURL) else { fatalError("Invalid base URL") }
        
        // Add path
        components.path = path
        
        //Create request
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        //Add queryParams
        if let queryParams = queryParams {
            if method == .GET {
                // For GET requests, append query parameters to the URL
                
                var queryItems: [URLQueryItem] = []
                for (key, value) in queryParams {
                    let queryItem = URLQueryItem(name: key, value: String(describing: value))
                    queryItems.append(queryItem)
                }
                components.queryItems = queryItems
                request.url = components.url
                
            } else {
                // For other methods, add query parameters to the request body
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: queryParams)
                    request.httpBody = data
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        //Add header
        if let header = header {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        //Add multipart form data
        if let multipartFormData = multipartFormData {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            for formData in multipartFormData {
                request.httpBody?.append("--\(boundary)\r\n".data(using: .utf8)!)
                request.httpBody?.append("Content-Disposition: form-data; name=\"\(formData.name)\"; filename=\"\(formData.filename)\"\r\n".data(using: .utf8)!)
                request.httpBody?.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
                request.httpBody?.append(formData.data)
                request.httpBody?.append("\r\n".data(using: .utf8)!)
            }
        }
        
        return request
    }
    
}
```
- This extension method provides a convenient way to create a URLRequest from an EndpointProtocol. It constructs and configures a URLRequest based on the provided properties such as baseURL, path, method, header, queryParams, and multipartFormData. This makes it easy to generate a request object for making network calls.

##

This project demonstrates a simple network manager in Swift that allows you to send HTTP requests and handle responses using asynchronous programming. The NetworkManager protocol defines a set of methods for sending requests, and the URLSessionNetworkManager class implements this protocol for handling network operations.

### NetworkManager Protocol

The NetworkManager protocol defines a method for sending HTTP requests and receiving responses asynchronously. Here's a brief overview of the protocol:

```Swift
protocol NetworkManager {
    func sendRequest<T: Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type) async throws -> T
}

```

- **sendRequest:**: his method sends an HTTP request using the provided EndpointProtocol and expects a response of a specified type T. It uses Swift's async/await for asynchronous execution and can throw errors in case of failures.

### URLSessionNetworkManager Implementation

The URLSessionNetworkManager class is an implementation of the NetworkManager protocol. It uses Apple's URLSession to perform network operations. Here's an explanation of the class:

```Swift
class URLSessionNetworkManager: NetworkManager {
    static let shared = URLSessionNetworkManager()
    
    private init() {}
    
    //Error enums
     enum NetworkError: Error {
        case invalidURL
        case requestFailed
        case invalidResponse
        case decodingError
    }
    

    func sendRequest<T: Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type) async throws -> T {
        // Create an HTTP request using the provided endpoint.
        let request = endpoint.makeUrlRequest()
        
        do {
            // Perform the network request and await the response.
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check if the response status code is in the 200-299 range.
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            do {
                // Deserialize the response data into the specified type.
                let response = try JSONDecoder().decode(T.self, from: data)
                return response
            } catch {
                throw NetworkError.decodingError
            }
            
        } catch {
            throw NetworkError.requestFailed
        }
    }
}
```
 - **shared:**: This property provides a shared instance of the URLSessionNetworkManager to ensure a single point of access to the network manager.
- **sendRequest:**: This method implements the sendRequest protocol method. It creates an HTTP request using the provided EndpointProtocol, sends the request using URLSession, and handles errors, response validation, and decoding.



## How to use this network layer

You can use the Generic Network Layer by following these steps:

1 - Under the `Models` directory,  define the API response type. This type should typically include properties for the status, message, and the data returned from the API. Here's an example:

```swift
struct APIResponse<T: Codable>: Codable {
    let status: String?
    let message: String?
    let data: T?
}
```

2 -  Next, define the data model(s) that correspond to the data you expect to receive from the API. Create a new Swift file for each data model you need. In each data model file, define the properties that represent the data fields you expect to receive. For example, if you have a **`User`** data model:

```swift
struct User: Codable {
    let id: Int?
    let username: String?
    let email: String?
    let imgUrl: String?
}
```

3 - In the third step, create an enum implementing the **`EndpointProtocol`** to define your API endpoints. You should add this endpoint enum under the **`Managers/NetworkManager/Endpoints/YourEndpoints`** directory.

```swift
enum UserEndpoints {
    case getAllUsers
    case getUser(id: Int)
    case setCurrentUserData
    case uploadCurrentUserProfileImage(imageData: Data)
}

extension FirstGroupEndpoints: EndpointProtocol {
    
    var baseURL: String {
        "https://exampleuserapi.com/api/"
    }
    
    var path: String {
        switch self {
        case .getAllUsers:
            return "/users"
        case .getUser(let id):
            return "/user/\(id)/"
        case .setCurrentUserData:
            return "/user/update/"
        case .uploadCurrentUserProfileImage:
            return "/user/update/photo/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllUsers, .getUser:
            return .GET
        case .setCurrentUserData, .uploadCurrentUserProfileImage:
            return .POST
        }
    }
    
    var queryParams: [String : Any]? {
        switch self {
        case .getAllUsers:
            return ["sources": "abc-news", "apiKey": "65aa49462772477ea31c84814fad3bd7"]
        default:
            return nil
        }
    }
    
    var header: [String: String]? {
        var header = ["Content-type": "application/json; charset=UTF-8"]
        
        switch self {
        case .setCurrentUserData, .uploadCurrentUserProfileImage:
            header["Authorization"] = "Bearer YourAuthTokenHere"
            return header
        default:
            return header
        }
    }
    
    var multipartFormData: [(name: String, filename: String, data: Data)]? {
        switch self {
        case .uploadCurrentUserProfileImage(let imageData):
            let filename = "profile_image.jpg"
            return [("profile_image", filename, imageData)]
        default:
            return nil
        }
    }
}
```

4 - After that, you should define a protocol under the **`Services/YourServiceFolder/YourServiceProtocol`** directory for the service that outlines the functions your service will provide. This protocol will allow you to use mock data for testing and make your project more testable. 

```swift
protocol UserServiceProtocol {
    func getAllUsers() async throws -> APIResponse<[User]>
    func getUser(id: Int) async throws -> APIResponse<User>
    func setCurrentUserData() async throws -> APIResponse<User>
    func uploadCurrentUserProfileImage(imageData: Data) async throws -> APIResponse<User>
}
```

5 - After defining the service protocol, you can create a mock data service that conforms to this protocol. This mock data service will provide mock data for testing purposes. Here's how you can create a mock data service:

```swift
class MockUserService: UserServiceProtocol {
    
    private var currentUser = User(id: 1, username: "currentUser", email: "currentUser@example.com", imgUrl: "https://example.com/img1.jpg")
    
    private let mockUsers: [User] = [
        User(id: 1, username: "kullanici1", email: "kullanici1@example.com", imgUrl: "https://example.com/img1.jpg"),
        User(id: 2, username: "kullanici2", email: "kullanici2@example.com", imgUrl: "https://example.com/img2.jpg"),
        User(id: 3, username: "kullanici3", email: "kullanici3@example.com", imgUrl: "https://example.com/img3.jpg"),
    ]
    
    func getAllUsers() async throws -> APIResponse<[User]> {
        return APIResponse(status: "success", message: "All Users", data: mockUsers)
    }
    
    func getUser(id: Int) async throws -> APIResponse<User> {
        return APIResponse(status: "success", message: "The User", data: currentUser)
    }
    
    func setCurrentUserData() async throws -> APIResponse<User> {
        let newCurrentUser = User(id: 999, username: "mockuser999", email: "newCurrentUser@example.com", imgUrl: "https://example.com/mockimg.jpg")
        currentUser = newCurrentUser
        return APIResponse(status: "success", message: "Current user data updated", data: currentUser)
    }
    
    func uploadCurrentUserProfileImage(imageData: Data) async throws -> APIResponse<User> {
        let newCurrentUser = User(id: 999, username: "mockuser999", email: "mockuser999newCurrentUser@example.com", imgUrl: "https://example.com/newMockimg.jpg")
        currentUser = newCurrentUser
        return APIResponse(status: "success", message: "Current user profile image updated", data: currentUser)
    }
}
```

6 - Customize the **`YourRealService`** class by implementing the functions defined in **`YourServiceProtocol`**.

```swift
class UserService: UserServiceProtocol {
    private let networkManager: NetworkManager
    
    init() {
        self.networkManager = URLSessionNetworkManager.shared
    }
    
    func getAllUsers() async throws -> APIResponse<[User]> {
        let endpoint = FirstGroupEndpoints.getAllUsers
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<[User]>.self)
    }
    
    func getUser(id: Int) async throws -> APIResponse<User> {
        let endpoint = FirstGroupEndpoints.getUser(id: id)
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<User>.self)
    }
    
    func setCurrentUserData() async throws -> APIResponse<User> {
        let endpoint = FirstGroupEndpoints.setCurrentUserData
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<User>.self)
    }
    
    func uploadCurrentUserProfileImage(imageData: Data) async throws -> APIResponse<User> {
        let endpoint = FirstGroupEndpoints.uploadCurrentUserProfileImage(imageData: imageData)
        return try await networkManager.sendRequest(endpoint, responseType: APIResponse<User>.self)
    }
}
```

Your network layer is ready to use. 

## How to Use the Layer in MVVM Pattern

Let's consider an example where you have a screen that lists users.

Under the `Core/YourSceneName/` directory, create a ViewController and ViewMode, and then connect them using the delegate pattern.

```swift
protocol UserListVMDelegate: AnyObject {
    func reloadTableView()
    func didFailWithError(error: String)
}

final class UserListVC: UIViewController {
    
    // MARK: - ViewModel
    let viewModel = UserListVM(service: UserService())
    
    private var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureViewModel()
    }
    
    private func configureTableView() {
        userTableView = UITableView()
        view.addSubview(userTableView)
        
        userTableView.translatesAutoresizingMaskIntoConstraints = false
        userTableView.delegate = self
        userTableView.dataSource = self
        
        userTableView.pinToEdgesOf(view: view)
    }
    
    private func configureViewModel() {
        viewModel.viewDelegate = self
        Task {
            await viewModel.getAllUsers()
        }
    }
    
}

// MARK: - TableViewDelegate and TableViewDataSource
extension FirstVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "UserCell")
        let user = viewModel.users[indexPath.row]
        cell.textLabel?.text = user.username
        
        return cell
    }
    
}

// MARK: - UserListVMDelegate
extension FirstVC: UserListVMDelegate {
    
    func reloadTableView() {
        firstTableView.reloadOnMainThread()
    }
    
    func didFailWithError(error: String) {
        print(error)
    }
    
}
```

```swift
// MARK: - UserList ViewModel
final class UserListVM{
    
    // MARK: - Service
    let service: UserServiceProtocol
    
    // MARK: - Delegate
    weak var viewDelegate: UserListVMDelegate?
    
    var users = [User]()
    
    // MARK: - Initialization
    init(service: UserServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func getAllUsers() async {
        do {

            let response = try await service.getAllUsers()
            switch response.status {

            case "success":
                if let users = response.data {
                    self.users = users
                    viewDelegate?.reloadTableView()
                }

            case "error":
                let errorMessage = response.message ?? "Something went wrong"
                viewDelegate?.didFailWithError(error: errorMessage)

            default:
                break
            }

        } catch {
            viewDelegate?.didFailWithError(error: error.localizedDescription)
        }
    }
    
    //You can add other service functions in a similar manner.
}
```
#### I have included two similar examples within the project. You can review the code and assist in the project's development.
