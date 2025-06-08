FROM python:3.10-slim

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    git curl ffmpeg sox unzip build-essential cmake \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Clona e compila o Piper
RUN git clone --depth 1 https://github.com/rhasspy/piper.git && \
    cd piper && make && ln -s /opt/piper/piper /usr/local/bin/piper

# Baixa os modelos pt-BR (masculino e feminino)
RUN mkdir -p /opt/piper/models && \
    curl -L -o /opt/piper/models/pt_BR-edresson-low.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/edresson/low/pt_BR-edresson-low.onnx && \
    curl -L -o /opt/piper/models/pt_BR-faber-medium.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx

# Instala Flask
RUN pip install Flask==3.0.3

# Copia o script da API Flask
COPY tts_api.py /opt/

# Expõe a porta da API
EXPOSE 5002

# Inicia a API
CMD ["python", "/opt/tts_api.py"]
