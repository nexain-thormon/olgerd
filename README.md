# THORmon Ölgerð

**THORChain Network Monitor**

![preview](https://thorchain.network/preview.png)

[thorchain.network](https://thorchain.network)

## Prerequisites

- Redis

## Setup

Configure the environment by referring to `.env.example`

```bash
# install
$ bundle

# run
$ rake run
```

## THORmon Heilsubrunnr

### Heilsubrunnr Prerequisites

- HAProxy

### Heilsubrunnr Setup

```bash
# config
$ rake heilsubrunnr:config

# validate
$ rake heilsubrunnr:validate

# run
$ rake heilsubrunnr:run
```

<img src="https://thorchain.network/mask-icon.svg" alt="logo" height="20"/>
