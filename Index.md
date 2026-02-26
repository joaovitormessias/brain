___
Este Index e o ponto de entrada do vault: ele lista os modulos (assuntos-base), define quando um assunto novo vira modulo ou topico e conecta a camada operacional de busca. O vault agora usa roteamento progressivo: primeiro classificar tarefa com artefatos leves, depois abrir modulo e so entao topicos especificos. Isso melhora legibilidade, reduz consumo de tokens e ajuda a manter crescimento consistente para conteudos atuais e futuros.
___

Links: [[C++]]; [[Arquitetura de Software]]; [[Conhecimento Geral]]; [[LLMs]]; [[Sistema de Conhecimento]]; [[_Artefatos/PLAYBOOK]];

# Conteudo

Esta dividido em modulos. Cada pasta representa um modulo, e a nota do modulo aponta para seus topicos:

- [[C++]]
- [[Arquitetura de Software]]
- [[Conhecimento Geral]]
- [[LLMs]]
- [[Sistema de Conhecimento]]

Cada um desses modulos tem ligacao com outros topicos que levam a outro conteudo. O objetivo e sempre acrescentar mais um artefato para o modulo que iremos trabalhar em cima, resultando em um novo topico ou aumentando/melhorando o topico que estamos trabalhando.

Fluxo de consulta de baixo custo:
1. Consultar `_Artefatos/router.yaml`.
2. Filtrar candidatos em `_Artefatos/catalogo.jsonl`.
3. Expandir relacoes em `_Artefatos/crosslinks.jsonl`.
4. Abrir notas completas apenas no fim.
