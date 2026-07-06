# Publicar iOS sem Mac (Linux + Nuvem)

Este guia foi feito para o projeto QuarkGPS iOS e funciona sem Mac local.

## Resposta direta

- Compilar iOS localmente no Linux: nao e suportado pela Apple (Xcode so existe para macOS).
- Compilar iOS sem possuir Mac: sim, usando CI em macOS na nuvem (Codemagic, Bitrise, GitHub Actions macOS, MacStadium).

## Requisitos obrigatorios

1. Conta Apple Developer ativa (USD 99/ano)
2. Conta App Store Connect com permissao de Admin ou App Manager
3. Bundle Identifier unico (atual: com.quarkgps.ios)
4. App icon 1024x1024 valido
5. Politica de privacidade publica (URL)

## Caminho recomendado (mais simples): Codemagic

Ja foi criado o arquivo:
- codemagic.yaml

### 1) Subir projeto para GitHub

1. Crie um repositorio no GitHub
2. Envie a pasta QuarkGPS-iOS para esse repositorio

### 2) Criar App no App Store Connect

1. Acesse App Store Connect
2. Apps > botao + > New App
3. Plataforma: iOS
4. Nome do app: QuarkGPS (ou o nome final)
5. Bundle ID: com.quarkgps.ios (ou ajuste para o seu)
6. SKU: codigo interno unico (exemplo: quarkgps-ios-001)

### 3) Criar chave de API do App Store Connect

1. App Store Connect > Users and Access > Integrations > App Store Connect API
2. Crie uma chave com permissao App Manager
3. Baixe o arquivo .p8
4. Guarde Key ID e Issuer ID

### 4) Conectar o Codemagic

1. Entre no Codemagic e conecte sua conta GitHub
2. Selecione o repositorio QuarkGPS-iOS
3. Em Integrations, conecte App Store Connect com:
   - Issuer ID
   - Key ID
   - arquivo .p8
4. Nomeie a integracao como: QuarkGPS_AppStoreConnect

### 5) Configurar assinatura automatica

1. No workflow, habilite Automatic code signing
2. Team: sua equipe Apple Developer
3. Metodo de distribuicao: App Store
4. O Codemagic cria/usa certificados e provisioning profile automaticamente

### 6) Rodar build

1. Start new build
2. Workflow: ios-quarkgps-release
3. Branch principal
4. Ao finalizar, o IPA vai para Artifacts e o build vai para TestFlight

## Publicar na App Store (depois do TestFlight)

1. App Store Connect > seu app > TestFlight
2. Aguarde processamento da Apple
3. Adicione testadores internos/externos (externo exige Beta Review)
4. Quando estiver ok, crie versao em App Store
5. Preencha metadados:
   - Descricao
   - Palavras-chave
   - URL de suporte
   - URL de privacidade
   - Screenshots (iPhone)
   - Classificacao indicativa
6. Envie para review
7. Apos aprovacao, publique manualmente ou automaticamente

## Checklist de compliance (importante)

1. Localizacao:
   - Ja existe NSLocationWhenInUseUsageDescription no Info.plist
   - O texto precisa refletir uso real do app
2. Login/senha:
   - O WKWebView usa armazenamento padrao e mantem sessao/cookies
3. Privacidade:
   - Declare no App Privacy do App Store Connect quais dados sao coletados
4. SSL:
   - O site precisa abrir em HTTPS valido

## Ajustes necessarios antes de subir para loja

1. App icon 1024x1024 real
2. Bundle Identifier final da sua conta
3. Team de assinatura no pipeline
4. Nome final do app

## Problemas comuns e correcoes

1. Erro de assinatura (No profiles found)
   - Verifique integracao App Store Connect no Codemagic
   - Confirme permissao da API key
2. Bundle ID em uso
   - Troque PRODUCT_BUNDLE_IDENTIFIER no projeto e no App Store Connect
3. Build vai para TestFlight, mas nao aparece para teste externo
   - Falta Beta App Review para grupo externo

## Alternativas sem Codemagic

1. GitHub Actions com runner macOS
2. Bitrise
3. Alugar Mac na nuvem (MacStadium/MacInCloud) e usar Xcode remoto

## Estado atual do projeto

- Projeto iOS criado e pronto para build em macOS
- Configuracao de pipeline Codemagic adicionada
- Falta apenas vincular suas credenciais Apple para build e publicacao
