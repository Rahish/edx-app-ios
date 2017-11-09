//
//  CourseDashboardAdditionalViewController.swift
//  edX
//
//  Created by Salman on 31/10/2017.
//  Copyright © 2017 edX. All rights reserved.
//

import UIKit

class CourseDashboardAdditionalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView: UITableView = UITableView()
    fileprivate var cellItems: [CourseDashboardItem] = []
    
    init(cellItems:[CourseDashboardTabBarItem]) {
    
        super.init(nibName: nil, bundle: nil)
        prepareTableViewData(items: cellItems)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = OEXStyles.shared().neutralXLight()
        title = Strings.resourses
        
        tableView.isScrollEnabled = false
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        // Register tableViewCell
        tableView.register(CourseDashboardCell.self, forCellReuseIdentifier: CourseDashboardCell.identifier)
        
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
    
    private func prepareTableViewData(items:[CourseDashboardTabBarItem]) {
        cellItems = []
        for item in items {
            let standardCourseItem = StandardCourseDashboardItem(title: item.title, detail: item.detailText, icon: item.icon) {
                OEXRouter.shared().pushViewController(controller: item.viewController, fromController: self)
            }
            cellItems.append(standardCourseItem)
        }
    }
    
    // MARK: - TableView Data and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellItems[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dashboardItem = cellItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: dashboardItem.identifier, for: indexPath as IndexPath)
        dashboardItem.decorateCell(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dashboardItem = cellItems[indexPath.row]
        dashboardItem.action()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
