import Foundation
import Combine





func loadUserDetailsDemo() ->AnyPublisher<(UserDetails,[Friends]),Error>  {
    
    loadUser().flatMap { user in
        
        Publishers.Zip(loadUserDetails(user: user),loadFriends(user: user)).eraseToAnyPublisher()
        
//        Publishers.Zip3 // for 3 request zip4 for 4 request
        
    }.eraseToAnyPublisher()

    
}


func loadUser() ->  AnyPublisher<User,Error> {
    let url = URL(string: "http://som-url/endpoint")!
    
   return  URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { result  in
            guard let httpresponse = result.response as? HTTPURLResponse,
                  httpresponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            return result.data
        }
        .decode(type: User.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

func loadUserDetails(user:User) ->  AnyPublisher<UserDetails,Error> {
    let url = URL(string: "http://som-url/\(user.id)/details")!
    
   return  URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { result  in
            guard let httpresponse = result.response as? HTTPURLResponse,
                  httpresponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            return result.data
        }
        .decode(type: UserDetails.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

func loadFriends(user:User) ->  AnyPublisher<[Friends],Error> {
    let url = URL(string: "http://som-url/\(user.id)/friends")!
    
   return  URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { result  in
            guard let httpresponse = result.response as? HTTPURLResponse,
                  httpresponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            return result.data
        }
        .decode(type: [Friends].self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}



struct User :Decodable {
    let id = UUID()
}

struct UserDetails : Decodable {
    let name:String
    let email:String
}
struct Friends : Decodable {
    let id:String
    let name:String

}
