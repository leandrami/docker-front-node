#     Build da aplicação 

FROM node:20-alpine AS build 
# Imagem base com Node, usada só para instalar dependências e gerar o build (chamada de "build")

WORKDIR /app
# Diretório de trabalho dentro do container

COPY package*.json ./


RUN npm install


COPY . .


RUN npm run build
# Executa o build do Vite, gerando os arquivos estáticos otimizados (normalmente na pasta dist)



#     Servir com Nginx

FROM nginx:alpine
# Nova imagem, agora só com o Nginx, para servir os arquivos finais (descarta tudo da etapa anterior)

COPY --from=build /app/dist /usr/share/nginx/html
# Copia apenas a pasta "dist" gerada na etapa de build para a pasta padrão de arquivos do Nginx

COPY nginx.conf /etc/nginx/conf.d/default.conf
# Copia a configuração personalizada do Nginx (nginx.conf)

EXPOSE 80
# Container escuta na porta 80
