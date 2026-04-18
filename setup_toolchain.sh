#!/bin/bash
# ============================================================
# OpenClaw Toolchain Bootstrapper
# Package: toolchain.tar.gz
# ============================================================
#
# USAGE:
#   1. Extract:    tar -xzf toolchain.tar.gz -C /
#   2. Run setup:  bash setup_toolchain.sh
#
# This will install Java JDK and configure all tools.
# ============================================================

set -e
TOOLCHAIN=/workspace/toolchain
PROXY="${http_proxy:-}"
export HTTPS_PROXY="${HTTPS_PROXY:-$PROXY}"
export HTTP_PROXY="${HTTP_PROXY:-$PROXY}"

echo "=== OpenClaw Toolchain Bootstrapper ==="

# ─── Java JDK ───
echo "Installing Java JDK..."
JDK_DIR=$(ls $TOOLCHAIN/jdk-* 2>/dev/null | head -1 || true)
if [ -z "$JDK_DIR" ]; then
    # Try to download OpenJDK from available sources
    echo "No JDK found. Attempting download..."
    
    # Source 1: Eclipse Temurin via GitHub (if token available)
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "Trying GitHub releases..."
        curl -sSL -H "Authorization: token $GITHUB_TOKEN" \
            "https://api.github.com/repos/adoptium/temurin21-binaries/releases/latest" \
            | python3 -c "
import sys,json,re
d=json.load(sys.stdin)
v=d['tag_name']
url=next(x['browser_download_url'] for x in d['assets'] if 'linux-x64' in x['name'] and 'jre' in x['name'])
print(url)
" >> /tmp/jdk_url.txt || true
    fi
    
    # Source 2: Maven Central / Aliyary
    JDK_URL=$(python3 -c "
import urllib.request, json
# Try Aliyun
try:
    r = urllib.request.urlopen('https://maven.aliyun.com/repository/public/org/apache/openjdk/openjdk/17.0.2+8/openjdk-17.0.2+8-linux-x64.tar.gz', timeout=5)
    print(r.geturl())
except: pass
" 2>/dev/null || echo "")
    
    if [ -n "$JDK_URL" ]; then
        echo "Downloading OpenJDK 17 from Aliyun..."
        curl -sSL -o /tmp/openjdk.tar.gz "$JDK_URL"
        tar -xzf /tmp/openjdk.tar.gz -C $TOOLCHAIN/
        JDK_DIR=$(ls $TOOLCHAIN/jdk-* 2>/dev/null | head -1)
    fi
fi

if [ -n "$JDK_DIR" ]; then
    export JAVA_HOME=$JDK_DIR
    export PATH=$JDK_DIR/bin:$PATH
    echo "Java: $($JDK_DIR/bin/java -version 2>&1 | head -1)"
else
    echo "WARNING: Java JDK not installed. Maven will not work."
    echo "  To install manually:"
    echo "  1. Download OpenJDK from https://adoptium.net"
    echo "  2. tar -xzf openjdk.tar.gz -C $TOOLCHAIN/"
fi

# ─── Verify tools ───
echo ""
echo "=== Tool Status ==="
echo -n "Java:     "; java -version 2>&1 | head -1 || echo "NOT INSTALLED"
echo -n "Maven:    "; mvn -version 2>&1 | head -1 || echo "NOT CONFIGURED"
echo -n "Python:   "; python3 --version
echo -n "pip:      "; python3 -m pip --version
echo -n "Node.js:  "; node --version
echo -n "npm:      "; npm --version

echo ""
echo "=== PATH Configuration ==="
echo "Add to your ~/.bashrc or ~/.zshrc:"
echo ""
echo "  TOOLCHAIN=/workspace/toolchain"
echo '  export PATH=$TOOLCHAIN/maven/bin:$TOOLCHAIN/bin:$PATH'
[ -d "$JDK_DIR/bin" ] && echo '  export JAVA_HOME=$TOOLCHAIN/jdk-*'
echo ""
echo "Done!"
