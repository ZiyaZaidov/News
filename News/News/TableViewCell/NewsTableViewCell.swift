//
//  NewsTableViewCell.swift
//  News
//
//  Created by Ziya Zaidov on 11.12.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
       let title = UILabel()
        title.numberOfLines = 0
        title.font = .systemFont(ofSize: 20,weight: .semibold)
        title.translatesAutoresizingMaskIntoConstraints = false
         return title
    }()
    
    private let newsSubTitleLabel: UILabel = {
       let title = UILabel()
        title.numberOfLines = 0
        title.font = .systemFont(ofSize: 16,weight: .light)
        title.translatesAutoresizingMaskIntoConstraints = false
         return title
    }() 
    
    private let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsSubTitleLabel)
        contentView.addSubview(newsImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame = CGRect(x: 10,
                                      y: 0,
                                      width: contentView.frame.width - 170,
                                      height: 70)

        newsSubTitleLabel.frame = CGRect(x: 10,
                                      y: 70,
                                      width: contentView.frame.width - 170,
                                      height: 100)

        newsImage.frame = CGRect(x: contentView.frame.size.width - 150,
                                      y: 5,
                                      width: 140,
                                      height: contentView.frame.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsSubTitleLabel.text = nil
        newsImage.image = nil
    }
    
    func configure( with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsSubTitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData{
            newsImage.image = UIImage(data: data)
        } else if let url = viewModel.mageURL{
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data else {return}
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
