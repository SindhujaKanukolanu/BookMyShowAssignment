//
//  ViewController.swift
//  BookMyShowAssignment
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 28/05/21.
//

import UIKit
import Combine


class ViewController: UIViewController,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)

    let rowIdentifier = "listIdentifier"
    let detailsViewController = DetailViewController()

    
    private lazy var datasource = makeDatasource()
    
    var viewModel = DataSourceViewModel()
    
    var cancellables = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableviewCells()
        configureSearchController()
        setupBindings()
    
        // delay and update tableview
        self.update(with: self.viewModel.cards)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //destory all subscriptions
        cancellables.forEach { (subscriber) in
            subscriber.cancel()
        }
    }
    
    
    private func setupBindings() {
        let publisher = viewModel.fetchCards()
        publisher
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
            if case .failure(let error) = completion {
                print("fetch error -- \(error)")
            }
        } receiveValue: { [weak self] cards in
            self?.update(with: cards)
        }.store(in: &cancellables)
    }
    
    private func setupTableviewCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: rowIdentifier)
        tableView.dataSource = datasource
        tableView.delegate = self
        
        tableView.rowHeight = 100.0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = datasource.snapshot().sectionIdentifiers[section]
        
        let label = UILabel()
        label.text = sectionModel.title
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // on row selection
        let rowModel = datasource.snapshot().sectionIdentifiers[indexPath.section].rows[indexPath.row]
        print(rowModel)
        viewModel.getDetailsCard(indexPath: indexPath.section)
        present(detailsViewController, animated: true, completion: nil)
        detailsViewController.updateDetail(with: viewModel.detailViewCards)
        
    }
}

// all diffable dataosurce code
extension ViewController {

    // create diffable tableview datasource
    private func makeDatasource() -> UITableViewDiffableDataSource<SectionModel, DataModel> {
        let reuseIdentifier = rowIdentifier
        
        return UITableViewDiffableDataSource<SectionModel, DataModel>(tableView: tableView) { tableView, indexPath, rowModel -> UITableViewCell? in
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            if cell.detailTextLabel == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
            }
            cell.textLabel?.text = rowModel.movieName
            cell.imageView?.image = rowModel.image
            cell.detailTextLabel?.text = rowModel.releaseDate
            let bookButton = UIButton(frame: CGRect(x: cell.frame.origin.x + 250, y: 30, width: 50, height: 20))
            bookButton.setTitle("Book", for: .normal)
            bookButton.titleLabel?.textColor = UIColor.black
            bookButton.backgroundColor = UIColor.red
            cell.contentView.addSubview(bookButton)
            return cell
        }
        
    }
    
    func update(with cards: [SectionModel], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, DataModel>()
        
        cards.forEach { (section) in
            snapshot.appendSections([section])
            snapshot.appendItems(section.rows, toSection: section)
        }

        datasource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }
    
    func remove(_ card: DataModel, animate: Bool = true) {
        var snapshot = datasource.snapshot()
        snapshot.deleteItems([card])
        datasource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }

}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var filteredData = [SectionModel]()
        filteredData = filteredValues(for: searchController.searchBar.text)
        self.update(with: filteredData)
    }
    
    func filteredValues(for queryOrNil: String?) -> [SectionModel] {
        let sections = viewModel.cards
        var filteredCards = [SectionModel]()
      guard
        let query = queryOrNil,
        !query.isEmpty
        else {
          return sections
      }
        for rows in sections {
            print(rows)
        }
        for eachSection in sections {
            for name in eachSection.rows {
                if name.movieName.contains(query.uppercased()) || name.movieName.contains(query) {
                    filteredCards.append(contentsOf: [SectionModel(title: "", rows: [name])])
                }
            }
        }
      return filteredCards
    }
    
    //Test
    func configureSearchController() {
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search Movies"
      navigationItem.searchController = searchController
      definesPresentationContext = true
     tableView.addSubview(searchController.searchBar)
    }
    
}

