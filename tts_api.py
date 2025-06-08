from flask import Flask, request, send_file
import subprocess, uuid, os, tempfile

app = Flask(__name__)
MODEL = "/opt/piper/models/edresson.onnx"

@app.route("/tts", methods=["POST"])
def tts():
    text = request.json.get("text", "")
    tmp_wav = os.path.join(tempfile.gettempdir(), f"{uuid.uuid4()}.wav")
    subprocess.run(
        f'echo "{text}" | piper --model {MODEL} --output_file {tmp_wav}',
        shell=True, check=True)
    return send_file(tmp_wav, mimetype="audio/wav")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)