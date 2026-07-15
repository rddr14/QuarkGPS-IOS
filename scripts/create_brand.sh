#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Uso:
  ./scripts/create_brand.sh \
    --key rmrastreadores \
    --name "RM Rastreadores" \
    --id com.rmrastreadores \
    --url https://rastrear.rmrastreadores.com/ \
    [--android-version-code 1] \
    [--ios-marketing-version 1.0] \
    [--icon /caminho/AppIcon-1024.png]

O script cria automaticamente:
- branding/<key>/Branding.properties
- branding/<key>/AppIcon-1024.png (copiado do --icon ou do branding/quarkgps/AppIcon-1024.png)

Tambem imprime snippets prontos para Android/iOS/Codemagic.
EOF
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Erro: comando obrigatorio nao encontrado: $1" >&2
    exit 1
  fi
}

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEY=""
APP_NAME=""
APP_ID=""
SITE_URL=""
ANDROID_VERSION_CODE=""
IOS_MARKETING_VERSION="1.0"
ICON_SOURCE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --key)
      KEY="${2:-}"
      shift 2
      ;;
    --name)
      APP_NAME="${2:-}"
      shift 2
      ;;
    --id)
      APP_ID="${2:-}"
      shift 2
      ;;
    --url)
      SITE_URL="${2:-}"
      shift 2
      ;;
    --android-version-code)
      ANDROID_VERSION_CODE="${2:-}"
      shift 2
      ;;
    --ios-marketing-version)
      IOS_MARKETING_VERSION="${2:-}"
      shift 2
      ;;
    --icon)
      ICON_SOURCE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Argumento invalido: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$KEY" || -z "$APP_NAME" || -z "$APP_ID" || -z "$SITE_URL" ]]; then
  echo "Erro: --key, --name, --id e --url sao obrigatorios." >&2
  usage
  exit 1
fi

if [[ ! "$KEY" =~ ^[a-z][a-z0-9]*$ ]]; then
  echo "Erro: --key deve ter apenas letras minusculas e numeros, iniciando com letra." >&2
  exit 1
fi

if [[ ! "$APP_ID" =~ ^[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+$ ]]; then
  echo "Erro: --id invalido. Exemplo: com.atualizasom" >&2
  exit 1
fi

if [[ ! "$SITE_URL" =~ ^https?:// ]]; then
  echo "Erro: --url deve comecar com http:// ou https://" >&2
  exit 1
fi

if [[ -n "$ANDROID_VERSION_CODE" && ! "$ANDROID_VERSION_CODE" =~ ^[0-9]+$ ]]; then
  echo "Erro: --android-version-code deve ser numero inteiro." >&2
  exit 1
fi

if [[ ! "$IOS_MARKETING_VERSION" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
  echo "Erro: --ios-marketing-version invalido. Exemplo: 1.0" >&2
  exit 1
fi

BRANDING_DIR="$PROJECT_ROOT/branding/$KEY"
if [[ -d "$BRANDING_DIR" ]]; then
  echo "Erro: a marca '$KEY' ja existe em branding/$KEY" >&2
  exit 1
fi

if [[ -z "$ICON_SOURCE" ]]; then
  ICON_SOURCE="$PROJECT_ROOT/branding/quarkgps/AppIcon-1024.png"
fi

if [[ ! -f "$ICON_SOURCE" ]]; then
  echo "Erro: icone nao encontrado em: $ICON_SOURCE" >&2
  exit 1
fi

require_cmd sed
require_cmd grep
require_cmd awk

if [[ -z "$ANDROID_VERSION_CODE" ]]; then
  max_code=0
  while IFS= read -r file; do
    code_line="$(grep -E '^androidVersionCode=' "$file" || true)"
    code="${code_line#androidVersionCode=}"
    if [[ "$code" =~ ^[0-9]+$ ]] && (( code > max_code )); then
      max_code="$code"
    fi
  done < <(find "$PROJECT_ROOT/branding" -mindepth 2 -maxdepth 2 -type f -name 'Branding.properties' | sort)

  ANDROID_VERSION_CODE=$((max_code + 1))
fi

ALLOWED_HOST="$(echo "$SITE_URL" | sed -E 's#^[a-zA-Z]+://##; s#/.*$##')"

mkdir -p "$BRANDING_DIR"

cat > "$BRANDING_DIR/Branding.properties" <<EOF
# Geral
key=$KEY
appName=$APP_NAME
siteURL=$SITE_URL
allowedHost=$ALLOWED_HOST

# iOS
iosBundleId=$APP_ID
iosMarketingVersion=$IOS_MARKETING_VERSION

# Android
androidApplicationId=$APP_ID
androidVersionCode=$ANDROID_VERSION_CODE
androidVersionName=\${androidVersionCode}.0
EOF

cp "$ICON_SOURCE" "$BRANDING_DIR/AppIcon-1024.png"

cat <<EOF

Marca criada com sucesso em:
- branding/$KEY/Branding.properties
- branding/$KEY/AppIcon-1024.png

Resumo:
- key: $KEY
- appName: $APP_NAME
- id: $APP_ID
- url: $SITE_URL
- allowedHost: $ALLOWED_HOST
- androidVersionCode: $ANDROID_VERSION_CODE
- iosMarketingVersion: $IOS_MARKETING_VERSION

Snippets para aplicar:

[Android build.gradle.kts]
1) Adicione:
   val ${KEY}Branding = loadBrandingConfig("$KEY")
2) Em productFlavors:
   create("$KEY") {
       dimension = "brand"
       applicationId = ${KEY}Branding.androidApplicationId
       versionCode = ${KEY}Branding.androidVersionCode
       versionName = ${KEY}Branding.androidVersionName
       resValue("string", "app_name", ${KEY}Branding.appName)
       resValue("string", "string_site", ${KEY}Branding.siteURL)
   }

[iOS WhiteLabelConfig.swift]
Adicione em configs:
"$KEY": WhiteLabelConfig(
    key: "$KEY",
    appName: "$APP_NAME",
    siteURL: URL(string: "$SITE_URL")!,
    allowedHost: "$ALLOWED_HOST"
)

[Codemagic]
Crie workflows com:
- BRANDING_KEY: "$KEY"
- BUNDLE_ID / bundle_identifier: "$APP_ID"
- ANDROID_FLAVOR: "${KEY^}"
- ANDROID_FLAVOR_SOURCE_SET: "$KEY"

EOF
