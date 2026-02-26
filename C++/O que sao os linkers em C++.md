
___
Esta nota explica o papel do linker na geracao do executavel: resolver simbolos, combinar objetos e bibliotecas, escolher implementacoes e produzir o binario final. O objetivo e entender erros classicos (undefined reference, duplicate symbol), diferenca entre linking estatico e dinamico e como bibliotecas sao organizadas. Isso ajuda a diagnosticar problemas de build e a entender como dependencias entram no executavel.
___

Links: [[C++]]; [[Index]]; [[Compilacao em C++]];

# Conteudo

Pontos para detalhar:
- Entradas: `.o/.obj`, `.a/.lib`, `.so/.dll`.
- Resolucao de simbolos e ordem de bibliotecas.
- Linking estatico vs dinamico (trade-offs).
- Ferramentas e inspecao (nm/objdump/readelf, quando aplicavel).
