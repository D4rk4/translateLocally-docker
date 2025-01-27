relative-paths: true
models:
  - model.%MODEL%.intgemm.alphas.bin
vocabs:
  - vocab.%MODEL%.spm
  - vocab.%MODEL%.spm
shortlist:
    - lex.50.50.%MODEL%.s2t.bin
    - false
beam-size: 1
normalize: 1.0
word-penalty: 0
mini-batch: 64
maxi-batch: 1000
maxi-batch-sort: src
workspace: 2000
max-length-factor: 2.5
gemm-precision: int8shiftAlphaAll