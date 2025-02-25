//
//  PostsTableViewCell.swift
//  HW_106
//
//  Created by Азат Зиганшин on 31.10.2023.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    var indexPath: IndexPath?
    var isLiked: Bool = false
    var user: User?
    var publication: Publication?

    weak var delegate: DeleteAlertDelegate?

    private lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "remy_fluffy"
        return label
    }()

    private lazy var avatarImage: UIImageView = {
        let imageView = RoundImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var deleteButton: UIButton = {

        let action = UIAction { [weak self] _ in
            guard let index = self?.indexPath else { return }
            self?.delegate?.presentDeleteAlert(index)
        }

        let button = UIButton()
        button.addAction(action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "dots")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        button.imageView?.tintColor = .black
        return button
    }()

    private lazy var postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)

        let likeAction = UIAction { [weak self] _ in

            guard let isLiked = self?.isLiked else { return }

            if isLiked {
                self?.dislikeWithAnimation()
            } else {
                self?.likeWithAnimation()
            }
        }
        button.addAction(likeAction, for: .touchUpInside)
        return button
    }()

    private lazy var chatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "chat")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()

    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "bookmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        button.imageView?.tintColor = .white
        return button
    }()

    private lazy var likesCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Нравится: 0"
        return label
    }()

    private lazy var nameUnderPostLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostsTableViewCell {

    func likeWithAnimation() {

        UIView.animate(withDuration: 0.2) {

            let sizeTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.likeButton.transform = sizeTransform
            self.likeButton.setImage(UIImage(named: "liked"), for: .normal)

        } completion: { isFinished in
            guard isFinished else { return }

            UIView.animate(withDuration: 0.2) {

                self.likeButton.transform = .identity
                self.isLiked = true

                guard let userId = self.user?.id else { return }
                guard let publicationId = self.publication?.id else { return }

                LikesManager.shared.save(userId: userId, publicationId: publicationId)
                guard let publication = self.publication else { return }
                self.likesCountLabel.text = "Нравится: \(publication.getLikesCount())"
            }
        }
    }

    func likeWithoutAnimation() {

        likeButton.setImage(UIImage(named: "liked"), for: .normal)
        isLiked = true
    }

    func dislikeWithAnimation() {

        UIView.animate(withDuration: 0.2) {

            let sizeTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.likeButton.transform = sizeTransform
            self.likeButton.setImage(UIImage(named: "like"), for: .normal)

        } completion: { isFinished in
            guard isFinished else { return }

            UIView.animate(withDuration: 0.2) {

                self.likeButton.transform = .identity
                self.isLiked = false

                guard let userId = self.user?.id else { return }
                guard let publicationId = self.publication?.id else { return }

                LikesManager.shared.remove(userId: userId, publicationId: publicationId)
                guard let publication = self.publication else { return }
                self.likesCountLabel.text = "Нравится: \(publication.getLikesCount())"
            }
        }
    }

    func configureCell(with post: Publication, _ user: User) {

        self.publication = post
        DispatchQueue.main.async {
            self.postImage.image = post.photo
            self.descriptionLabel.text = post.text

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy"
            self.dateLabel.text = dateFormatter.string(from: post.date)

            self.avatarImage.image = user.avatarImage
            self.nameLabel.text = user.login
            self.nameUnderPostLabel.text = user.login
            self.likesCountLabel.text = "Нравится: \(post.getLikesCount())"
        }
    }

    func setupLayout() {

        contentView.addSubview(avatarImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(deleteButton)
        contentView.addSubview(postImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(chatButton)
        contentView.addSubview(sendButton)
        contentView.addSubview(bookmarkButton)
        contentView.addSubview(likesCountLabel)
        contentView.addSubview(nameUnderPostLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            avatarImage.heightAnchor.constraint(equalToConstant: 20),
            avatarImage.widthAnchor.constraint(equalToConstant: 20),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 5),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),

            deleteButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.widthAnchor.constraint(equalToConstant: 20),

            postImage.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 10),
            postImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            postImage.heightAnchor.constraint(equalToConstant: 400),

            likeButton.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),

            chatButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 15),
            chatButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            chatButton.heightAnchor.constraint(equalToConstant: 30),
            chatButton.widthAnchor.constraint(equalToConstant: 30),

            sendButton.leadingAnchor.constraint(equalTo: chatButton.trailingAnchor, constant: 15),
            sendButton.centerYAnchor.constraint(equalTo: chatButton.centerYAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.widthAnchor.constraint(equalToConstant: 30),

            bookmarkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            bookmarkButton.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),

            likesCountLabel.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor),
            likesCountLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 10),

            nameUnderPostLabel.topAnchor.constraint(equalTo: likesCountLabel.bottomAnchor, constant: 5),
            nameUnderPostLabel.leadingAnchor.constraint(equalTo: likesCountLabel.leadingAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: nameUnderPostLabel.trailingAnchor, constant: 5),
            descriptionLabel.topAnchor.constraint(equalTo: nameUnderPostLabel.topAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: nameUnderPostLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10)
        ])
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
