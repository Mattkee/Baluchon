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

afin de pouvoir convertir les monnaies dans de nombreuses devises, nous allons récupérer tous les taux de changes proposés par fixer.io dans un objet grâce à notre appel réseau et créer une propriété *change* avec cet objet.

    let change = object as? Change



