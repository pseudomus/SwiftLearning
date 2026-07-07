# =========================================================
# Makefile — automação dos comandos do repositório
#
# Conceitos de Makefile usados aqui:
#
# 1) target: dependências
#        <TAB>comando
#    Cada bloco "nome-do-alvo:" é um "target" do make (nada a ver com
#    target do Xcode — é só terminologia do make). O comando abaixo
#    TEM que começar com TAB, não espaços, senão dá erro.
#
# 2) .PHONY
#    Por padrão, o make acha que um target gera um ARQUIVO com esse
#    nome. Como "generate", "build", "clean" não são arquivos, e sim
#    ações, listamos eles em .PHONY para o make não tentar checar se
#    já existe um arquivo chamado "build" no disco.
#
# 3) Variáveis
#    VAR := valor       -> atribuição imediata
#    VAR ?= valor       -> só atribui se a variável ainda não tiver valor
#    Uso: $(VAR)
#    Isso permite rodar: make build PROJECT=Concurrency
#
# 4) Variáveis automáticas ($@, $<, $^)
#    Não uso muito aqui, mas $@ = nome do target atual, útil em
#    Makefiles maiores.
# =========================================================

SHELL := /bin/bash
PROJECTS_DIR := Projects
TEMPLATE := Templates/project.yml.template
SIMULATOR ?= iPhone 16

# Projeto padrão caso você não passe PROJECT=
PROJECT ?= Concurrency

.PHONY: help generate generate-all build test clean open new-project list

help:
	@echo "Uso:"
	@echo "  make generate PROJECT=Concurrency     # roda xcodegen para 1 projeto"
	@echo "  make generate-all                     # roda xcodegen em todos os projetos"
	@echo "  make build PROJECT=Concurrency        # compila via xcodebuild"
	@echo "  make test PROJECT=Concurrency         # roda os testes"
	@echo "  make open PROJECT=Concurrency         # abre o .xcodeproj no Xcode"
	@echo "  make new-project NAME=Combine         # cria um novo projeto a partir do template"
	@echo "  make clean PROJECT=Concurrency        # remove o .xcodeproj gerado"
	@echo "  make list                             # lista os projetos existentes"

# --- Geração do .xcodeproj a partir do project.yml ---------------------

generate:
	@echo "==> Gerando $(PROJECT).xcodeproj"
	@cd $(PROJECTS_DIR)/$(PROJECT) && xcodegen generate

# Percorre todas as subpastas de Projects/ e roda xcodegen em cada uma.
# O "|| exit 1" garante que, se um projeto falhar, o make para em vez
# de continuar silenciosamente para o próximo.
generate-all:
	@for dir in $(PROJECTS_DIR)/*/; do \
		name=$$(basename "$$dir"); \
		echo "==> Gerando $$name"; \
		(cd "$$dir" && xcodegen generate) || exit 1; \
	done

# --- Build / test via xcodebuild ---------------------------------------

build: generate
	xcodebuild \
		-project $(PROJECTS_DIR)/$(PROJECT)/$(PROJECT).xcodeproj \
		-scheme $(PROJECT)App \
		-destination 'platform=iOS Simulator,name=$(SIMULATOR)' \
		build

test: generate
	xcodebuild \
		-project $(PROJECTS_DIR)/$(PROJECT)/$(PROJECT).xcodeproj \
		-scheme $(PROJECT)App \
		-destination 'platform=iOS Simulator,name=$(SIMULATOR)' \
		test

clean:
	rm -rf $(PROJECTS_DIR)/$(PROJECT)/$(PROJECT).xcodeproj
	@echo "==> $(PROJECT).xcodeproj removido (rode 'make generate' para recriar)"

open: generate
	open $(PROJECTS_DIR)/$(PROJECT)/$(PROJECT).xcodeproj

list:
	@ls $(PROJECTS_DIR)

# --- Scaffolding de novos projetos --------------------------------------
# Uso: make new-project NAME=Combine

new-project:
	@test -n "$(NAME)" || (echo "Uso: make new-project NAME=NomeDoProjeto" && exit 1)
	@mkdir -p $(PROJECTS_DIR)/$(NAME)/Sources/$(NAME)App
	@cp $(TEMPLATE) $(PROJECTS_DIR)/$(NAME)/project.yml
	@NAME_LOWER=$$(echo "$(NAME)" | tr '[:upper:]' '[:lower:]'); \
	sed -i.bak "s/__NAME_LOWER__/$$NAME_LOWER/g; s/__NAME__/$(NAME)/g" $(PROJECTS_DIR)/$(NAME)/project.yml; \
	rm $(PROJECTS_DIR)/$(NAME)/project.yml.bak
	@cp Templates/App.swift.template \
    	$(PROJECTS_DIR)/$(NAME)/Sources/$(NAME)App/$(NAME)App.swift

	@sed -i.bak \
    	"s/__NAME__/$(NAME)/g" \
   		$(PROJECTS_DIR)/$(NAME)/Sources/$(NAME)App/$(NAME)App.swift

	@rm $(PROJECTS_DIR)/$(NAME)/Sources/$(NAME)App/$(NAME)App.swift.bak
	@echo "==> Projeto $(NAME) criado em $(PROJECTS_DIR)/$(NAME)"
	@echo "==> Rode: make generate PROJECT=$(NAME)"
