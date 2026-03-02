___
Esta nota ensina a transformar requisitos nao-funcionais (NFRs) em cenarios de qualidade mensuraveis, que orientam decisao arquitetural e evitam debates abstratos. Em vez de “o sistema precisa ser escalavel”, voce escreve um cenario com carga, limite, resposta esperada e medida (ex.: p95, RTO/RPO, taxa de erro). O objetivo e criar um vocabulário comum para time, produto e operacao, e usar esses cenarios como base para ADRs e avaliacao de trade-offs.
___

Links: [[Arquitetura de Software]]; [[Index]]; [[Fundamentos de Arquitetura de Sistemas]]; [[Cenarios de Qualidade - E-commerce]]; [[ADR (Resolucao Alternativa de Disputas)]];

# Conteudo

## Principais atributos (exemplos)

- Disponibilidade (SLO, uptime)
- Confiabilidade (erros, consistencia, recuperacao)
- Latencia (p50/p95/p99)
- Throughput (req/s, jobs/h)
- Escalabilidade (como cresce custo x carga)
- Seguranca (autenticacao/autorizacao, auditoria)
- Manutenibilidade/evolucao (tempo de mudanca, compatibilidade)
- Custo (cloud spend, custo por transacao)

## Formato de cenario (simples)

**Gatilho** -> **Resposta do sistema** -> **Medida**

Exemplo (latencia):
- “Quando houver 2.000 req/s no endpoint X -> responder sem degradar -> p95 <= 200ms e erro <= 0.1%”

Exemplo (recuperacao):
- “Quando a regiao cair -> failover -> RTO <= 15 min, RPO <= 5 min”

## Como usar no dia a dia

1. Para cada atributo prioritario, escreva 1–3 cenarios.
2. Em cada ADR, referencie quais cenarios a decisao atende (ou piora).
3. Transforme cenarios em testes/monitoramento quando possivel (SLOs).
