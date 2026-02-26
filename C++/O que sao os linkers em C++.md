
___
Da funcionalidade dos linkers em C++
___

Os linkers tem como objetivo trazer para o codigo funcoes/classes/metodos de outros arquivos que venhamos a utilizar, alem disso ele verifica se a sintaxe esta correta. Por exemplo:

Eu tenho meu arquivo `exampleone.cpp`:

```
#include <iostream>

void Log(char* message) {
	std::cout << message << std::endl;
}
	
```

E outro arquivo `exampletwo.cpp`:

```
void Log(char* message);

int main(){
	Log("Message");	
}
```

