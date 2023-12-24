import Foundation
import UIKit

enum Component: String, CaseIterable {
    case textField = "textField"
}

public class DesignSystemViewController: UITableViewController {
    
    fileprivate var components: [Component] = Component.allCases
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Design System"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
}

extension DesignSystemViewController {
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = components[indexPath.row].rawValue
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch components[indexPath.row] {
        case .textField:
            self.navigationController?.pushViewController(TextFieldViewController(), animated: true)
        }
    }
}
