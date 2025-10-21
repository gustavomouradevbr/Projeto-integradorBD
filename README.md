# Guia de Fluxo de Trabalho do Git e GitHub

-----

### Para todos os membros do trio

Este guia foi feito para ser uma referência rápida de como trabalhar no nosso projeto usando o GitHub Desktop e o site do GitHub.

-----

### Passo 0: Configuração Inicial (Apenas na primeira vez)

1.  Se ainda não tiver, [baixe e instale o GitHub Desktop](https://desktop.github.com/).
2.  Abra o aplicativo e faça login com a sua conta do GitHub.
3.  Vá em **File** (Arquivo) \> **Clone repository** (Clonar repositório).
4.  Selecione o nosso projeto na lista e escolha uma pasta na sua máquina para clonar.
5.  Clique em **Clone**.

-----

### Passo 1: Começando um novo trabalho

Antes de começar a programar, sempre se certifique de que sua cópia do projeto está atualizada com as últimas mudanças da equipe.

1.  Abra o **GitHub Desktop** e selecione o nosso projeto na lista.
2.  Na parte superior, mude para a branch `main`.
3.  Clique no botão **"Fetch origin"** (Buscar origem) e depois em **"Pull origin"** (Puxar origem) para baixar as últimas alterações.
4.  Agora, crie uma nova branch para a sua tarefa. Clique no nome da branch (`main`) e digite o nome da nova branch (ex: `joao-tela-de-login`).
5.  Clique em **"Create new branch"**.

-----

### Passo 2: Fazendo e salvando seu trabalho

1.  Programe e faça as alterações necessárias nos arquivos do projeto.
2.  Ao terminar uma parte do trabalho, volte para o **GitHub Desktop**.
3.  Na aba **"Changes"** (Alterações), você verá todos os arquivos que foram modificados.
4.  Escreva um **"Summary"** (Resumo) curto e claro sobre o que você fez.
5.  Clique no botão **"Commit to \<nome-da-sua-branch\>"**.

-----

### Passo 3: Enviando seu trabalho para o GitHub

1.  Depois de fazer o commit, o botão no topo da tela mudará para **"Push origin"** (Empurrar origem). Clique nele.
2.  Isso enviará suas alterações para o repositório online no GitHub.
3.  O GitHub Desktop mostrará uma notificação para **criar um Pull Request**. Clique no botão para ir direto ao site.

-----

### Passo 4: Abrindo um Pull Request (PR)

O PR é onde a equipe pode revisar o seu trabalho antes de incluí-lo no projeto principal.

1.  Após o passo anterior, o site do GitHub abrirá automaticamente na página de criação do PR.
2.  Preencha o título e a descrição do seu Pull Request. Explique o que a sua mudança faz e por que ela é importante.
3.  Clique em **"Create pull request"**.
4.  Avise a equipe para que eles possam revisar seu código.

-----

### Passo 5: Finalizando o PR

1.  Quando seus colegas revisarem e aprovarem o seu PR, você poderá fazer o **merge** (unir) do seu código com a branch principal (`main`).
2.  Clique no botão **"Merge pull request"**.
3.  Depois de fazer o merge, clique em **"Delete branch"** para apagar a branch que você criou (ela não é mais necessária).

-----

### Dicas Importantes para o nosso fluxo de trabalho

  * **Comunicação é chave\!** Usem um chat para avisar que vocês estão criando uma branch, que fizeram um commit ou que precisam de uma revisão de código.
  * **Façam commits pequenos e frequentes.** É melhor fazer 5 commits com pequenas alterações do que 1 commit com 50 arquivos modificados. Isso facilita a revisão e evita erros.
  * **Sempre puxem a `main` branch** antes de começar a trabalhar. Isso garante que você está na versão mais atual do projeto.
