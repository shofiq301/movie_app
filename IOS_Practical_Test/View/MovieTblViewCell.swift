//
//  MovieTblViewCell.swift
//  IOS_Practical_Test
//
//  Created by IOTA INFOTECH LIMITED on 17/7/22.
//

import UIKit

class MovieTblViewCell: UITableViewCell {

    static let identifier = "MovieTblViewCell"
    @IBOutlet weak var imgPoster: CustomImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtMovieDetails: UILabel!
    static func nibName() -> UINib {
        return UINib(nibName: "MovieTblViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populateData(movie: MovieResult){
        imgPoster.loadImageUsingUrlString(urlString: (movie.posterPath ?? movie.backdropPath) ?? "")
        lbTitle.text = movie.title
        txtMovieDetails.text = movie.overview
        txtMovieDetails.sizeToFit()
    }
    
}
