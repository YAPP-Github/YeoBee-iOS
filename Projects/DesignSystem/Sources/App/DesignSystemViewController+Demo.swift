import Foundation
import UIKit

enum Component: String, CaseIterable {
    case textField = "textField"
    case button = "button"
    case divider = "divider"
    case segmentControl = "segmentControl"
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
        case .button:
            self.navigationController?.pushViewController(ButtonViewController(), animated: true)
        case .divider:
            self.navigationController?.pushViewController(DividerViewController(), animated: true)
        case .segmentControl:
            self.navigationController?.pushViewController(SegmentControlViewController(), animated: true)
        }
    }
}
