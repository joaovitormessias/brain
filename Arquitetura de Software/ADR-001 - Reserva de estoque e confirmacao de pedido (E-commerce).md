___
Esta ADR registra uma decisao de referencia para um e-commerce: como confirmar um pedido sem vender estoque inexistente, mantendo latencia aceitavel e resiliencia quando dependencias (pagamento) falham. O objetivo e conectar decisoes a cenarios mensuraveis, reduzindo ambiguidade. A decisao escolhe um fluxo baseado em state machine do pedido + eventos (outbox) + compensacao (saga), para suportar retry e idempotencia e manter integridade em cenarios de concorrencia.
___

Links: [[Arquitetura de Software]]; [[Index]]; [[ADR (Resolucao Alternativa de Disputas)]]; [[Cenarios de Qualidade - E-commerce]]; [[Atributos de Qualidade (NFRs) e Cenarios]];

# Conteudo

## Titulo

ADR-001 — Reserva de estoque e confirmacao de pedido (E-commerce)

## Status

Proposto

## Decisao

Implementar o checkout como uma **state machine de pedido** com passos:
1. Criar pedido `PENDING` com idempotency key.
2. Reservar estoque (hard reservation) no servico de estoque.
3. Autorizar pagamento (nao capturar) no provedor.
4. Confirmar pedido `CONFIRMED` e capturar pagamento.

Usar **Outbox Pattern** para publicar eventos (`OrderCreated`, `StockReserved`, `PaymentAuthorized`, `OrderConfirmed`) de forma confiavel e suportar reprocessamento.

## Contexto

Os cenarios de e-commerce exigem:
- baixa latencia no checkout (p95 <= 800ms em pico),
- resiliencia a falhas do provedor de pagamento (modo fila + retry),
- consistencia para evitar oversell (0 eventos/dia).

Uma transacao unica entre estoque + pagamento nao e realista (dependencias externas e limites de ACID distribuido). Precisamos de um fluxo com compensacao e idempotencia.

## Opcoes consideradas

1. Transacao sincrona “tudo ou nada” (monolito com lock forte)
   - Pro: simples de entender no inicio.
   - Contra: nao escala bem, lock alto, dificil com pagamento externo, risco em falhas.

2. Saga orquestrada (pedido como orquestrador) + reserva + autorizacao + compensacao (DECISAO)
   - Pro: resiliente, suporta retry/idempotencia, evita oversell com reserva.
   - Contra: mais complexidade (eventos, estados, consistencia eventual em alguns pontos).

3. Pagamento primeiro e ajuste de estoque depois (tolerar oversell/backorder)
   - Pro: checkout rapido.
   - Contra: viola o cenario 3 se a politica exigir 0 oversell; pior UX em cancelamentos.

## Consequencias

Positivas:
- Evita oversell com reserva explicita.
- Suporta indisponibilidade de pagamento com retry (pedido pendente).
- Decisao fica diretamente conectada a cenarios mensuraveis.

Negativas / custos:
- Exige idempotencia, DLQ e reprocessamento.
- Mais estados e casos de borda (timeouts, duplicidade, compensacao).
- Observabilidade se torna obrigatoria (correlation id, tracing).

## Links para cenarios

- Atende: [[Cenarios de Qualidade - E-commerce]] (Cenario 2 e 3 principalmente)
