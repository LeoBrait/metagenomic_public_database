#this folder need some decisions to be made

## 1.3 Filtragem baseado nos sumários de dados genômicos
- Após baixadas todas as amostras, empregamos filtros de qualidade genômicos, (mais detalhes [aqui](link_do_download) ) e sumarizamos as informações genômicas de cada amostra em uma [tabela](genomic_content_summaries/genomic_content_summaries.csv) (n= 6,015). As informações sumarizadas foram:  
```
file_size                       total_number_of_reads
GC_content                      total_number_of_bases
complete_sequence_size          average_read_size
read_size_mode                  read_size_median
lowest_read_size                highest_read_size
```
- A partir deste dado sumarizado, removemos todas as amostras a partir de 10 mil reads