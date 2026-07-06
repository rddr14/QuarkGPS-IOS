# QuarkGPS iOS

Aplicativo iOS nativo em SwiftUI com WKWebView para abrir:

- https://rastrear.quarkgps.com

## Recursos implementados

- WebView com JavaScript habilitado
- Persistencia de cookies e sessao entre aberturas do app
- Permissao de localizacao (When In Use)
- Injecao de geolocalizacao no navegador quando a permissao e concedida
- Abertura de links externos fora do dominio em navegador do sistema
- Gestos de voltar/avancar no historico
- Recuperacao automatica em caso de encerramento do processo de WebView

## Estrutura

- QuarkGPS.xcodeproj
- QuarkGPS/

## Build no Mac (Xcode)

1. Copie esta pasta para um Mac com Xcode 16+
2. Abra QuarkGPS.xcodeproj
3. Em Signing & Capabilities:
   - Defina seu Team
   - Ajuste o Bundle Identifier se necessario
4. Selecione um simulador ou iPhone fisico
5. Rode o target QuarkGPS

## Publicacao

1. Product > Archive
2. Validate App
3. Distribute App

## Publicar sem Mac

- Consulte o guia completo em GUIA_PUBLICAR_SEM_MAC.md

## Observacoes

- O projeto foi preparado em ambiente Linux, portanto a compilacao e assinatura precisam ser feitas no Xcode no macOS.
- O AppIcon atual vem do projeto Android e foi reaproveitado para inicializacao do projeto.
