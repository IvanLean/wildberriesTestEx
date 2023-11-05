import UIKit





class MyTableViewCell: UITableViewCell {
    // Элементы интерфейса для ячейки
    let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        //let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.tintColor = .gray // Цвет кнопки лайка
        //button.layer.borderColor = CGColor(red: 0, green: 1, blue: 1, alpha: 1)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Добавление элементов на ячейку
        contentView.addSubview(cellImageView)
        contentView.addSubview(cellLabel)
        contentView.addSubview(likeButton)
        
        // Настройка констрейнтов
        
        NSLayoutConstraint.activate([
            

            
            cellImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellImageView.widthAnchor.constraint(equalToConstant: 200),
            cellImageView.heightAnchor.constraint(equalToConstant: 200),
            
            //cellLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 16),
            cellLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            //likeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    
    var cityPhotos = [String]()
    var cityNames = [String]()
    

    

   // var oneCity = City()
    func updateTable(){
        tableView.reloadData()
        


        print("i updated")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        // Настройка таблицы
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Добавление таблицы на экран
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        

        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        print("WIll appear")
        tableView.reloadData()

    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oneCity.cityNames.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 300 //or whatever you need
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        oneCity.clickedCell = indexPath.row
        oneCity.viewsCity[oneCity.clickedCell] += 1
        let yourViewController = ClickedCityController()
        present(yourViewController, animated: true)

    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        
        cell.textLabel?.textAlignment = .center
        cell.cellImageView.image = UIImage(data: oneCity.cityPhotos[indexPath.row])
        cell.cellLabel.text = oneCity.cityNames[indexPath.row]
        
        

        
        
        // Добавьте действие для кнопки лайка здесь
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        
        let currentCellIndex = indexPath.row

        if currentCellIndex < oneCity.likedCity.count {
            if oneCity.likedCity[currentCellIndex] == true {
                cell.likeButton.tintColor = .red
            } else {
                cell.likeButton.tintColor = .gray
            }
        } else {
            // Если индекс выходит за пределы массива, установите цвет по умолчанию
            cell.likeButton.tintColor = .gray
        }
         
       
        return cell
    }
    
    // MARK: - Button Action
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        // Обработка нажатия кнопки лайка
        if let cell = sender.superview?.superview as? MyTableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            // Выполните действия, связанные с лайком для indexPath.row
            print("Лайкнули ячейку с индексом \(indexPath.row)")
            if oneCity.likedCity[indexPath.row] == true
            {
                oneCity.likedCity[indexPath.row] = false

                cell.likeButton.tintColor = .gray
            }
            else if oneCity.likedCity[indexPath.row] == false{
                oneCity.likedCity[indexPath.row] = true
                cell.likeButton.tintColor = .red

            }
        }
        
    }
    
    // Другие методы UITableViewDelegate могут быть добавлены здесь
}
