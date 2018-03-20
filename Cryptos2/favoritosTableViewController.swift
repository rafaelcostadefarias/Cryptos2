//
//  favoritosTableViewController.swift
//  Cryptos2
//
//  Created by Rafael Farias on 15/02/18.
//  Copyright © 2018 Swift. All rights reserved.
//

import UIKit
import CoreData

class favoritosTableViewController: UITableViewController {

    //MARK: Actions
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
    
    @IBAction func apagarTudo(_ sender: UIBarButtonItem) {
        
        
        let refreshAlert = UIAlertController(title: "Apagar tudo", message: "Limpar todos os favoritos", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            coinFavoritos.removeAll()
            self.tableView.reloadData()
            
            //Deleta tudo do coredata
            let delete = NSBatchDeleteRequest(fetchRequest: Favoritos.fetchRequest())
            
            do{
                try contexto.execute(delete)
            } catch{}
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coinFavoritos.count
    }

       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) as! CelulaTableViewCell
        
        cell.lblMoeda.text = coinFavoritos[indexPath.row].name
        if let cotacao = Double(coinFavoritos[indexPath.row].priceBrl){
            //cell.lblCotacao.text = String(format: "%.2f",cotacao)
            let cotacaoString = converteValor(cotacao)
            cell.lblCotacao.text = "\(cotacaoString)"
        }
        
        cell.lblVariacao.text = "\(coinFavoritos[indexPath.row].percentChange24H!)%"
        
        //Mudar cor de acordo com a variacao
        let variacaoDouble = Double(coinFavoritos[indexPath.row].percentChange24H!)
        
        let dZero = 0.0
        
        if variacaoDouble!.isLess(than: dZero){
            cell.lblVariacao.textColor = UIColor.red
            //   cell.lblCotacao.textColor = UIColor.red
        } else {
            cell.lblVariacao.textColor = UIColor.green
            // cell.lblCotacao.textColor = UIColor.green
        }
        
        //Ibagem
        let url_string = "https://files.coinmarketcap.com/static/img/coins/32x32/"+coinFavoritos[indexPath.row].id+".png"
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
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //Deletar do CoreData
            let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let umFavorito = Favoritos(context: contexto)
            
            
//            umFavorito.id = coinFavoritos[indexPath.row].id
            umFavorito.setValue(coinFavoritos[indexPath.row].id, forKey: "id")

            print(umFavorito)
            contexto.delete(umFavorito)
            do{
                try contexto.save()
                print("Salvou o delete")
            }catch{
                print("Erro ao salvar    \(error)")
            }
            //Deletar Core Data
            
            coinFavoritos.remove(at: indexPath.row)
            tableView.reloadData()
            
//            //Deleta tudo do coredata
//            let delete = NSBatchDeleteRequest(fetchRequest: Favoritos.fetchRequest())
//
//            do{
//                try contexto.execute(delete)
//            } catch{}
            
        }
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nome = coinFavoritos[indexPath.row].name + " - " + coinFavoritos[indexPath.row].symbol
        simbolo = coinFavoritos[indexPath.row].symbol
        preco = coinFavoritos[indexPath.row].priceBrl
        strMarketCap = coinFavoritos[indexPath.row].marketCapBrl
        vol24h = coinFavoritos[indexPath.row].the24HVolumeBrl
        percChange1h = coinFavoritos[indexPath.row].percentChange1H!
        percChange24h = coinFavoritos[indexPath.row].percentChange24H!
        percChange7D = coinFavoritos[indexPath.row].percentChange7D!
    }
}
