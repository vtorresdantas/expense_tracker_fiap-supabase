# Projeto de Carteira de Investimentos com Flutter e Supabase

## Descrição do Projeto

O Projeto de Carteira de Investimentos é uma aplicação móvel desenvolvida em Flutter que permite aos usuários acompanhar e gerenciar seus investimentos de forma eficiente. Além disso, integra-se ao Supabase, uma plataforma poderosa de banco de dados, para a inserção e consulta de dados de investimentos.

## Funcionalidades Principais

- **Registro de Investimentos**: Os usuários podem adicionar informações sobre seus investimentos, como tipo de ativo, valor investido, data de compra, etc.

- **Consulta de Investimentos**: Os usuários podem visualizar uma lista de todos os investimentos registrados.

- **Dashboard**: A aplicação fornece gráficos e estatísticas para ajudar os usuários a acompanhar o desempenho de seus investimentos ao longo do tempo.

## Tecnologias Utilizadas

- [Flutter](https://flutter.dev/): Um SDK de código aberto para criar aplicativos nativos para Android e iOS a partir de uma única base de código.

- [Supabase](https://supabase.io/): Uma plataforma de banco de dados com funcionalidades de API e autenticação incorporadas.

## Como Instalar

1. Clone o repositório.
2. Instale as dependências utilizando `flutter pub get`.
3. Configure as credenciais do Supabase no arquivo `supabase_config.dart`.

## Configuração do Supabase

Para integrar o Supabase com o projeto, é necessário criar um projeto no Supabase, obter as credenciais e configurá-las no arquivo `supabase_config.dart`.

```dart
const supabaseUrl = 'https://aivbcfhzibzqtroyknwi.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFpdmJjZmh6aWJ6cXRyb3lrbndpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTYzNzYzMDksImV4cCI6MjAxMTk1MjMwOX0.phGU2mhl9DQC1UxoYQwEeypcuaHTk3-JlDbOxj_UY3A';
