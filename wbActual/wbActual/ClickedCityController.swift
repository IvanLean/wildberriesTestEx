import UIKit



class CityImageTableViewCell: UITableViewCell {
    
    // Элементы интерфейса для ячейки
    let cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // Добавьте другие элементы интерфейса для ячейки, если это необходимо
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Добавьте элементы интерфейса на ячейку и настройте constraints
        addSubview(cityImageView)
        
        NSLayoutConstraint.activate([
            
            cityImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 100), // Левый маргин
            cityImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100), // Верхний маргин
            cityImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cityImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cityImageView.widthAnchor.constraint(equalToConstant: 200),
            cityImageView.heightAnchor.constraint(equalToConstant: 200),



        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ClickedCityController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Данные о выбранном регионе
    var cityName: String?
    //var imageGallery = [UIImage(named: "moscow")!, UIImage(named: "moscow2")!, UIImage(named: "moscow")!]
    var cityImagesData = [Data]()
    var viewCount: Int = 0
    var isLiked: Bool = false
    
    var photos = [String]()
    

    // Элементы интерфейса
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    /*
    let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Лайк", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
     */
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        //let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.tintColor = .gray // Цвет кнопки лайка
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        //button.layer.borderColor = CGColor(red: 0, green: 1, blue: 1, alpha: 1)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeArrayImages(clickedCell: oneCity.clickedCell)
        print("CLICKED NUM",oneCity.clickedCell)

        tableView.dataSource = self
        tableView.delegate = self
        //tableView.frame = view.bounds
        tableView.register(CityImageTableViewCell.self, forCellReuseIdentifier: "cell")

        //tableView.reloadData()
        setupUI()
        updateUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        ViewController().updateTable()
        print("I will be closed")
    }
    
    func setupUI() {
        // Добавляем элементы интерфейса на экран

        // Название города
        view.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        // Таблица с изображениями
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        // Фон для просмотров и кнопки лайка
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .white
        view.addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100), // Высота фона
        ])

        // Количество просмотров
        bottomView.addSubview(viewCountLabel)
        NSLayoutConstraint.activate([
            viewCountLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
            viewCountLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 20),
            viewCountLabel.trailingAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: -10),
        ])
        
        // Кнопка лайка
        bottomView.addSubview(likeButton)
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: bottomView.centerXAnchor, constant: 10),
        ])
    
     }
    
    func updateUI() {
        // Устанавливаем данные о регионе
        cityLabel.text = oneCity.cityNames[oneCity.clickedCell]
            

        
        
        viewCountLabel.text = "Просмотры: \(oneCity.viewsCity[oneCity.clickedCell])"
        
        if oneCity.likedCity[oneCity.clickedCell] == true{
            likeButton.tintColor = .red
        }
        else{
            likeButton.tintColor = .gray
            print("Nothing happend")
        }
        
    

        
        
        // Устанавливаем текст кнопки в зависимости от статуса "Лайк"
        //let likeButtonTitle = isLiked ? "Убрать Лайк" : "Лайк"
        
        //likeButton.setTitle(likeButtonTitle, for: .normal)
        
        tableView.reloadData()
    }
    
    func makeArrayImages(clickedCell: Int)
    {
        photos = oneCity.manyPhotosOfCity[clickedCell]!
        
            for i in 0...photos.count-1
            {
                
                let urlPh = URL(string: photos[i])
                let dataPh = try! Data(contentsOf: urlPh!)
                
                cityImagesData.append(dataPh)
            }
            
        
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return oneCity.manyPhotosOfCity[oneCity.clickedCell]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityImageTableViewCell
       // cell.cityImageView.image = imageGallery[indexPath.row]
        

        cell.cityImageView.image = UIImage(data: cityImagesData[indexPath.row])
            
        
        
        //cell.cityImageView.image = UIImage(data: oneCity.manyPhotosOfCity[clickedCell][indexPath.row])

        return cell
    }

    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400 // Высота ячейки таблицы с картинкой
    }
    
    @objc func likeButtonTapped() {
        // Обработка нажатия на кнопку "Лайк"
        isLiked.toggle()
        print("Button tapped")
        
        if oneCity.likedCity[oneCity.clickedCell] == false{
            oneCity.likedCity[oneCity.clickedCell] = true
        }
        else if oneCity.likedCity[oneCity.clickedCell] == true{
            oneCity.likedCity[oneCity.clickedCell] = false
        }
        
        
        updateUI()
    }
}
