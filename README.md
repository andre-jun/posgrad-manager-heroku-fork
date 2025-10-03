# posgrad-manager

## Motivação

O desenvolvimento desta aplicação surgiu da vontade de apoiar a **Comissão Coordenadora de Curso (CCG) do curso de SI da EACH/USP**, no contexto da pós-graduação.  

Atualmente, muitos dos processos de acompanhamento, controle e gestão acadêmica são realizados de forma **manual, descentralizada e burocrática**, o que torna o trabalho mais lento, suscetível a erros e de difícil manutenção.  

A motivação principal do projeto é **simplificar e automatizar** essas rotinas, oferecendo uma ferramenta unificada que facilite:  

- o acompanhamento de alunos,  
- a organização de disciplinas,  
- a geração de relatórios,  
- e a comunicação entre os envolvidos na pós-graduação.  

Dessa forma, a aplicação contribui para reduzir a complexidade dos processos internos e otimizar o tempo da equipe, permitindo que o foco esteja no que realmente importa: a qualidade da formação acadêmica.

---

## Como rodar o projeto

### Pré-requisitos

Antes de começar, você precisa ter instalado:

- [Ruby](https://www.ruby-lang.org/) (3.4.6)  
- [Bundler](https://bundler.io/)  
- [SQLite](https://sqlite.org/)

---

### Rodando localmente

```bash
# clonar o repositório
git clone https://github.com/GuilhermeSantosGabriel/posgrad-manager.git
cd posgrad-manager

# instalar dependências Ruby
bundle install

# configurar banco de dados
rails db:migrate

# iniciar servidor
rails server
```

Depois acesse no navegador:
http://localhost:3000
