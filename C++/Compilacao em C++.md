
___
Esta nota descreve o fluxo de compilacao em C++ e porque ele importa para entender erros, performance e o funcionamento de projetos reais. O objetivo e criar uma visao clara das etapas (pre processamento, compilacao, geracao de objeto e linkedição) e dos artefatos gerados (.i/.ii, .obj/.o, bibliotecas e executavel). Com isso, fica mais facil diagnosticar warnings, symbols faltando, problemas de include e entender o papel de cada ferramenta.
___

Links: [[C++]]; [[Index]]; [[Por que a programacao de baixo nivel existe?]]; [[O que sao os linkers em C++]]; [[Como funciona o pre processamento em C++]];

# Conteudo

## Compiladores

A compilacao em C++ e parte mais fundamental e mais interessante quando estamos falando sobre programacao de baixo nivel. Ela tem como objetivo tornar nosso arquivo `.cpp` em um `.exe` mas para isso existe um processo divido em etapas para que essa compilacao seja um sucesso: comecando pelo pre processamento que carrega as informacoes do arquivo, em seguida gera um `.obj`, a partir desse arquivo entra a parte de linkers que vao carregar tudo em um unico executavel.
