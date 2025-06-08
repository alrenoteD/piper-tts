FROM python:3.10-slim

RUN apt-get update && apt-get install -y git curl ffmpeg sox unzip build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Instala Piper
RUN git clone --depth 1 https://github.com/rhasspy/piper.git && \
    cd piper && make && ln -s /opt/piper/piper /usr/local/bin/piper

# Modelos (pt-BR feminino – mude se quiser)
RUN mkdir -p /opt/piper/models && \
    curl -L -o /opt/piper/models/edresson.onnx \
    https://huggingface.co/rhasspy/piper-voices/resolve/main/pt_BR/edresson_female-low.onnx

# API Flask
RUN pip install Flask==3.0.3
COPY tts_api.py /opt/

EXPOSE 5002
CMD ["python", "/opt/tts_api.py"]