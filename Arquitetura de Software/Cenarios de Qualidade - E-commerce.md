___
Esta nota contem tres cenarios de atributos de qualidade para um e-commerce, escritos no formato “gatilho -> resposta -> medida”. O objetivo e tornar NFRs concretos e mensuraveis, para que discussoes arquiteturais virem trade-offs claros e revisaveis. Esses cenarios servem como entrada para ADRs (decisoes) e para avaliacao (ex.: ATAM leve), e podem ser refinados conforme o produto e a operacao evoluem.
___

Links: [[Arquitetura de Software]]; [[Index]]; [[Fundamentos de Arquitetura de Sistemas]]; [[Atributos de Qualidade (NFRs) e Cenarios]]; [[ATAM (Analise de Trade-offs de Arquitetura)]]; [[ADR-001 - Reserva de estoque e confirmacao de pedido (E-commerce)]];

# Conteudo

## Cenario 1 — Latencia (catalogo + checkout)

Gatilho:
- Pico promocional com 3.000 req/s em paginas de produto e 300 req/s no endpoint de criar pedido (checkout).

Resposta do sistema:
- Responder com degradacao controlada (ex.: recomendacoes off, features nao criticas desativadas) sem quebrar compra.

Medida:
- Produto: p95 <= 250ms, p99 <= 700ms, erro <= 0.2%
- Checkout (criar pedido): p95 <= 800ms, p99 <= 2s, erro <= 0.1%

## Cenario 2 — Disponibilidade e recuperacao (queda de dependencia/regiao)

Gatilho:
- Provedor de pagamento indisponivel por 10 minutos OU perda de uma regiao.

Resposta do sistema:
- Continuar navegacao e carrinho; checkout entra em modo “fila” (aceita pedido como pendente) e reprocessa quando o provedor voltar; evitar perda de pedidos.

Medida:
- Disponibilidade do fluxo de navegacao: >= 99.95% mensal
- Perda maxima de pedidos confirmados: 0
- RTO <= 15 min (voltar a operar plenamente)
- RPO <= 1 min (no maximo 1 minuto de dados nao replicados)

## Cenario 3 — Consistencia (nao vender estoque inexistente)

Gatilho:
- Dois clientes tentam comprar a ultima unidade do SKU X ao mesmo tempo.

Resposta do sistema:
- Garantir que apenas 1 pedido seja confirmado com estoque; o outro deve falhar com mensagem clara ou virar backorder (se a politica permitir).

Medida:
- Oversell (pedido confirmado sem estoque): 0 eventos por dia
- Tempo para confirmar ou negar: p95 <= 2s
- Precisao do estoque “disponivel para venda”: >= 99.9% (diferenca entre estoque real e exibido)
