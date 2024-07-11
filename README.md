# Tests d'utilisation d'un assistant de code 100% local

## `llama.cpp`

### Installation

```
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
make
``` 

**Installation with GPU support**

With cuBLAS:

```
make GGML_CUDA=1
```

### Test installation

```
./llama-cli -m models/deepseek-coder-6.7b-base.Q2_K.gguf -p"I believe the meaning of life is" -n 128
```

To test GPU support:

```
./llama-cli -m models/deepseek-coder-6.7b-base.Q2_K.gguf -p "I believe the meaning of life is" -n 128 -ngl 2
```

### Completion server

Using `llama.cpp` as an inference server, you need one server running for completions and one server running for embeddings. 
To run a completion server locally using the Deepseek Coder 6.7B Base model (available in a quantized version 
[here](https://huggingface.co/TheBloke/deepseek-coder-6.7B-base-GGUF)),
available on port 8080, use the following command: 

```
./llama-server -m models/deepseek-coder-6.7b-base.Q2_K.gguf --port 8080
```

The `.gguf` file here is saved in the `model` subfolder of the `llama.cpp` repository. This server is queriable
at the URL [http://localhost:8080/v1/chat/completions](http://localhost:8080/v1/chat/completions).

### Embedding server

For now we are using a shipped embedding model which runs in the browser (in VS Code) thanks to the `transformers.js`
library. Later we would like to run our own embedding server with `llama.cpp` but for now Continue (the open-source
coding assistant we are using) does not support this (open issue [here](https://github.com/continuedev/continue/issues/1357)).
When it does, to run an embedding server using the Nomic Embed model
(download [here](https://huggingface.co/nomic-ai/nomic-embed-text-v1)) available on port 8081, use the following command:

```
./llama-server --embeddings -m models/nomic-embed-text-v1.Q2_K.gguf --port 8081
```

The `.gguf` file here is saved in the `model` subfolder of the `llama.cpp` repository. This server
is queriable at the URL [http://localhost:8081/v1/chat/embedding](http://localhost:8081/v1/chat/embedding).

## Coding assistant 

We will use [Continue](https://docs.continue.dev/intro), the leading open-source AI code assistant
according to their website. The [Quickstart page](https://docs.continue.dev/quickstart) gives indications to follow for VS Code.

To run a coding assistant using both servers previously set up, change the `~/.continue/config.json`
file with the content of the `config.json` file in this repository.

## Server running on a remote Jupyter Lab

https://lab.peren.fr/hub/token or https://bacasable.peren.fr/hub/token to get an API token
which will allow its user to log onto the Jupyter server.

## To follow

For now there is an issue with using Codestral (with a "llama2" template) for both Chat and Ctrl+i,
see https://github.com/continuedev/continue/issues/1418. This should be fixed soon. For now using the fix described in the issue.
