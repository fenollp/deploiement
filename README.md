Déploiement de projets Légilibre
================================

Ce dépôt contient quelques scripts pour déployer des projets de Légilibre. Pour l’instant, uniquement legi.py, mais hopefully Archéo Lex d’ici quelque temps.

Pour l’instant, c’est surtout un petit script shell qui crée un serveur, à voir si et comment ça peut évoluer : faire un script par projet + un script global ? faire un script global avec des choix ? ajouter d’autres hébergeurs/plate-formes ? quels languages : shell, Ansible, Puppet, Fabric, PHP, Python, Robo, Deployer(.org), plusieurs parmi ceux-ci pour ce que préfèrent les gens ?

legi.py
-------

Déploiement initial de legi.py (pas de mises à jour par cron pour l’instant, à faire) sur un serveur Gandi.

### Déploiement

À partir d’un environnement GNU/Linux qui ne sert que pour le lancement initial (CLIcodrome).

Procédure préliminaire :
1. Ouvrir et créditer un compte Gandi https://www.gandi.net
2. Installer Gandi CLI, configurer le API Token http://cli.gandi.net https://github.com/Gandi/gandi.cli
3. Enregistrer ta clé publique SSH dans Gandi, soit via le site, soit via Gandi CLI ($ gandi sshkey create)

Procédure liminaire :
1. Lancer le programme `create_gandi_server_legilibre.sh`
2. Ce programme
   a. crée une VM chez Gandi (environ 1 minute),
   b. te connecte à cette VM (mais tu n’as rien à y faire réellement à part regarder le calcul avec htop),
   c. installe legi.py qui télécharge la base LEGI (codes et lois français) et crée sa base de données SQLite (compter plusieurs heures)

Procédure post-liminaire :
3. Faire une pull request pour ajouter le cron (systemd) dans le script `deploy_legilibre.sh`
4. Faire une pull request pour ajouter le déploiement d’Archéo Lex (calcul des dépôts Git, hors site web dans un 1er temps)

### Notes

Caractéristiques du serveur créé :
- 2 cœurs
- 4096 Mio de RAM
- dans le datacenter FR-SD5 (en France)
- disque de 10 Gio (suffisant dans un premier temps)
- une IPv4 (nécessaire pour télécharger la base LEGI / le serveur n’a actuellement pas d’IPv6 et Gandi n’a pas de passerelle NAT64)
- Debian 9
- crée un user Linux avec le nom actuel ($USER) et la clé SSH enregistrée chez Gandi

Voir `create_gandi_server_legilibre.sh` et modifier les paramètres si besoin. Le serveur par défaut coûte environ 33 €TTC/mois ; il est possible de le mettre en veille et il coûte alors environ 5 €TTC/mois à cause du disque et de l’IPv4 qui restent réservés.
