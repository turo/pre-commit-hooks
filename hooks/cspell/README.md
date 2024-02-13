# Cspell Dictionary

This `hooks/cspell` directory is not an actual `pre-commit` hook to be referenced by `id`, but a common dictionary that can be extended in repos that use `pre-commit` to avoid duplicating frequent (and Turo-specific) terminology.

```json
// cspell.jsonc
{
  "dictionaries": [
    "turo-dictionary"
  ],
  "dictionaryDefinitions": [
    {
      "name": "turo-dictionary",
      // TODO (@michaeljaltamirano): Update path
      "path": "https://raw.githubusercontent.com/turo/pre-commit-hooks/spike/cspell-michael/hooks/cspell/turo-dictionary.txt",
      "addWords": true
    }
  ],
}
```

It's a requirement for the dictionary to be referenced at the project-level `cspell.json` file, so we cannot bake a Turo-specific configuration within this repo as a `pre-commit` hook. The next best option is making the dictionary available via HTTP GET to be pulled into repo-specific configurations. This repo has a file in `~/cspell.jsonc` that can be used as a reference.
