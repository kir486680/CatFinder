//
//  ViewController.swift
//  compProj
//
//  Created by Kirill Kalashnikov on 5/19/20.
//  Copyright © 2020 Kirill Kalashnikov. All rights reserved.
//

import UIKit


var cats: [Cat] = []
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
    private var isFiltering: Bool{
        return searchController.isActive && !searchBarIsEmpt
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //downloadJson()
        //loadData()
        downloadJson {
            print("HOHOHO:HOTHONONONONO")
        }
        //get the cats
        //queryID(address: "https://api.thecatapi.com/v1/breeds")
        
        //Setup Search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //print(catIds)
        print("hey")
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
        
        let imgageURL = URL(string: cat.url)
        //cell.catImageView.load(url: imgageURL!)
        cell.catImageView.image = cat.image
        //print(imgageURL)
        
        cell.nameLabel.text = text //3.
        
        
           
        return cell //4.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        return 126
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CatViewController{
            destination.cat = cats[(tableView.indexPathForSelectedRow?.row) as! Int]
        }
    }


    func downloadJson(completed: @escaping()-> ()){
        let g = DispatchGroup()
        for i in 0...catIDS.count-1{
            g.enter()
            let url = URL(string: "https://api.thecatapi.com/v1/images/search?breed_ids=\(catIDS[i])")
            URLSession.shared.dataTask(with: url!) {(data, response, error) in
                if error == nil{
                    do {
                        let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: [])
                        guard let jsonArray = jsonResponse as? [[String: Any]] else {
                              return
                        }
                        //print(jsonArray[0]["url"])
                       do {
                        let breed = try JSONDecoder().decode([WelcomeElement].self, from: data!)
                        //print(breed[0].breeds[0].name, i, breed[0].url)
                       
                        cats.append(Cat(name: breed[0].breeds[0].name, description: breed[0].breeds[0].breedDescription, url: breed[0].url, life_span: breed[0].breeds[0].lifeSpan, intelligence: breed[0].breeds[0].intelligence, energyLevel: breed[0].breeds[0].energyLevel))
                        } catch { print(error) }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            g.leave();
                        }
                    } catch{
                        print("cant decode")
                    }
                    
                }
            }.resume()
        }
        g.notify(queue: .main) {
            print("DONE", cats.count)
        }

        
        
    }

}
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


