# hierest

## How to Build and Deploy

1. Run the packaging docker container ([reference](https://github.com/jgensler8/ruby-fxgen-builder))

```
make package
```

This should create a `function.zip` file inside of your output directory

```
$ ls -la output/function.zip
-rw-r--r--  1 jeffrey  439733181  6818648 Mar 24 15:52 output/function.zip
```

2. Upload the zip file to Google Cloud Functions

Set the "function to execute" to `hello` (This will likely change when the fxgen framework evolves)

## Invoking the Endpoint

You'll need to provide a `repo` key that corresponds to a hierarchy repository.

```
export CLOUD_FUNCTION_URL=https://us-central1-<YOUR_ACCOUNT_HERE>.cloudfunctions.net/<YOUR_FUNCTION_NAME_HERE>
curl -X POST --data '{"repo": "https://github.com/jgensler8/ExampleHierestRepo.git"}' ${CLOUD_FUNCTION_URL}
# 
```

### Providing Facts

Facts are provided in the `facts` key of the request body.

```
curl -X POST --data '{
  "repo": "https://github.com/jgensler8/ExampleHierestRepo.git",
  "facts": {
    "name": "ceo"
  }
}' ${CLOUD_FUNCTION_URL}
```


## Hierachy

Create an example hierarchy like [the one located here](https://github.com/jgensler8/ExampleHierestRepo)

```
$ tree
.
├── data
│   ├── common.yaml
│   └── name
│       ├── ceo.yaml
│       └── partner.yaml
└── hiera.yaml
```

This repository should contain a `hiera.yaml` file located in the root of the repository.

Here is an example `hiera.yaml`

```
---
:backends:
  - yaml
:yaml:
  :datadir: "data"
:hierarchy:
  - "name/%{name}"
  - "common"
:logger: console
:merge_behavior: native
:deep_merge_options: {}
```
