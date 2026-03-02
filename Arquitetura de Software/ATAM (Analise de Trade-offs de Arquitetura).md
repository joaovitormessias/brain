___
ATAM (Architecture Tradeoff Analysis Method) e um metodo para avaliar uma arquitetura a partir de atributos de qualidade e identificar riscos cedo. Esta nota descreve uma versao “leve” e aplicavel: capturar cenarios prioritarios, mapear escolhas arquiteturais que afetam esses cenarios e listar sensitivities, trade-offs e riscos. O objetivo e substituir discussoes subjetivas por um processo repetivel que gera resultados acionaveis e alimenta ADRs.
___

Links: [[Arquitetura de Software]]; [[Index]]; [[Fundamentos de Arquitetura de Sistemas]]; [[Atributos de Qualidade (NFRs) e Cenarios]]; [[Cenarios de Qualidade - E-commerce]]; [[ADR (Resolucao Alternativa de Disputas)]];

# Conteudo

## ATAM leve (passo a passo)

1. Declare drivers: objetivos de negocio + restricoes.
2. Liste atributos de qualidade e priorize.
3. Escreva cenarios mensuraveis (top 5–10).
4. Para cada decisao arquitetural, responda:
   - qual cenario melhora?
   - qual piora?
   - qual risco introduz?
5. Registre:
   - **Sensitivity points** (onde pequenas mudancas geram grande impacto)
   - **Trade-offs** (ganha X, perde Y)
   - **Riscos** (incertezas ou apostas)
6. Converta em ADRs e backlog (mitigacoes e validacoes).

## Saidas praticas

- Lista priorizada de riscos arquiteturais
- Decisoes que precisam de experimento/prototipo
- Critérios objetivos para “aceitar” uma arquitetura
