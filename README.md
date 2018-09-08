#  Projet 9
## Les Bonus du Baluchon
### L'application Baluchon
Baluchon est un sac de voyage virtuel avec des outils indispensables pour les voyages à l'étranger.

**l'application se compose de trois fonctionnalitées principales :**
* Le taux de change
* La traduction
* La météo
### Les Bonus
**Plusieurs fonctionnalitées bonus ont été rajoutées à l'application Baluchon :**

> 1. La conversion de monnaies dans de nombreuses devises
> 2. la conversion de monnaies peut ce faire de n’importe quelle monnaie à n’importe quelle monnaie parmi celles proposées
> 3. la possibilité d’afficher la météo de nombreuses villes dans le monde.
> 4. la possibilité d’ajouter ou d’enlever n’importe quelles villes de notre affichage
> 5. Un sélecteur pour échanger la langue d'origine et la langue de destination pour la traduction.
> 6. la possibilité de traduire dans n’importe quelles langues proposées.

### Implémentation des Bonus
>> 1. La conversion de monnaies dans de nombreuses devises

afin de pouvoir convertir les monnaies dans de nombreuses devises, nous allons récupérer tous les taux de changes proposés par fixer.io dans un objet grâce à notre appel réseau et créer une propriété "*change*" avec cet objet.

    let change = object as? Change

avant de pouvoir utiliser cet objet nous allons chaîner notre appel réseau avec un deuxième appel pour récupérer toujours sur fixer.io avec une deuxième API la liste des monnaies dans un objet et de même que pour les taux créer une propriété appelée "*money*".

    let money = object as? Money

Ensuite nous aurons plus qu'à passer les deux objet dans notre callback à notre controller, voici ce que ça donne dans "*ChangeService*" :

    func getChange(callback: @escaping (String?, Change?, Money?) -> Void) {
        changeRouter.request(changeAPI, changeSession, Change.self) { (error, object) in
            DispatchQueue.main.async {
                guard error == nil else {
                    callback(error, nil, nil)
                    return
                }
                self.getMoney { (error, money) in
                    guard let money = money else {
                        callback(error, nil, nil)
                        return
                    }
                    let change = object as? Change
                    callback(nil, change, money)
                }
            }
        }
    }

Le controller n'aura plus qu'à appeler la méthode :

    private func changeValueText(_ moneyToConvertName: String, _ moneyConvertedName: String, _ sender: UITextField)

par le biais d'Action, elle même appelera la méthode "*changeMoney*" de "*ChangeService*" pour faire le calcul selon les choix effectués par l'utilisateur grâce aux pickerViews de choix des monnaies et bien sûr selon le nombre à convertir :

    func changeMoney(_ moneyToConvertName: String, _ moneyConvertedName: String,_ valueNeedToConvert: String,_ change: Change,_ money: Money) -> Double {

        let abreviationOne = searchMoney(moneyName: moneyToConvertName, moneyData: money)
        let abreviationTwo = searchMoney(moneyName: moneyConvertedName, moneyData: money)
        let moneySelectedValueForOneEuro = change.rates[abreviationOne]!
        let currencyWeNeed = change.rates[abreviationTwo]!

        var number: Double
        guard (Double(valueNeedToConvert) != nil) else {
            return 0
        }
        number = Double(valueNeedToConvert)!
        var result : Double
        if moneySelectedValueForOneEuro == 1.0 {
            result = number * currencyWeNeed
        } else {
            let numberToConvert = number / moneySelectedValueForOneEuro
            result = numberToConvert * currencyWeNeed
        }
        return result
    }

Cette méthode comme on peut le voir ci-dessus va d'abord retrouver l'abréviation de la monnaies désigné par l'utilisateur pour rechercher le taux de celle ci dans l'objet "*change*"

Ensuite selon le choix de la monnaie d'origine et le choix de la dévise souhaitée faire le calcul.

>>  2. la conversion de monnaies peut ce faire de n’importe quelle monnaie à n’importe quelle monnaie parmi celles proposées

Ce bonus est principalement géré par les pickersViews et les textFields qui vont permettre avec les objets et méthodes précédement expliqués la conversion de monnaies dans n'importe quel sens voulu par l'utilisateur.

la modification d'un textField entrainera instantanément le calcul et l'affichage du résultat dans le deuxième textField.

le changement d'un pickerViews changera instantanément la valeur calculé dans le textField opposé.

> Voici une animation présentant ce bonus.

![démonstration du bonus](ImagesReadme/tauxdechange.gif)
