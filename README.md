# Iceberg Local com Trino + Nessie + MinIO
Neste projeto apresento uma alternativa para simular arquitetura de Big Data e arquivos S3 localmente.  

Para que fique claro sobre a extenção flexibilidade da solução, adicionando ainda nesse projeto endpoints no FastAPI pra execução dos Métodos e um tutorial para executar querys diretamente no SQLPad.

O consumo de dados no formato **S3 Iceberg** que é praticamente uma solução absoluta quando se trata de armazenamento e leitura de arquivos distribuídos em cenários de alto volume de dados.

Entretando para economizar em pesquisa em desenvolvimento, existe hoje alternativas para disponibilizar S3 Iceberg localmente com leitura de dados em SQL.

> Claro que cada solução e ferramenta possuem caracteristicas únicas que não serão identificas á AWS, havendo até algums desvantagens que detalho mais para frente. 

Mesmo assim, vejo aqui já um grande avanço nesse sentido. Acredito que no futuro, teremos ainda mais soluções OPEN SOURCE padronizadas (próximas) das soluções de mercado existentes para atender aos requisitos de migração e multi-cloud.

### Como instalar
* Necessário ter Docker e Docker-compose (ou Podman + Podman Compose) instalado
* Utilizar o comando `docker-compose up` ou `podman-compose up` no diretório do repositório
* Aplicação roda em [http://0.0.0.0:8000/](http://0.0.0.0:8000/) ou [http://localhost:8000/](http://localhost:8000/) por padrão
* Verificar da API [documentação](http://localhost:8000/docs): ([http://localhost:8000/docs](http://localhost:8000/docs))

#### Serviços instalados em container
  - **Trino**: http://localhost:8080/
    > _user: `admin`_
  - **Nessie**: http://localhost:19120
    > _user: `admin`, password: `password`_
  - **MinIO** http://localhost:9001/
    > _user: `admin`, password: `password`_
  - **SQLPad**: http://localhost:3000/
    > _user**: `admin`, password: `admin`_
  - **FastAPI**: http://localhost:8000/
    > _no autentication_

# Arquitetura
![elementos de arquitetura](./images/arquitetura_s3_iceberg_trino.png)

O **TRINO** é a grande estrela como **Query Processor de Big Data**. Ele se conecta ao **MinIO** para persistir os dados em formato **S3 (armazenamento distribuído)** e o **Nessie** que gerencia o **catalogo** dos arquivos armazenados em formato Iceberg.
As plataformas/ferramentas que manipulam os dados (**PySpark** e **SQLPad**) também devem se conectar ao **TRINO** para fazer uso da arquitura de Big Data no fomato de arquivos S3 Iceberg.
E assim, temos de modo democatico recursos do "S3 Iceberg" localmente.

Como o projeto também esta em **Docker** com algum ajuste é totalmente possível escalar para kubernets.

| :city_sunrise: |Aplicação| O que é|
|-----|:-----:|-------------|
| <img src="images/minio_icon.png" alt="minio ico" style="width:200px; height:100%"> | **[MinIO](https://min.io/docs/minio/container/operations/installation.html)**| Solução robusta de armazenamento de objetos compatível com o protocolo S3 da AWS para grande volume de dados não estruturados, como arquivos de mídia, logs, backups e dados analíticos.|
| <img src="images/nessie_icon.png" alt="nessie ico" style="width:200px; height:100%"> | **[Nessie](https://projectnessie.org/)** | Catálogo de dados que oferece versionamento para dados em Lake-Data. Da suporte no armazenamento de arquivos Iceberg. Permite criar branches e tags para dados, ajuda também visualização em relação a organização dos catalogos, schemas e tabelas. |
| <img src="images/trino_icon.png" alt="trino ico" style="width:200px; height:100%"> | **[Trino](https://trino.io/docs/current/installation/containers.html)** |  Essa é a estrela do show. Mecanisco de consulta de SQL distribuído, permite executar consultar em tempo real sobre diversas fontes de dados NoSQL, bastando apenas adiocionar novos catalogos para acessar novas origens. |
| <img src="images/fastapi_icon.png" alt="fastapi ico" style="width:200px; height:100%"> | **[FastAPI](https://fastapi.tiangolo.com/#example)** | Framework Python, usado para criar APIs RESTful com facilidade e velocidade. |
| <img src="images/pyspark_icon.png" alt="pyspark ico" style="width:200px; height:100%"> | **[PySpark](https://spark.apache.org/docs/latest/api/python/index.html)** | Interface Python para o Apache Spark, usada para processamento distribuído de grandes volumes de dados em cluster |
| <img src="images/sqlpad_icon.png" alt="sqlpad ico" style="width:200px; height:100%"> | **[SQLPad](https://getsqlpad.com/en/introduction/)** | Manager de consultas SQL, possui diversos conectores. Permite colaboração de querys e dashborads via interface web|
| <img src="images/docker_icon.png" alt="docker ico" style="width:200px; height:100%"> | **[Docker](https://www.docker.com/get-started/)** | Plataforma para criar, distribuir e executar aplicações em contêineres isolados.|
| <img src="images/podman_icon.png" alt="podman ico" style="width:200px; height:100%"> | **[Podman](https://podman.io/get-started)** | Tem o mesmo objetivo do Docker, incluive possui alta compatibilidade (mesmos comandos) que o Docker, porém consume menos recursos de máquina no desenvolvimento local ***(super recomendo!)*** :rocket:.|

### Resumo do conjunto...

  A reunião dos 3 principais componentes (**Trino** + **Nessie** + **MinIO**) nos permite *"simular"* o de ambiente de armazenamento e processamento distribuído localmente (com menos recursos).

  ![evidencia 03 S3 Iceberg](./images/03-s3-iceberg.png)

  No meu caso, por exemplo, minha máquina tinha apenas 8GB de RAM. E foi possível realizar testes de menor escala para experimentar a tecnologia de processamento distribuído que geralmente exige um hardware mais pesado.

### Demais protagonistas

  Fiz uso das biblitecas em **Python**: **FastAPI**, **PySpark**, **SqlAlquemy** e PyTrino. Elas executam a manipulação dos dados.

  **PODMAN** foi totalmente relevante para esse projeto. Uma alernativa ao **DOCKER** instalar container com menos recurso de máquina que o Docker. Claro que existe *diferença de arquitetura entre PODMAN x DOCKER*, porém, para desenvolvimento local, percebi vantagem considerável no uso **PODMAN**. Como falei minha máquina tem apenas 8GB.

  **SQLPad** ajuda a apresentar um caso de uso mais direto e simples de como consumir a arquitetura de Big Data com Trino.

## Como usar...

1. **Instalar a imagem**
  Estando no diretório do projeto, com Docker:
   ```
   docker-compose up
   ```
   ... ou Podman:
   ```
   podman-compose up
   ```

2. **Leia a documentação em Swagger**
  Documentação: [htpp://localhost:8000/docs](htpp://localhost:8000/docs)

3. **Execute os testes disponiveis no Swagger**
   É essencial ter resultado como "TUDO OK""
   [IMAGEM GIF dos testes]

4. **Uso com SQLPad**
   Acesse http://localhost:3000
   > user `admin`, passord: `admin`
      
   E execute  a query de para criar o Schema e Tabela com particionamento em ANO, MES e DIA em formato S3 Iceberg.
   
   A query já esta pronta e também irá acrescentar 20 registros na tabela "tb_vendas".

   O script SQL já esta cadastrado no projeto. Basta ir no menu "Querys" e selecionar: "1. Query START!".
   
   Para executar, clique no botão "RUN" na parte superior a direita.
   ![sqlapd create table](./images/sqlpad_create_table.gif)

   **Visualize o relatório**
   O script do relatório de vendas por dia também já esta disponivel no projeto.
   Agora selecione a query: "2. Vendas por dia".
   ![sqlapd vendas](./images/sqlpad_venda_dia.gif)

5. **Monitore as querys executadas no Trino**
   Acesse http://localhost:8080
   > user `admin`
   
   [IMAGEM]

6. **Visualize o catalogo Iceberg gerado pelo Nessie**
   Acesse http://localhost:17070
   > user `admin`, password: `password`
   
   ![nessie](./images/nessie_navegacao.gif)
 
   `http://localhost:19120/content/main/db/tb_vendas`
7. **Visualize os arquivos gerado no S3 pelo MinIO**
   > user `admin`, password: `password`
   
   O observe que o particionamento é feito por separação de diretórios em ANO, MÊS e DIA
   ![sqlapd vendas](./images/minio_navegacao.gif)


## Conclusão
Como nem tudo são flores... Não foi possível conectar o SPARK diretamente ao NESSIE+MINIO (o que traria maior performance). Embora exista documentação na página dos desenvolvedore. Depois de muitos testes *(acredite! muitos!)*. Concluí que até pode ser uma possíbilidade, entretanto no ambiente local com praticamente 1 core executando em cada aplicação e poquissíma mémoria para esse tipo de aplicação, não foi possivel experimentar os demais cenários com hardware mais potente.
A pesquisa sobre a solução do S3 iceberg num ambiente local foi que mais me consumiu tempo e esforço. Principalmente porque as ferramentas OPEN SOURCE disponíveis ainda não estão complementa maduradas e são promissoras. Porém ainda existem muitos bugs a serem corrigidos e recursos a serem desenvovidos por isso o uso delas deve ser com cautela. 
Me diverti! Penso que é conhecimento rico que me provoca pensar em futuros esforços como o de migração de dados considerando o multi-cloud.

~~Colocar mais diagramas de arquietura com detalhes de cada etapa de conectivide.~~

### References
- https://medium.com/@faruk13/alpine-slim-bullseye-bookworm-noble-differences-in-docker-images-explained-d9aa6efa23ec
- https://getsqlpad.com/en/configuration/?id=backend-database-management#application-configuration-general

## How install
- podman build -t python-alpine .
  * -t atrituto para informar a tag da imagem
- podman run -it python-alpine
  -it atriubto para ser interativo
- podman run -p 8000:8000 --replace --name python-alpine python-alpine
  -relace substitui o container caso já existe laguma com esse nome


## Monitore
- podman stats -a --no-stream 

#### Manutenção of container
podman ps -a
podman logs <container_id>


