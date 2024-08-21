---
to: <%= rootDirectory %>/openapitools.json
force: true
---
{
  "$schema": "./node_modules/@openapitools/openapi-generator-cli/config.schema.json",
  "spaces": 2,
  "generator-cli": {
    "version": "7.7.0",
    "generators": {
      "default": {
        "generatorName": "typescript-axios",
        "glob": "./apis/swagger.yaml",
        "output": "./apis",
        "skipValidateSpec": true,
        "additionalProperties": {
          "useSingleRequestParameter": true
        }
      }
    }
  }
}
