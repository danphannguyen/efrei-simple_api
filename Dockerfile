# 1. Utilisation d'une image Node légère
FROM node:20-alpine

# 2. Création du dossier de travail dans le conteneur
WORKDIR /app

# 3. Copie des fichiers de dépendances
# On le fait avant de copier le reste pour profiter du cache Docker
COPY package*.json ./

# 4. Installation des dépendances (uniquement prod pour la légèreté)
RUN npm install --omit=dev

# 5. Copie du reste du code source
COPY . .

# 6. L'API écoute sur le port 3000
EXPOSE 3000

# 7. Commande pour lancer l'API
CMD ["npm", "start"]