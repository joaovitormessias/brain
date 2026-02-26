
___
Esta nota discute por que programacao de baixo nivel existe e quando ela e necessaria: controle de memoria, desempenho, latencia, interoperabilidade e restricoes de plataforma. O objetivo e ligar a motivacao a exemplos concretos (sistemas, engines, embedded) e conectar com o entendimento do toolchain (compilacao e linking). A ideia nao e “otimizar tudo”, e sim saber quando o custo de abstracao importa.
___

Links: [[C++]]; [[Index]]; [[Compilacao em C++]];

# Conteudo

Pontos para detalhar:
- Custos de abstracao vs produtividade.
- Memoria (stack/heap), cache e latencia.
- Interop/ABI e chamadas para C.
- Quando “baixo nivel” e uma escolha errada.
