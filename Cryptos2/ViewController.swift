//
//  ViewController.swift
//  Cryptos
//
//  Created by Swift on 31/01/2018.
//  Copyright © 2018 Swift. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    //MARK: - Outlets
    
    @IBOutlet weak var lblNomeMoeda: UILabel!
    @IBOutlet weak var lblPreco: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var volume24H: UILabel!
    @IBOutlet weak var variacao1H: UILabel!
    @IBOutlet weak var variacao24H: UILabel!
    @IBOutlet weak var variacao7D: UILabel!
    
    
    //MARK: - Propriedades
    var nomeMoeda : String = ""
    var idMoeda : String = ""
    var precoMoeda : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        lblNomeMoeda.text = nome
        
        let dPreco = Double(preco)

//        preco = String(format: "%.2f", dPreco!)
        
        preco = converteValor(dPreco!)

        lblPreco.text = "\(preco)"
        
        let dMarket = Double(strMarketCap)
        
//        strMarketCap = String(format: "%.2f", dMarket!)
        strMarketCap = converteValor(dMarket!)
        marketCap.text = "\(strMarketCap)"
        
        let dVol = Double(vol24h)
        vol24h = converteValor(dVol!)
        volume24H.text = "\(vol24h)"
        
        
        variacao1H.text = "\(percChange1h)%"
        variacao1H.textColor = mudaCor(variacao: percChange1h)
        
        variacao24H.text = "\(percChange24h)%"
        variacao24H.textColor = mudaCor(variacao: percChange24h)
        
        variacao7D.text = "\(percChange7D)%"
        variacao7D.textColor = mudaCor(variacao: percChange7D)
        
    }
    
    //MARK: Actions
    
    @IBAction func adicionarFavoritos(_ sender: UIButton) {
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        var itemExiste  = false
        let umFavorito = Favoritos(context: contexto)


        if coinFavoritos.count == 0{
            coinFavoritos.append(contentsOf: coinFavoritosTriagem)
            
            
            umFavorito.setValue(coinFavoritosTriagem[0].id, forKey: "id")
         //   print(umFavorito.id)
            do{try contexto.save()
//                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//                print(documentsPath)

            } catch{}
            
        } else{
            for item in coinFavoritos{
                if item.id == coinFavoritosTriagem[0].id{
                    itemExiste = true
                }
            }
            
            if itemExiste == false{
                coinFavoritos.append(contentsOf: coinFavoritosTriagem)
                umFavorito.id = coinFavoritosTriagem[0].id
                do{try contexto.save()} catch{}


            }
        }

    }
    
    //MARK: - Métodos próprios
    func mudaCor(variacao : String) -> UIColor{
        if Double(variacao)!.isLess(than: 0.0){
            return UIColor.red
        } else {
            return UIColor.green
        }
        
    }
    
}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
