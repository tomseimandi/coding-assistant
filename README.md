# Locally-hosted code assistant

We will use the open-source [Continue](https://docs.continue.dev/intro) code assistant along with `llama.cpp` inference servers.

## `llama.cpp`

### Installation

To build from source:

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

Using `llama.cpp` as an inference server, in theory you need separate servers running for chat auto-completions and embedding functionalities.
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

**Other options for embedding**

One possibility is to use [HuggingFace's text embeddings inference](https://huggingface.co/docs/text-embeddings-inference/en/quick_tour):

- Local installation for CPU only: https://huggingface.co/docs/text-embeddings-inference/local_cpu:
    - Install Rust
    - `git clone https://github.com/huggingface/text-embeddings-inference`
    - `cargo install --path router` in the cloned repository
- To deploy Text Embeddings Inference in an air-gapped environment, clone the Huggingface repository (`git lfs` is required) and then `text-embeddings-router --model-id path/to/model --port 8888` for example

## Run an inference server on a remote Jupyter Lab

- When running a `llama.cpp` inference server on a remote JupyterHub instance, it will be reachable from outside 
using an JupyterHub API token. Go to https://lab.peren.fr/hub/token or https://bacasable.peren.fr/hub/token to get an API token
which will allow its user to log onto the Jupyter server
- See [this link](https://forge.peren.fr/peren/documentation/guide-du-nouvel-arrivant/-/blob/master/12%20-%20Outils%20PEReN.md) for additional information on how to deal with this at PEReN

## Continue Coding assistant 

We will use [Continue](https://docs.continue.dev/intro), the leading open-source AI code assistant
according to their website. The [Quickstart page](https://docs.continue.dev/quickstart) gives indications to follow for VS Code.

To run a coding assistant with a remote server for chat functionalities and local server for autocomplete, modify the `~/.continue/config.json`
file with the content of the `config.json` file in this repository.

**Tips:**
- To get a fully air-gapped setup, manually download the latest `.vsix` file from the Open VSX Registry rather than the VS Code Marketplace and install it to VS Code
- Continue respects `.gitignore` files in order to determine which files should not be indexed. If you'd like to exclude additional files, you can add them to a `.continueignore` file, which follows the exact same rules as `.gitignore`

## To follow

- For now there is an issue with using Codestral (with a "llama2" template) for both Chat and Ctrl+i,
see https://github.com/continuedev/continue/issues/1418. This should be fixed soon. For now using the fix described in the issue
- For now we can not use `llama.cpp` for embeddings, see https://github.com/continuedev/continue/issues/1357
