# OpenClaw Toolchain

Pre-built compilers and package managers for the OpenClaw sandbox environment.

## Contents

| Tool | Version |
|------|---------|
| Python | 3.11.2 |
| pip | 26.0.1 |
| Node.js | v22.17.0 |
| npm | 10.9.2 |
| Maven | 3.9.6 |

## Quick Start

```bash
# Extract to /workspace/
tar -xzf toolchain.tar.gz -C /

# Run setup
bash /workspace/setup_toolchain.sh
```

## Shell Configuration

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
export TOOLCHAIN=/workspace/toolchain
export PATH=$TOOLCHAIN/maven/bin:$TOOLCHAIN/bin:$PATH
# For Maven, also set:
# export JAVA_HOME=$TOOLCHAIN/jdk-<version>
```

## Java JDK

Maven requires a JDK. Download OpenJDK from https://adoptium.net
and extract to `/workspace/toolchain/jdk-<version>/`, then:
```bash
export JAVA_HOME=/workspace/toolchain/jdk-<version>
$TOOLCHAIN/maven/bin/mvn -version
```

## What's Included

- **Maven 3.9.6** — Java project management (`apache-maven-3.9.6/`)
- **pip 26.0.1** — Python package manager (`pip-wheel/`)
- **Python tools** — pre-installed in `bin/`

## Downloads

`toolchain.tar.gz` (~11MB) — contains all tools above
