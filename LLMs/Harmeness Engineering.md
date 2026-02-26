

___
Harness (aqui escrito como “Harmeness”) Engineering descreve a engenharia do ambiente que torna um agente util e confiavel: limites, ferramentas, instrumentacao, testes e invariantes. A ideia e que documentacao so nao garante coerencia quando muito codigo e gerado por agentes; em vez disso, o sistema precisa impor estrutura e validacao. Esta nota resume pontos do artigo da OpenAI e conecta com arquitetura de sistemas e boas praticas de engenharia.
___

Links: [[LLMs]]; [[Index]]; [[O que e arquitetura de sistemas]]; [[Context Engineering para o Vault]]; [[Sistema de Conhecimento]];

# Conteudo

<b>Quando tudo é "importante", nada o é</b>

Fonte: [artigo](https://openai.com/index/harness-engineering/)

---

Por exemplo, tornamos o aplicativo inicializável por árvore de trabalho do Git, para que o Codex pudesse iniciar e controlar uma instância por alteração. Também integramos o protocolo Chrome DevTools ao ambiente de execução do agente e criamos habilidades para trabalhar com snapshots do DOM, capturas de tela e navegação. Isso permitiu que o Codex reproduzisse bugs, validasse correções e analisasse o comportamento da interface do usuário diretamente.

Essa abordagem esclareceu muitas compensações. Priorizamos dependências e abstrações que pudessem ser totalmente internalizadas e analisadas no repositório. Tecnologias frequentemente descritas como "chatas" tendem a ser mais fáceis de modelar para os agentes devido à sua capacidade de composição, estabilidade da API e representação no conjunto de treinamento. Em alguns casos, era mais barato fazer com que o agente reimplementasse subconjuntos de funcionalidades do que contornar o comportamento opaco de bibliotecas públicas. Por exemplo, em vez de usar um pacote genérico no estilo `map`, implementamos nossa própria função auxiliar de mapeamento com concorrência: ela está totalmente integrada à nossa instrumentação OpenTelemetry, possui 100% de cobertura de testes e se comporta exatamente como nosso ambiente de execução espera. `p-limit`

A documentação por si só não mantém a coerência de uma base de código totalmente gerada por agentes. **Ao impor invariantes, em vez de microgerenciar implementações, permitimos que os agentes sejam lançados rapidamente sem comprometer a base.** Por exemplo, exigimos que o Codex analise formatos de dados no limite, mas não somos prescritivos sobre como isso acontece (o modelo parece gostar do Zod, mas não especificamos essa biblioteca em particular).

Os agentes são mais eficazes em ambientes com limites rígidos e estrutura previsível. Assim, construímos a aplicação em torno de um modelo arquitetônico rígido. Cada domínio de negócio é dividido em um conjunto fixo de camadas, com direções de dependência estritamente validadas e um conjunto limitado de arestas permitidas. Essas restrições são aplicadas mecanicamente por meio de linters personalizados (gerados pelo Codex, é claro!) e testes estruturais.

---

Agora virou uma questao arquitetonica de como produzir um software. Se a pessoa souber conceitos como arquitetura de sistemas e tiver um conhecimento sobre ciclos de vida de um projeto alem de saber dividir grandes problemas em problemas menores e obviamente conseguir expressar essas informacoes em poucas palavras ela e capaz de dirigir um projeto por contra propria, pois sao exatamente esses padroes que ajudam o desenvolvedor a crescer na carreira atualmente. De forma alguma digo que os `real Devs` (devs que desenvolvem sites sem uso de IA) ficam para tras, pelo contrario, acho que eles sao os que mais ganham pelo fato de saberem como fazer, mas desenvolver uma diretriz que visa corrigir esse gargalo na hora de delegar a tarefa para um agente e vantajoso tambem, arquitetura de sistemas + boas praticas + tipagem + aprofundamento + conhecimento da regra de nogocio = agente que faz tudo.
