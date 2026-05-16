#!/bin/bash
set -e

echo "=== MyDoctor Installer (Linux / ChromeOS Flex) ==="
echo "→ Downloading gemma-4-e4b-it.Q8_0.gguf (Medical Model)..."

# Create folder
mkdir -p ~/mydoctor
cd ~/mydoctor

# Download the GGUF model
MODEL_URL="https://huggingface.co/lordvivaan/MyDoctor/resolve/main/gemma-4-e4b-it.Q8_0.gguf"
MODEL_FILE="gemma-4-e4b-it.Q8_0.gguf"

if [ ! -f "$MODEL_FILE" ]; then
    echo "Downloading model (~8.2 GB)... This will take some time."
    curl -L -# -o "$MODEL_FILE" "$MODEL_URL"
    echo "Download Complete!"
else
    echo "Model already exists. Skipping download."
fi

# Create Modelfile
cat > Modelfile << 'EOL'
FROM ./gemma-4-e4b-it.Q8_0.gguf
PARAMETER num_ctx 4096
PARAMETER temperature 0.7
PARAMETER num_thread 2
EOL

# Install Ollama
echo "→ Installing Ollama..."
curl -fsSL https://ollama.com/install.sh | sh

# Install LiteRT-LM
echo "→ Installing LiteRT-LM..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"
uv tool install litert-lm --quiet

echo ""
echo "✅ Installation Complete!"
echo "Model Location: ~/mydoctor"
echo ""
echo "Next Steps:"
echo "1. ollama serve                  (Keep this terminal open)"
echo "2. In a new terminal run:"
echo "   cd ~/mydoctor"
echo "   ollama create mydoctor -f Modelfile"
echo "3. Then run:"
echo "   ollama run mydoctor"
echo ""
echo "⚠️  Warning: This Q8 model needs ~10-12GB RAM to run well."
echo "   On 4GB RAM it will likely fail to load."
echo ""