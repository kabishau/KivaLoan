import UIKit

class KivaLoanTableViewController: UITableViewController {
    
    private let kivaLoanURL = "http://api.kivaws.org/v1/loans/newest.json"
    private var loans = [Loan]()
    
    func getLatestLoans() {
        
        guard let loanURL = URL(string: kivaLoanURL) else { return }
        
        let request  = URLRequest(url: loanURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            // parse JSON data
            if let data = data {
                self.loans = self.parseJsonData(data: data)
                
                // reload table view
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        }
        task.resume()
    }
    
    func parseJsonData(data: Data) -> [Loan] {
        
        var loans = [Loan]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            // parse JSON data
            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
            
            for jsonLoan in jsonLoans {
                var loan = Loan()
                loan.name = jsonLoan["name"] as! String
                loan.amount = jsonLoan["loan_amount"] as! Int
                loan.use = jsonLoan["use"] as! String
                loan.country = jsonLoan["country"] as! String
                loans.append(loan)
            }
            
        } catch {
            print(error)
        }
        
        return loans
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell

        // Configure the cell...

        return cell
    }
    


}
