___
Esta nota consolida os fundamentos praticos de arquitetura de sistemas: o que precisa ser decidido, como transformar requisitos em decisao arquitetural e como reduzir risco tecnico cedo. O foco e pensar em arquitetura como trade-offs orientados por atributos de qualidade (confiabilidade, latencia, seguranca, custo e evolucao). Ela serve como “mapa” do modulo, conectando ADRs, cenarios de qualidade e tecnicas de avaliacao para que as escolhas fiquem explicitas e revisaveis ao longo do tempo.
___

Links: [[Arquitetura de Software]]; [[Index]]; [[O que e arquitetura de sistemas]]; [[ADR (Resolucao Alternativa de Disputas)]]; [[Atributos de Qualidade (NFRs) e Cenarios]]; [[ATAM (Analise de Trade-offs de Arquitetura)]]; [[Cenarios de Qualidade - E-commerce]];

# Conteudo

## Ideia central (o novo)

Arquitetura vira mais “objetiva” quando voce escreve **cenarios de atributos de qualidade**.
Em vez de discutir “microservices vs monolito”, voce discute:
- qual latencia e aceitavel,
- qual disponibilidade e necessaria,
- quais riscos de seguranca sao toleraveis,
- quanto custa operar,
- como o sistema deve evoluir sem quebrar.

Esses cenarios viram entradas para ADRs e para avaliacao (ex.: ATAM).

## O que arquitetura precisa decidir

- Fronteiras: dominios, responsabilidades, ownership.
- Dados: onde mora a fonte de verdade, consistencia, integracao.
- Confiabilidade: retries, timeouts, degradacao, filas.
- Observabilidade: logs, metricas, traces, SLOs.
- Seguranca: identidade, autorizacao, segredos, auditoria.
- Evolucao: compatibilidade, migracoes, versionamento, testes.

## Checklist rapido (para comecar um projeto)

1. Liste 3–5 atributos de qualidade prioritarios (com ordem).
2. Escreva 1 cenario por atributo (formato: gatilho -> resposta -> medida).
3. Proponha 1–3 opcoes arquiteturais e registre em ADR.
4. Rode uma avaliacao leve (mini-ATAM): riscos, sensitivities, trade-offs.
