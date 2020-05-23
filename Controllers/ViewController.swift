//
//  ViewController.swift
//  compProj
//
//  Created by Kirill Kalashnikov on 5/19/20.
//  Copyright © 2020 Kirill Kalashnikov. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var catIds: [String] = []
    var catImgUrl: [String] = []
    
    var imgUrl: URL? = nil
    private var filteredCats = [Cat]()
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpt: Bool {
        guard let text = searchController.searchBar.text else{return false}
        return text.isEmpty
    }
    //Check if undergoing a filtering process
    private var isFiltering: Bool{
        return searchController.isActive && !searchBarIsEmpt
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add listener for update
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)

        downloadJson {
            print("Done")
        }

        
        //Setup Search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        //Setup custom cell
        tableView.register(UINib(nibName: "viewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCats.count
        }
        return cats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! viewCell
        
        var cat: Cat
    
        if isFiltering{
            cat = filteredCats[indexPath.row]
        }else{
            cat = cats[indexPath.row]
        }
        let text = cat.name //2.
        cell.catImageView.image = cat.image
        cell.nameLabel.text = text //3.
        return cell //4.
    }
    //height of hte table view cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    //get cat data to pass to the next table view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CatViewController{
            destination.cat = cats[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    //Update table view when the image is loaded
    @objc func loadList(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }

    //get data from the api
    func downloadJson(completed: @escaping()-> ()){
        let g = DispatchGroup()
        for i in 0...catIDS.count-1{
            g.enter()
            let url = URL(string: "https://api.thecatapi.com/v1/images/search?breed_ids=\(catIDS[i])")
            URLSession.shared.dataTask(with: url!) {(data, response, error) in
                if error == nil{
                    do {
                        let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])
                       do {
                        let breed = try JSONDecoder().decode([WelcomeElement].self, from: data!)
                       
                        cats.append(Cat(name: breed[0].breeds[0].name, description: breed[0].breeds[0].breedDescription, url: breed[0].url, life_span: breed[0].breeds[0].lifeSpan, intelligence: breed[0].breeds[0].intelligence, energyLevel: breed[0].breeds[0].energyLevel))
                        } catch { print(error) }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            g.leave();
                        }
                    }
                }
            }.resume()
        }
        g.notify(queue: .main) {
            //notify if done with count of cats
            print("DONE", cats.count)
        }

        
        
    }

}
// Helper for sorting in the ViewController
//Decided not to move it to the extensions folder for convenience
extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredCats = cats.filter({ (restaurant: Cat) -> Bool in
            return restaurant.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
}


