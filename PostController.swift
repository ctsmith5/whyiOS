//
//  PostController.swift
//  WhyIOS
//
//  Created by Colin Smith on 3/20/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import Foundation

class PostController {
    //Shared Instance
    
    static let shared = PostController()
    private init() {}
    //Source of Truth
    
    var posts: [Post] = []
    
    //Base URL
    
    let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    //MARK: - CRUD
    
    
    //Get Request (Read)
    func getPosts(completion: @escaping (Bool) -> Void){
        
        guard var url = baseURL else {completion(false) ; return}
        url.appendPathExtension("json")
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        //                              vvvDEFINING VARIABLES FOR THE COMING CLOSUREvvvv
        //                                       vvvvv     vvvvv       vvvv
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("there was an \(error) retrieving the data. \(error.localizedDescription)")
                
            }
            if let response = response{
                print(response)
            }
            guard let data = data else {completion(false) ; return}
            do{
                let outerDictionary = try JSONDecoder().decode([String:Post].self, from: data)
//                var fetchedPosts1: [Post] = []
//                for pair in outerDictionary {
//                    fetchedPosts1.append(pair.value)
//                }
                
                 let fetchedPosts2 = outerDictionary.compactMap { $0.value}
                self.posts = fetchedPosts2
                completion(true)
            }catch{
                print("could not load from dictionary \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
        
    }
    
    
    
    //Post (Create)
    
    func postPost(cohort: String, name: String, reason: String, completion: @escaping (Bool) -> Void ){
        //URL
        guard var url = baseURL else {return}
        url.appendPathExtension("json")
        print(url)
         //Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let newPost = Post(cohort: cohort, name: name, reason: reason)
        
        do{
            let data = try JSONEncoder().encode(newPost)
            request.httpBody = data
        }catch{
            print("There was an error encoding to JSON \(error.localizedDescription)")
            
        }
        
        
         //DataTask & Resume
        let dataTask = URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error{
                print("There was an error POSTint the data: \(error.localizedDescription)")
                completion(false)
            }
            self.posts.append(newPost)
            completion(true)
        }
        dataTask.resume()
    }
    
   
    
    
    
}
