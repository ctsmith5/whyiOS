//
//  PostListTableViewController.swift
//  WhyIOS
//
//  Created by Colin Smith on 3/20/19.
//  Copyright © 2019 Colin Smith. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PostController.shared.getPosts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PostController.shared.posts.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
       
        let post = PostController.shared.posts[indexPath.row]
       
        cell?.cohortLabel.text = post.cohort
        cell?.reasonLabel.text = post.reason
        cell?.nameLabel.text = post.name
        
        return cell ?? UITableViewCell() 
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        addPost()
        
        
    }
    
    func addPost() {
        let addPost = UIAlertController(title: "Enter Information", message: nil, preferredStyle: .alert)
        addPost.addTextField { (textField) in
            textField.placeholder = "Cohort Name"
        }
        addPost.addTextField { (textField2) in
            textField2.placeholder = "Your Name"
        }
        addPost.addTextField { (textField3) in
            textField3.placeholder = "Whats your Reason?"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let cohort = addPost.textFields?[0].text,
                let name = addPost.textFields?[1].text,
                let reasons = addPost.textFields?[2].text else {return}
            PostController.shared.postPost(cohort: cohort, name: name, reason: reasons, completion: { (success) in
                if success {
                    print("successfully created new user")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }
        //cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //piece notification together
        addPost.addAction(addAction)
        addPost.addAction(cancelAction)
        
        present(addPost, animated: true, completion: nil)
        
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


