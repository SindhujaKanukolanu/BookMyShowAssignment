//
//  DetailViewController.swift
//  BookMyShowAssignment
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 29/05/21.
//

import UIKit
import Combine

class DetailViewController : UIViewController,UITableViewDelegate {
    
    var detailTableView = UITableView()
    
    let detailIdentifier = "detailIdentifier"
    
    private lazy var detailDatasource = makeDatasource()
    
    private var viewModel = DataSourceViewModel()
    
    var cancellables = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.frame = self.view.frame
        setupTableviewCells()
        // delay and update tableview
        self.updateDetail(with: self.viewModel.detailViewCards)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //destory all subscriptions
        cancellables.forEach { (subscriber) in
            subscriber.cancel()
        }
    }
    
    private func setupTableviewCells() {
        detailTableView = UITableView(frame: self.view.frame)
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: detailIdentifier)
        detailTableView.dataSource = detailDatasource
        detailTableView.delegate = self
        
        detailTableView.rowHeight = 400.0
        detailTableView.estimatedRowHeight = UITableView.automaticDimension
        
        detailTableView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.view.addSubview(detailTableView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = detailDatasource.snapshot().sectionIdentifiers[section]
        let label = UILabel()
        label.text = sectionModel.title
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // on row selection
        let rowModel = detailDatasource.snapshot().sectionIdentifiers[indexPath.section].rows[indexPath.row]
        print(rowModel)
        
    }
}

extension DetailViewController {
    
    // create diffable tableview datasource
    private func makeDatasource() -> UITableViewDiffableDataSource<DetailSectionModel, DetailDataModel> {
        let reuseIdentifier = detailIdentifier
        
        return UITableViewDiffableDataSource<DetailSectionModel, DetailDataModel>(tableView: detailTableView) { tableView, indexPath, rowModel -> UITableViewCell? in
            var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
            if cell.detailTextLabel == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
            }
            cell.textLabel?.text = rowModel.overView
            cell.textLabel?.numberOfLines = 10
            cell.detailTextLabel?.text = rowModel.language
            cell.detailTextLabel?.textAlignment = NSTextAlignment.center
            cell.detailTextLabel?.textColor = UIColor.red
            cell.accessoryView?.accessibilityIdentifier  = String(describing: rowModel.ratings)
            return cell
        }
        
    }
    
    func updateDetail(with cards: [DetailSectionModel], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<DetailSectionModel, DetailDataModel>()
        cards.forEach { (section) in
            snapshot.appendSections([section])
            snapshot.appendItems(section.rows, toSection: section)
        }
        detailDatasource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }
    
    func remove(_ card: DetailDataModel, animate: Bool = true) {
        var snapshot = detailDatasource.snapshot()
        snapshot.deleteItems([card])
        detailDatasource.apply(snapshot, animatingDifferences: animate, completion: nil)
    }
    
}
