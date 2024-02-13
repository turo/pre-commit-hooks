# Cspell Dictionary

This `hooks/cspell` directory is not an actual `pre-commit` hook to be referenced by `id`, but a common dictionary that can be extended in repos that use `pre-commit` to avoid duplicating frequent (and Turo-specific) terminology.

```json
// cspell.jsonc
{
  "$schema": "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
  "version": "0.2",
  "allowCompoundWords": false,
  "caseSensitive": true,
  // https://cspell.org/docs/dictionaries/
  "dictionaries": [
    "bash",
    "css",
    "en-gb",
    "fonts",
    "go",
    "html",
    "node",
    "npm",
    "powershell",
    "python",
    "turo-dictionary",
    "typescript"
  ],
  "dictionaryDefinitions": [
    {
      "addWords": true,
      "name": "turo-dictionary",
      // TODO (@michaeljaltamirano): Update path
      "path": "https://raw.githubusercontent.com/turo/pre-commit-hooks/spike/cspell-michael/hooks/cspell/turo-dictionary.txt",
    }
  ],
  "ignoreRegExpList": ["^.*TODO.*"],
  "ignorePaths": ["./.gitignore"]
}
```

It's a requirement for the dictionary to be referenced at the project-level `cspell.json` file, so we cannot bake a Turo-specific configuration within this repo as a `pre-commit` hook. The next best option is making the dictionary available via HTTP GET to be pulled into repo-specific configurations. This repo has a file in `~/cspell.jsonc` that can be used as a reference.
