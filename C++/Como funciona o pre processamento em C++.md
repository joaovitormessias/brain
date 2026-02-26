
___
Esta nota aprofunda a etapa de pre processamento em C++: inclusao de headers, macros, compilacao condicional e geracao do codigo “expandido” que o compilador realmente consome. O objetivo e entender como `#include` e `#define` afetam build, tempo de compilacao e bugs comuns (includes circulares, macros inesperadas, divergencias por flags). Tambem serve como ponte para diagnosticar problemas de toolchain e padronizar configuracoes.
___

Links: [[C++]]; [[Index]]; [[Compilacao em C++]];

# Conteudo

Pontos para detalhar:
- O que o pre processador produz (.i/.ii).
- Ordem de inclusao e include guards (`#pragma once` vs `#ifndef`).
- Macros: vantagens, riscos e alternativas (`constexpr`, templates).
- Flags e definicoes por target (debug/release, plataforma).
