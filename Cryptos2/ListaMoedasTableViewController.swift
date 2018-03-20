//
//  ListaMoedasTableViewController.swift
//  Cryptos
//
//  Created by Swift on 31/01/2018.
//  Copyright © 2018 Swift. All rights reserved.
//

import UIKit
import CoreData

class ListaMoedasTableViewController: UITableViewController {
    //MARK: - Outlets
    
    @IBOutlet weak var titleNavigation: UINavigationItem!
    
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinJSON = downloadJSON()
        
        //Recupera do banco de dados

        if coinFavoritos.isEmpty{
            let requisicaoPesquisa = NSFetchRequest<NSFetchRequestResult>(entityName: "Favoritos")
            
            do{
                let resultado = try contexto.fetch(requisicaoPesquisa)
                let arrayFavoritos = resultado as! [Favoritos]

                let uniqueFavoritos = Array(Set(arrayFavoritos))
                
                for idExtraido in uniqueFavoritos{
                    
                    for item in coinJSON{
                        if idExtraido.id == item.id{
                            coinFavoritos.append(item)
                        }
                    }
                }
                
                
            } catch{}
        } // Recupera dados
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Aviso de memória!")
    }
    
    //MARK: - Métodos de Viewcycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        coinJSON = downloadJSON()
        tableView.reloadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moedas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) as! CelulaTableViewCell
        
        cell.lblMoeda.text = moedas[indexPath.row].name
        if let cotacao = Double(moedas[indexPath.row].priceBrl){
            //cell.lblCotacao.text = String(format: "%.2f",cotacao)
            let cotacaoString = converteValor(cotacao)
            cell.lblCotacao.text = "\(cotacaoString)"
        }
        
        cell.lblVariacao.text = "\(moedas[indexPath.row].percentChange24H!)%"
        
        //Mudar cor de acordo com a variacao
        let variacaoDouble = Double(moedas[indexPath.row].percentChange24H!)
        
        let dZero = 0.0
        
        if variacaoDouble!.isLess(than: dZero){
            cell.lblVariacao.textColor = UIColor.red
            //   cell.lblCotacao.textColor = UIColor.red
        } else {
            cell.lblVariacao.textColor = UIColor.green
            // cell.lblCotacao.textColor = UIColor.green
        }
        
        //Ibagem
        let url_string = "https://files.coinmarketcap.com/static/img/coins/32x32/"+moedas[indexPath.row].id+".png"
        let URL_IMAGE = URL(string: url_string)
        let session = URLSession(configuration: .default)
        
        let getImageFromURL = session.dataTask(with: URL_IMAGE!){ (data, response, error) in
            
            //if there is any error
            if let e = error {
                //displaying the message
                print("Error Occurred: \(e)")
                
            } else {
                //in case of now error, checking wheather the response is nil or not
                if (response as? HTTPURLResponse) != nil {
                    
                    //checking if the response contains an image
                    if let imageData = data {
                        
                        //getting the image
                        let image = UIImage(data: imageData)
                        
                        //displaying the image
                        DispatchQueue.main.async {
                            cell.imgMoeda.image = image
                        }
                    } else {
                        print("Imagem corrompida")
                    }
                } else {
                    print("No response from server")
                }
            }
        }
        
        getImageFromURL.resume()
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nome = moedas[indexPath.row].name + " - " + moedas[indexPath.row].symbol
        simbolo = moedas[indexPath.row].symbol
        preco = moedas[indexPath.row].priceBrl
        strMarketCap = moedas[indexPath.row].marketCapBrl
        vol24h = moedas[indexPath.row].the24HVolumeBrl
        percChange1h = moedas[indexPath.row].percentChange1H!
        percChange24h = moedas[indexPath.row].percentChange24H!
        percChange7D = moedas[indexPath.row].percentChange7D!
        //print(percChange24h)
        
        coinFavoritosTriagem = [moedas[indexPath.row]]
        
        
        //        print()
        //        print()
        //        print(coinFavoritos)
        //        print(coinFavoritos.count)
        //        print()
        //        print()
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     var detailController = segue.destination as! ViewController
     
     detailController.nomeMoeda =
     }
     
     */
    //MARK: - Actions
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        coinJSON = downloadJSON()
        
        var indFav = 0
        var indJ = 0
        
        for itemFav in coinFavoritos{
            for item in coinJSON{
                if itemFav.id == item.id{
                    coinFavoritos[indFav] = coinJSON[indJ]
                }
                indJ += 1
            }
            indJ = 0
            indFav += 1
        }
        
        //   print(refreshJSON[0])
        tableView.reloadData()
        
    }
    
    //MARK: - Métodos próprios
    func downloadJSON() -> Coins{
        // print("OK")
        let meuJSON = URL(string: "https://api.coinmarketcap.com/v1/ticker/?convert=BRL&limit=900")
        do{
            let decoderJSON = JSONDecoder()
            moedas = try decoderJSON.decode(Coins.self, from: Data(contentsOf: meuJSON!))
            // print(enderecoFinal)
        } catch {
            print("Erro ao importar JSON \(error)")
            alertas(titulo: "Servidor Offline", texto: "Erro ao importar dados. Tente novamente mais tarde.")
        }
        return moedas
    }
    
    func alertas(titulo : String, texto : String){
        let alerta = UIAlertController(title: titulo, message: texto, preferredStyle: .alert)
        
        let acaoOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alerta.addAction(acaoOk)
        
        present(alerta, animated: true, completion: nil)
    }
    
    
}
