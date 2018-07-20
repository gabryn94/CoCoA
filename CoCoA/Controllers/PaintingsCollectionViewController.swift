import UIKit
import AVFoundation
import AVKit

let starry_pict: [(range: ClosedRange<Double>, pictogram: String)] = [
    ((0     ... 0.1), "In"),
    ((0.1   ... 0.3), "questo"),
    ((0.3   ... 1.0), "dipinto,"),
    ((1.0   ... 1.4), "il pittore"),
    ((1.5   ... 1.6), "ha"),
    ((1.6   ... 1.8), "cercato"),
    ((1.8   ... 2.0), "il contatto")
]

let starryList: [(range: ClosedRange<Double>, pictograms: [String])] = [
    ((0     ... 1.6),   ["In", "questo", "dipinto,","il pittore", "ha"]),
    ((1.6   ... .infinity),       ["cercato", "il contatto", "diretto","con", "la realtà"])
]

let example: [(range: ClosedRange<Double>, pictogram: String)] = [
    ((0     ... 0.1), "questo"),
    ((0.1   ... 0.3), "è"),
    ((0.3   ... 1.0), "un esempio"),
    ((1.0   ... 1.4), "di descrizione"),
    ((1.4   ... 1.6), "breve")
]

let exampleList: [(range: ClosedRange<Double>, pictograms: [String])] = [
    ((0     ... .infinity),   ["questo", "è", "un esempio","di descrizione","breve"])
]

let starry_night: String = "starry_night"
let example_audio: String = "example_audio"

class PaintingsCollectionViewController: UICollectionViewController {
//    Painting(name: "Starry night", imageFilename: "starry_night.jpg", description: "In questo dipinto, il pittore ha cercato il contatto diretto con la realtà, dipingendo quello che si poteva vedere di notte dalla finestra della sua stanza nel manicomio: un cipresso, il paesino con la chiesa tradizionale, il cielo, le stelle e la luna. Grazie ai colori usati, il pittore voleva farci capire che spesso la notte sia più viva e più riccamente colorata del giorno.", audioFilename: starry_night, highlightPictogramList: starry_pict, pictogramList: starryList)
//    Painting(name: "Starry night", imageFilename: "starry_night.jpg", description: "Questo è un esempio di descrizione breve", audioFilename: example_audio, highlightPictogramList: example, pictogramList: exampleList),
    let paintings = [
        Painting(name: "Starry night", imageFilename: "starry_night.jpg", description: "In questo dipinto, il pittore ha cercato il contatto diretto con la realtà, dipingendo quello che si poteva vedere di notte dalla finestra della sua stanza nel manicomio: un cipresso, il paesino con la chiesa tradizionale, il cielo, le stelle e la luna. Grazie ai colori usati, il pittore voleva farci capire che spesso la notte sia più viva e più riccamente colorata del giorno.", audioFilename: starry_night, highlightPictogramList: starry_pict, pictogramList: starryList),
        Painting(name: "La persistenza della memoria", imageFilename: "persistenza.jpg", description: "Questo è un esempio di descrizione breve", audioFilename: example_audio, highlightPictogramList: example, pictogramList: exampleList),
        Painting(name: "L'urlo", imageFilename: "urlo.jpg", description: "Questo è un esempio di descrizione breve", audioFilename: example_audio, highlightPictogramList: example, pictogramList: exampleList),
        Painting(name: "Girasoli", imageFilename: "girasoli.jpg", description: "Questo è un esempio di descrizione breve", audioFilename: example_audio, highlightPictogramList: example, pictogramList: exampleList),
        Painting(name: "La Gioconda", imageFilename: "gioconda.jpg", description: "Questo è un esempio di descrizione breve", audioFilename: example_audio, highlightPictogramList: example, pictogramList: exampleList),
        Painting(name: "Heart", imageFilename: "heart.jpg", description: "Questo è un esempio di descrizione breve", audioFilename: example_audio, highlightPictogramList: example, pictogramList: exampleList)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paintings.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaintingCollectionViewCell.reuseIdentifier, for: indexPath) as! PaintingCollectionViewCell
        cell.painting = paintings[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showOptionsForPainting(at: indexPath)
    }
    
    private func showOptionsForPainting(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Choose", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Pict", style: .default) { _ in
            self.segueToPaintingAudioDescriptionViewController(withPainting: self.paintings[indexPath.row])
        })
        alertController.addAction(UIAlertAction(title: "Text", style: .default) { _ in
            self.segueToPaintingTextDescriptionViewController(withPainting: self.paintings[indexPath.row])
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func segueToPaintingAudioDescriptionViewController(withPainting painting: Painting) {
        let viewController = storyboard!.instantiateViewController(withIdentifier: "PaintingAudioDescriptionViewController") as! PaintingAudioDescriptionViewController
        viewController.painting = painting
        show(viewController, sender: nil)
    }
    
    private func segueToPaintingTextDescriptionViewController(withPainting painting: Painting) {
        let viewController = storyboard!.instantiateViewController(withIdentifier: "PaintingTextDescriptionViewController") as! PaintingTextDescriptionViewController
        viewController.painting = painting
        show(viewController, sender: nil)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
