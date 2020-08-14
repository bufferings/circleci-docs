---
layout: classic-docs
title: "CircleCI を設定する"
short-title: "CircleCI を設定する"
description: ".circleci/config.yml に関するリファレンス"
categories:
  - configuring-jobs
order: 20
---

`config.yml` ファイルで使用される CircleCI 2.x 構成キーのリファレンス ガイドです。 CircleCI によって承認されたリポジトリ ブランチに `.circleci/config.yml` ファイルが存在するということは、2.x インフラストラクチャを使用することを意味しています。

You can see a complete `config.yml` in our [full example](#example-full-configuration).

**メモ:** 既に CircleCI 1.0 バージョンの設定ファイルが存在する場合は、`config.yml` ファイルを使用することで、独立した別のブランチで 2.x ビルドをテストできます。このとき、古い `circle.yml` スタイルの既存の構成は変更する必要がなく、CircleCI 1.0 インフラストラクチャの `.circleci/config.yml` を含まないブランチで実行できます。

* * *

## 目次
{:.no_toc}

- 目次
{:toc}

* * *

## **`version`**

| キー      | 必須 | 型   | 説明                                                                                                                                                                        |
| ------- | -- | --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| version | ○  | 文字列 | `2`、`2.0`、または `2.1`。`.circleci/config.yml` ファイルの簡素化、再利用、パラメータ化ジョブの利用に役立つバージョン 2.1 の新しいキーの概要については、[設定ファイルの再利用に関するドキュメント]({{ site.baseurl }}/2.0/reusing-config/)を参照してください。 |
{: class="table table-striped"}

`version` フィールドは、非推奨または互換性を損なう変更について注意を促すために使用します。

## **`orbs`** (version: 2.1 が必須)

| キー        | 必須 | 型   | 説明                                                                                                                                                                                      |
| --------- | -- | --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| orbs      | ×  | マップ | ユーザー指定の名前によるマップ。Orb の参照名 (文字列) または Orb の定義名 (マップ) を指定します。 Orb 定義は、バージョン 2.1 の設定ファイルの Orb 関連サブセットである必要があります。詳細については [Orb の作成に関するドキュメント]({{ site.baseurl }}/2.0/creating-orbs/)を参照してください。 |
| executors | ×  | マップ | Executor を定義する文字列のマップ。 このページの [executors]({{ site.baseurl }}/2.0/configuration-reference/#executors-version-21-が必須) セクションを参照してください。                                                     |
| commands  | ×  | マップ | コマンドを定義するコマンド名のマップ。 このページの [commands]({{ site.baseurl }}/2.0/configuration-reference/#commands-version-21-が必須) セクションを参照してください。                                                          |
{: class="table table-striped"}

以下の例では、承認済みの `circleci` 名前空間に格納された `hello-build` という名前の Orb を呼び出します。

    version: 2.1
    orbs:
        hello: circleci/hello-build@0.0.5
    workflows:
        "Hello Workflow":
            jobs:
              - hello/hello-build
    

上の例で、`hello` は Orb の参照名と見なされます。`circleci/hello-build@0.0.5` は完全修飾の Orb 参照です。

## **`commands`** (version: 2.1 が必須)

commands では、ジョブ内で実行する一連のステップをマップとして定義します。これにより、複数のジョブで [1 つのコマンド定義を再利用]({{ site.baseurl }}/2.0/reusing-config/)できます。

| キー          | 必須 | 型     | 説明                                                                                                                                                              |
| ----------- | -- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| steps       | ○  | シーケンス | コマンドの呼び出し元のジョブ内で実行する一連のステップ。                                                                                                                                    |
| parameters  | ×  | マップ   | パラメーター キーのマップ。 詳細については、[設定ファイルの再利用に関するドキュメント]({{ site.baseurl }}/2.0/reusing-config/)の「[パラメーターの構文]({{ site.baseurl }}/2.0/reusing-config/#パラメーターの構文)」を参照してください。 |
| description | ×  | 文字列   | コマンドの目的を記述する文字列。                                                                                                                                                |
{: class="table table-striped"}

例

```yaml
commands:
  sayhello:
    description: "デモ用の簡単なコマンド"
    parameters:
      to:
        type: string
        default: "Hello World"
    steps:
      - run: echo << parameters.to >>
```

## **`parameters`** (version: 2.1 が必須)

設定ファイル内で使用するパイプライン パラメーターを定義します。 使用方法の詳細については、[パイプライン変数に関するドキュメント]({{ site.baseurl }}/2.0/pipeline-variables#設定ファイルにおけるパイプライン-パラメーター)を参照してください。

| キー         | 必須 | 型   | 説明                                                                                                                         |
| ---------- | -- | --- | -------------------------------------------------------------------------------------------------------------------------- |
| parameters | ×  | マップ | パラメーター キーのマップ。 `文字列`、`ブール値`、`整数`、`列挙型`がサポートされています。 [パラメーターの構文]({{ site.baseurl }}/2.0/reusing-config/#パラメーターの構文)を参照してください。 |
{: class="table table-striped"}

## **`executors`** (version: 2.1 が必須)

executors では、ジョブのステップを実行する環境を定義します。これにより、複数のジョブで 1 つの Executor 定義を再利用できます。

| キー                | 必須               | 型   | 説明                                                                                                                                      |
| ----------------- | ---------------- | --- | --------------------------------------------------------------------------------------------------------------------------------------- |
| docker            | ○ <sup>(1)</sup> | リスト | [docker Executor](#docker) 用のオプション。                                                                                                     |
| resource_class    | ×                | 文字列 | ジョブ内の各コンテナに割り当てられる CPU と RAM の量。 **Note:** A performance plan is required to access this feature.                                       |
| machine           | ○ <sup>(1)</sup> | マップ | [machine Executor](#machine) 用のオプション。                                                                                                   |
| macos             | ○ <sup>(1)</sup> | マップ | [macOS Executor](#macos) 用のオプション。                                                                                                       |
| windows           | ○ <sup>(1)</sup> | マップ | [Windows executor](#windows) currently working with orbs. Check out [the orb](https://circleci.com/orbs/registry/orb/circleci/windows). |
| shell             | ×                | 文字列 | すべてのステップのコマンド実行に使用するシェル。 各ステップ内の `shell` でオーバーライドできます (デフォルト設定については、[デフォルトのシェル オプション](#デフォルトのシェル-オプション)を参照してください)。                      |
| working_directory | ×                | 文字列 | In which directory to run the steps. Will be interpreted as an absolute path.                                                           |
| environment       | ×                | マップ | 環境変数の名前と値のマップ。                                                                                                                          |
{: class="table table-striped"}

<sup>(1)</sup> 各ジョブにいずれか 1 つの Executor タイプを指定する必要があります。 If more than one is set you will receive an error.

例

```yaml
version: 2.1
executors:
  my-executor:
    docker:
      - image: circleci/ruby:2.5.1-node-browsers

jobs:
  my-job:
    executor: my-executor
    steps:

      - run: echo outside the executor
```

パラメーター化された Executor の使用例については、[設定ファイルの再利用に関するドキュメント]({{ site.baseurl }}/2.0/reusing-config/)の「[Executor でのパラメーターの使用](https://circleci.com/ja/docs/2.0/reusing-config/#executor-でのパラメーターの使用)」を参照してください。

## **`jobs`**

A Workflow is comprised of one or more uniquely named jobs. それらのジョブは `jobs` マップで指定します。[2.0 config.yml のサンプル]({{ site.baseurl }}/2.0/sample-config/)で `jobs` マップの例を紹介しています。 ジョブの名前がマップのキーとなり、ジョブを記述するマップが値となります。

**Note:** Jobs have a maximum runtime of 5 hours. If your jobs are timing out, consider running some of them concurrently using [workflows]({{ site.baseurl }}/2.0/workflows/).

### **<`job_name`>**

Each job consists of the job's name as a key and a map as a value. A name should be unique within a current `jobs` list. The value map has the following attributes:

| キー                | 必須               | 型       | 説明                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ----------------- | ---------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| docker            | ○ <sup>(1)</sup> | リスト     | [docker Executor](#docker) 用のオプション。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| machine           | ○ <sup>(1)</sup> | マップ     | [machine Executor](#machine) 用のオプション。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| macos             | ○ <sup>(1)</sup> | マップ     | [macOS Executor](#macos) 用のオプション。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| shell             | ×                | 文字列     | すべてのステップのコマンド実行に使用するシェル。 各ステップ内の `shell` でオーバーライドできます (デフォルト設定については、[デフォルトのシェル オプション](#デフォルトのシェル-オプション)を参照してください)。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| parameters        | N                | Map     | [Parameters](#parameters) for making a `job` explicitly configurable in a `workflow`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| steps             | Y                | List    | A list of [steps](#steps) to be performed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| working_directory | ×                | String  | In which directory to run the steps. Will be interpreted as an absolute path. Default: `~/project` (where `project` is a literal string, not the name of your specific project). Processes run during the job can use the `$CIRCLE_WORKING_DIRECTORY` environment variable to refer to this directory. **Note:** Paths written in your YAML configuration file will *not* be expanded; if your `store_test_results.path` is `$CIRCLE_WORKING_DIRECTORY/tests`, then CircleCI will attempt to store the `test` subdirectory of the directory literally named `$CIRCLE_WORKING_DIRECTORY`, dollar sign `$` and all. |
| parallelism       | ×                | Integer | Number of parallel instances of this job to run (default: 1)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| environment       | ×                | マップ     | A map of environment variable names and values.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| branches          | ×                | Map     | A map defining rules to allow/block execution of specific branches for a single job that is **not** in a workflow or a 2.1 config (default: all allowed). See [Workflows](#workflows) for configuring branch execution for jobs in a workflow or 2.1 config.                                                                                                                                                                                                                                                                                                                                                      |
| resource_class    | N                | String  | Amount of CPU and RAM allocated to each container in a job. **Note:** A performance plan is required to access this feature.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
{: class="table table-striped"}

<sup>(1)</sup> One executor type should be specified per job. If more than one is set you will receive an error.

#### `environment`

A map of environment variable names and values. These will override any environment variables you set in the CircleCI application.

#### `parallelism`

If `parallelism` is set to N > 1, then N independent executors will be set up and each will run the steps of that job in parallel. This can help optimize your test steps; you can split your test suite, using the CircleCI CLI, across parallel containers so the job will complete in a shorter time. Certain parallelism-aware steps can opt out of the parallelism and only run on a single executor (for example [`deploy` step](#deploy--deprecated)). Learn more about [parallel jobs]({{ site.baseurl }}/2.0/parallelism-faster-jobs/).

`working_directory` will be created automatically if it doesn't exist.

Example:

```yaml
jobs:
  build:
    docker:
      - image: buildpack-deps:trusty
    environment:
      FOO: bar
    parallelism: 3
    resource_class: large
    working_directory: ~/my-app
    steps:
      - run: go test -v $(go list ./... | circleci tests split)
```

#### `parameters`

The `parameters` can be used when [calling that `job` in a `workflow`](#jobs-1).

Reserved parameter-names:

- `name`
- `requires`
- `context`
- `type`
- `filters`
- `matrix` <!-- Others? -->
    
    <!-- branches & type pass `circleci config validate`. Strange -->

See [Parameter Syntax]({{ site.baseurl }}/2.0/reusing-config/#parameter-syntax) <!-- In this reference, it's not mentioned which types are allowed for job-parameters. --> for definition details.

#### **`docker`** / **`machine`** / **`macos`** / **`windows`** (*executor*)

An "executor" is roughly "a place where steps occur". CircleCI 2.0 can build the necessary environment by launching as many docker containers as needed at once, or it can use a full virtual machine. Learn more about [different executors]({{ site.baseurl }}/2.0/executor-types/).

#### `docker`
{:.no_toc}

Configured by `docker` key which takes a list of maps:

| キー          | 必須 | 型         | 説明                                                             |
| ----------- | -- | --------- | -------------------------------------------------------------- |
| image       | ○  | 文字列       | 使用するカスタム Docker イメージの名前。                                       |
| name        | ×  | 文字列       | 他から参照するためのコンテナの名前。 デフォルトでは、`localhost` を通してコンテナ サービスにアクセスできます。 |
| entrypoint  | ×  | 文字列またはリスト | コンテナのローンチ時に実行するコマンド。                                           |
| command     | ×  | 文字列またはリスト | コンテナのローンチ時にルート プロセスとなる PID 1 として使用するコマンド (または entrypoint の引数)。 |
| user        | ×  | 文字列       | Docker コンテナ内でコマンドを実行するユーザー。                                    |
| environment | ×  | マップ       | 環境変数の名前と値のマップ。                                                 |
| auth        | ×  | マップ       | 標準の `docker login` 認証情報を用いたレジストリの認証情報。                         |
| aws_auth    | ×  | マップ       | Authentication for AWS Elastic Container Registry (ECR)        |
{: class="table table-striped"}

The first `image` listed in the file defines the primary container image where all steps will run.

`entrypoint` overrides the image's `ENTRYPOINT`.

`command` overrides the image's `COMMAND`; it will be used as arguments to the image `ENTRYPOINT` if it has one, or as the executable if the image has no `ENTRYPOINT`.

For a [primary container]({{ site.baseurl }}/2.0/glossary/#primary-container) (the first container in the list), if neither `command` nor `entrypoint` is specified in the config, then any `ENTRYPOINT` and `COMMAND` in the image are ignored. This is because the primary container is typically used only for running the `steps` and not for its `ENTRYPOINT`, and an `ENTRYPOINT` may consume significant resources or exit prematurely. ([A custom image may disable this behavior and force the `ENTRYPOINT` to run.]({{ site.baseurl }}/2.0/custom-images/#adding-an-entrypoint)) The job `steps` run in the primary container only.

`name` defines the name for reaching the secondary service containers. By default, all services are exposed directly on `localhost`. The field is appropriate if you would rather have a different host name instead of localhost, for example, if you are starting multiple versions of the same service.

The `environment` settings apply to entrypoint/command run by the docker container, not the job steps.

You can specify image versions using tags or digest. You can use any public images from any public Docker registry (defaults to Docker Hub). Learn more about [specifying images]({{ site.baseurl }}/2.0/executor-types).

Example:

```yaml
jobs:
  build:
    docker:
      - image: buildpack-deps:trusty # プライマリ コンテナ
        environment:
          ENV: CI

      - image: mongo:2.6.8
        command: [--smallfiles]

      - image: postgres:9.4.1
        environment:
          POSTGRES_USER: root

      - image: redis@sha256:54057dd7e125ca41afe526a877e8bd35ec2cdd33b9217e022ed37bdcf7d09673
```

If you are using a private image, you can specify the username and password in the `auth` field. To protect the password, you can set it as a project setting which you reference here:

```yaml
jobs:
  build:
    docker:
      - image: acme-private/private-image:321
        auth:
          username: mydockerhub-user  # 文字列リテラル値を指定するか
          password: $DOCKERHUB_PASSWORD  # UI から設定したプロジェクトの環境変数を参照するように指定します
```

Using an image hosted on [AWS ECR](https://aws.amazon.com/ecr/) requires authentication using AWS credentials. By default, CircleCI uses the AWS credentials that you add to the Project > Settings > AWS Permissions page in the CircleCI application or by setting the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` project environment variables. It is also possible to set the credentials by using `aws_auth` field as in the following example:

```yaml
jobs:
  build:
    docker:
      - image: account-id.dkr.ecr.us-east-1.amazonaws.com/org/repo:0.1
        aws_auth:
          aws_access_key_id: AKIAQWERVA  # 文字列リテラル値を指定するか
          aws_secret_access_key: $ECR_AWS_SECRET_ACCESS_KEY  # UI から設定したプロジェクトの環境変数を参照するように指定します
```

It is possible to reuse [declared commands]({{ site.baseurl }}/2.0/reusing-config/) in a job when using version 2.1. The following example invokes the `sayhello` command.

```yaml
jobs:
  myjob:
    docker:
      - image: "circleci/node:9.6.1"
    steps:
      - sayhello:
          to: "Lev"
```

#### **`machine`**
{:.no_toc}

The [machine executor]({{ site.baseurl }}/2.0/executor-types) is configured by using the `machine` key, which takes a map:

| キー                     | 必須 | 型    | 説明                                                                                                                                                                                                                                       |
| ---------------------- | -- | ---- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| image                  | ○  | 文字列  | 使用する VM イメージ。 [使用可能なイメージ](#使用可能な-machine-イメージ)を参照してください。 **メモ:** このキーは、オンプレミス環境では**サポートされません**。 ユーザーのサーバーにインストールされた CircleCI 上の `machine` Executor イメージをカスタマイズする方法については、[VM サービスに関するドキュメント]({{ site.baseurl }}/2.0/vm-service)を参照してください。 |
| docker_layer_caching | ×  | ブール値 | `true` に設定すると、[Docker レイヤー キャッシュ]({{ site.baseurl }}/2.0/docker-layer-caching)が有効になります。 **メモ:** お使いのアカウントでこの有料の機能を有効化するには、サポート チケットをオープンしてください。CircleCI 営業担当者から連絡を差し上げます。                                                                |
{: class="table table-striped"}


Example:

```yaml
version: 2.1
jobs:
  build:
    machine:
      image: ubuntu-1604:202007-01
    steps:
      - checkout
      - run:
          name: "Testing"
          command: echo "Hi"
```

##### 使用可能な `machine` イメージ

CircleCI supports multiple machine images that can be specified in the `image` field:

- `ubuntu-1604:202007-01` - Ubuntu 16.04, Docker v19.03.12, Docker Compose v1.26.1
- `ubuntu-1604:202004-01` - Ubuntu 16.04, Docker v19.03.8, Docker Compose v1.25.5
- `ubuntu-1604:201903-01` - Ubuntu 16.04, Docker v18.09.3, Docker Compose v1.23.1
- `circleci/classic:latest` (old default) - an Ubuntu version `14.04` image that includes Docker version `17.09.0-ce` and docker-compose version `1.14.0`, along with common language tools found in CircleCI 1.0 build image. Changes to the `latest` image are [announced](https://discuss.circleci.com/t/how-to-subscribe-to-announcements-and-notifications-from-circleci-email-rss-json/5616) at least a week in advance. Ubuntu 14.04 is now End-of-Life'd. We suggest using the Ubuntu 16.04 image.
- `circleci/classic:edge` - an Ubuntu version `14.04` image with Docker version `17.10.0-ce` and docker-compose version `1.16.1`, along with common language tools found in CircleCI 1.0 build image.
- `circleci/classic:201703-01` – docker 17.03.0-ce, docker-compose 1.9.0
- `circleci/classic:201707-01` – docker 17.06.0-ce, docker-compose 1.14.0
- `circleci/classic:201708-01` – docker 17.06.1-ce, docker-compose 1.14.0
- `circleci/classic:201709-01` – docker 17.07.0-ce, docker-compose 1.14.0
- `circleci/classic:201710-01` – docker 17.09.0-ce, docker-compose 1.14.0
- `circleci/classic:201710-02` – docker 17.10.0-ce, docker-compose 1.16.1
- `circleci/classic:201711-01` – docker 17.11.0-ce, docker-compose 1.17.1
- `circleci/classic:201808-01` – docker 18.06.0-ce, docker-compose 1.22.0

The machine executor supports [Docker Layer Caching]({{ site.baseurl }}/2.0/docker-layer-caching) which is useful when you are building Docker images during your job or Workflow.

##### 使用可能な Linux GPU イメージ

When using the [Linux GPU executor](#gpu-executor-linux), the available images are:

- `ubuntu-1604-cuda-10.1:201909-23` - CUDA 10.1, docker 19.03.0-ce, nvidia-docker 2.2.2
- `ubuntu-1604-cuda-9.2:201909-23` - CUDA 9.2, docker 19.03.0-ce, nvidia-docker 2.2.2

##### 使用可能な Windows GPU イメージ

When using the [Windows GPU executor](#gpu-executor-windows), the available image is:

- `windows-server-2019-nvidia:stable` - Windows Server 2019, CUDA 10.1. This image is the default.

**Example**

```yaml
version: 2.1
workflows:
  main:
    jobs:
      - build
jobs:
  build:
    machine:
      image: ubuntu-1604:201903-01
      docker_layer_caching: true    # デフォルトは false
```

#### **`macos`**
{:.no_toc}

CircleCI supports running jobs on [macOS](https://developer.apple.com/macos/), to allow you to build, test, and deploy apps for macOS, [iOS](https://developer.apple.com/ios/), [tvOS](https://developer.apple.com/tvos/) and [watchOS](https://developer.apple.com/watchos/). To run a job in a macOS virtual machine, you must add the `macos` key to the top-level configuration for the job and specify the version of Xcode you would like to use.

| キー    | 必須 | 型   | 説明                                                                                                                                               |
| ----- | -- | --- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| xcode | ○  | 文字列 | 仮想マシンにインストールする Xcode のバージョン。iOS でのテストに関するドキュメントの「[サポートされている Xcode のバージョン]({{ site.baseurl }}/2.0/testing-ios/#サポートされている-xcode-のバージョン)」を参照してください。 |
{: class="table table-striped"}

**Example:** Use a macOS virtual machine with Xcode version 11.3:

```yaml
jobs:
  build:
    macos:
      xcode: "11.3.0"
```

#### **`windows`**
{:.no_toc}

CircleCI supports running jobs on Windows. To run a job on a Windows machine, you must add the `windows` key to the top-level configuration for the job. Orbs also provide easy access to setting up a Windows job. To learn more about prerequisites to running Windows jobs and what Windows machines can offer, consult the [Hello World on Windows]({{ site.baseurl }}/2.0/hello-world-windows) document.

**Example:** Use a windows executor to run a simple job.

```yaml
version: 2.1

orbs:
  win: circleci/windows@2.3.0

jobs:
  build:
    executor: win/default
    steps:

      - checkout
      - run: echo 'Hello, Windows'
```

#### **`branches` – DEPRECATED**

**This key is deprecated. Use [workflows filtering](#filters) to control which jobs run for which branches.**

Defines rules for allowing/blocking execution of some branches if Workflows are **not** configured and you are using 2.0 (not 2.1) config. If you are using [Workflows]({{ site.baseurl }}/2.0/workflows/#using-contexts-and-filtering-in-your-workflows), job-level branches will be ignored and must be configured in the Workflows section of your `config.yml` file. If you are using 2.1 config, you will need to add a workflow in order to use filtering. See the [workflows](#workflows) section for details. The job-level `branch` key takes a map:

| キー     | 必須 | 型   | 説明              |
| ------ | -- | --- | --------------- |
| only   | ×  | リスト | 実行するブランチのみのリスト。 |
| ignore | ×  | リスト | 無視するブランチのリスト。   |
{: class="table table-striped"}

Both `only` and `ignore` lists can have full names and regular expressions. Regular expressions must match the **entire** string. For example:

```YAML
jobs:
  build:
    branches:
      only:
        - master
        - /rc-.*/
```

In this case, only "master" branch and branches matching regex "rc-.*" will be executed.

```YAML
jobs:
  build:
    branches:
      ignore:
        - develop
        - /feature-.*/
```

In this example, all the branches will be executed except "develop" and branches matching regex "feature-.*".

If both `ignore` and `only` are present in config, only `ignore` will be taken into account.

A job that was not executed due to configured rules will show up in the list of jobs in UI, but will be marked as skipped.

To ensure the job runs for **all** branches, either don't use the `branches` key, or use the `only` key along with the regular expression: `/.*/` to catch all branches.

#### **`resource_class`**

The `resource_class` feature allows configuring CPU and RAM resources for each job. Different resource classes are available for different executors, as described in the tables below.

We implement soft concurrency limits for each resource class to ensure our system remains stable for all customers. If you are on a Performance or custom plan and experience queuing for certain resource classes, it's possible you are hitting these limits. [Contact CircleCI support](https://support.circleci.com/hc/en-us/requests/new) to request a raise on these limits for your account.

**Note:** This feature is automatically enabled on free and Performance plans. Available resources classes are restricted for customers on the free plan to small/medium for linux, and medium for Windows. MacOS is not yet available on the free plan.

**For self-hosted installations of CircleCI Server contact your system administrator for a list of available resource classes**. See Server Administration documents for further information: [Nomad Client System Requirements]({{ site.baseurl }}/2.0/server-ports/#nomad-clients) and [Server Resource Classes]({{ site.baseurl }}/2.0/customizations/#resource-classes).

##### docker Executor

| クラス                    | vCPU | RAM   |
| ---------------------- | ---- | ----- |
| small                  | 1    | 2 GB  |
| medium (デフォルト)         | 2    | 4 GB  |
| medium+                | 3    | 6 GB  |
| large                  | 4    | 8 GB  |
| xlarge                 | 8    | 16 GB |
| 2xlarge<sup>(2)</sup>  | 16   | 32 GB |
| 2xlarge+<sup>(2)</sup> | 20   | 40 GB |
{: class="table table-striped"}

###### 例

```yaml
jobs:
  build:
    docker:
      - image: buildpack-deps:trusty
    resource_class: xlarge
    steps:
      ... // 他の構成
```

##### machine Executor (Linux)

{% include snippets/machine-resource-table.md %}

###### 例

```yaml
jobs:
  build:
    machine:
      image: ubuntu-1604:201903-01 # recommended linux image - includes Ubuntu 16.04, docker 18.09.3, docker-compose 1.23.1
    resource_class: large
    steps:
      ... // 他の構成
```

##### macOS Executor

| クラス                 | vCPU | RAM  |
| ------------------- | ---- | ---- |
| medium (デフォルト)      | 4    | 8GB  |
| large<sup>(2)</sup> | 8    | 16GB |
{: class="table table-striped"}

###### 例

```yaml
jobs:
  build:
    macos:
      xcode: "11.3.0"
    resource_class: large
    steps:
      ... // 他の構成
```

##### windows Executor

| クラス            | vCPU | RAM   |
| -------------- | ---- | ----- |
| medium (デフォルト) | 4    | 15GB  |
| large          | 8    | 30GB  |
| xlarge         | 16   | 60GB  |
| 2xlarge        | 32   | 128GB |
{: class="table table-striped"}

###### 例

```yaml
version: 2.1

orbs:
  win: circleci/windows@2.3.0

jobs:
  build:
    executor:
      name: win/default
      size: "medium" # can be "medium", "large", "xlarge", "2xlarge"
    steps:

      - run: Write-Host 'Hello, Windows'
```

Note the way resource class is set is different for `windows` because the executor is defined within the windows orb.

See the [Windows Getting Started document]({{ site.baseurl }}/2.0/hello-world-windows/) for more details and examples of using the Windows executor.

##### GPU Executor (Linux)

| クラス                             | vCPU | RAM | GPUs | GPU model       | GPU Memory (GiB) |
| ------------------------------- | ---- | --- | ---- | --------------- | ---------------- |
| gpu.nvidia.small<sup>(2)</sup>  | 4    | 15  | 1    | Nvidia Tesla P4 | 8                |
| gpu.nvidia.medium<sup>(2)</sup> | 8    | 30  | 1    | Nvidia Tesla T4 | 16               |
{: class="table table-striped"}

###### 例

```yaml
version: 2.1

jobs:
  build:
    machine:
      resource_class: gpu.nvidia.small
      image: ubuntu-1604-cuda-10.1:201909-23
    steps:

      - run: nvidia-smi
      - run: docker run --gpus all nvidia/cuda:9.0-base nvidia-smi
```

See the [Available Linux GPU images](#available-linux-gpu-images) section for the full list of available images.

##### GPU Executor (Windows)

| クラス                                     | vCPU | RAM | GPU | GPU モデル         | GPU メモリ (GiB) |
| --------------------------------------- | ---- | --- | --- | --------------- | ------------- |
| windows.gpu.nvidia.medium<sup>(2)</sup> | 16   | 60  | 1   | Nvidia Tesla T4 | 16            |
{: class="table table-striped"}

###### 例

```yaml
version: 2.1
orbs:
  win: circleci/windows@2.3.0

jobs:
  build:
    executor: win/gpu-nvidia
    steps:

      - checkout
      - run: '&"C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"'
```

<sup>(2)</sup> *This resource requires review by our support team. [Open a support ticket](https://support.circleci.com/hc/en-us/requests/new) if you would like to request access.*

**Note**: Java, Erlang and any other languages that introspect the `/proc` directory for information about CPU count may require additional configuration to prevent them from slowing down when using the CircleCI 2.0 resource class feature. Programs with this issue may request 32 CPU cores and run slower than they would when requesting one core. Users of languages with this issue should pin their CPU count to their guaranteed CPU resources. If you want to confirm how much memory you have been allocated, you can check the cgroup memory hierarchy limit with `grep hierarchical_memory_limit /sys/fs/cgroup/memory/memory.stat`.

#### **`steps`**

The `steps` setting in a job should be a list of single key/value pairs, the key of which indicates the step type. The value may be either a configuration map or a string (depending on what that type of step requires). For example, using a map:

```yaml
jobs:
  build:
    working_directory: ~/canary-python
    environment:
      FOO: bar
    steps:
      - run:
          name: テストの実行
          command: make test
```

Here `run` is a step type. The `name` attribute is used by the UI for display purposes. The `command` attribute is specific for `run` step and defines command to execute.

Some steps may implement a shorthand semantic. For example, `run` may be also be called like this:

    jobs:
      build:
        steps:
          - run: make test
    

In its short form, the `run` step allows us to directly specify which `command` to execute as a string value. In this case step itself provides default suitable values for other attributes (`name` here will have the same value as `command`, for example).

Another shorthand, which is possible for some steps, is to simply use the step name as a string instead of a key/value pair:

    jobs:
      build:
        steps:
          - checkout
    

In this case, the `checkout` step will checkout project source code into the job's [`working_directory`](#jobs).

In general all steps can be described as:

| Key                  | Required | Type          | Description                                                                              |
| -------------------- | -------- | ------------- | ---------------------------------------------------------------------------------------- |
| &lt;step_type> | Y        | Map or String | A configuration map for the step or some string whose semantics are defined by the step. |
{: class="table table-striped"}

Each built-in step is described in detail below.

##### **`run`**

Used for invoking all command-line programs, taking either a map of configuration values, or, when called in its short-form, a string that will be used as both the `command` and `name`. Run commands are executed using non-login shells by default, so you must explicitly source any dotfiles as part of the command.

| キー                  | 必須 | 型       | 説明                                                                                                                                                       |
| ------------------- | -- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| command             | ○  | String  | Command to run via the shell                                                                                                                             |
| name                | N  | String  | Title of the step to be shown in the CircleCI UI (default: full `command`)                                                                               |
| shell               | N  | String  | Shell to use for execution command (default: See [Default Shell Options](#default-shell-options))                                                        |
| environment         | N  | Map     | Additional environmental variables, locally scoped to command                                                                                            |
| background          | N  | Boolean | Whether or not this step should run in the background (default: false)                                                                                   |
| working_directory   | N  | String  | In which directory to run this step. Will be interpreted relative to the [`working_directory`](#jobs) of the job). (default: `.`)                        |
| no_output_timeout | N  | String  | Elapsed time the command can run without output. The string is a decimal with unit suffix, such as "20m", "1.25h", "5s" (default: 10 minutes)            |
| when                | N  | String  | [Specify when to enable or disable the step](#the-when-attribute). Takes the following values: `always`, `on_success`, `on_fail` (default: `on_success`) |
{: class="table table-striped"}

Each `run` declaration represents a new shell. It is possible to specify a multi-line `command`, each line of which will be run in the same shell:

```YAML
- run:
    command: |
      echo Running test
      mkdir -p /tmp/test-results
      make test
```

You can also configure commands to run [in the background](#background-commands) if you don't want to wait for the step to complete before moving on to subsequent run steps.

###### *デフォルトのシェル オプション*

For jobs that run on **Linux**, the default value of the `shell` option is `/bin/bash -eo pipefail` if `/bin/bash` is present in the build container. Otherwise it is `/bin/sh -eo pipefail`. The default shell is not a login shell (`--login` or `-l` are not specified). Hence, the shell will **not** source your `~/.bash_profile`, `~/.bash_login`, `~/.profile` files.

For jobs that run on **macOS**, the default shell is `/bin/bash --login -eo pipefail`. The shell is a non-interactive login shell. The shell will execute `/etc/profile/` followed by `~/.bash_profile` before every step.

For more information about which files are executed when bash is invocated, [see the `INVOCATION` section of the `bash` manpage](https://linux.die.net/man/1/bash).

Descriptions of the `-eo pipefail` options are provided below.

`-e`

> パイプライン (1 つのコマンドで構成される場合を含む)、かっこ「()」で囲まれたサブシェル コマンド、または中かっこ「{}」で囲まれたコマンド リストの一部として実行されるコマンドの 1 つが 0 以外のステータスで終了した場合は、直ちに終了します。

So if in the previous example `mkdir` failed to create a directory and returned a non-zero status, then command execution would be terminated, and the whole step would be marked as failed. If you desire the opposite behaviour, you need to add `set +e` in your `command` or override the default `shell` in your configuration map of `run`. For example:

```YAML
<br />- run:
    command: |
      echo Running test
      set +e
      mkdir -p /tmp/test-results
      make test

- run:
    shell: /bin/sh
    command: |
      echo Running test
      mkdir -p /tmp/test-results
      make test
```

`-o pipefail`

> pipefail を有効にすると、パイプラインの戻り値は、0 以外のステータスで終了した最後 (右端) のコマンドのステータス値か、すべてのコマンドが正しく終了した場合に 0 となります。 シェルは、パイプライン内のすべてのコマンドの終了を待って値を返します。

For example:

```YAML
<br />- run: make test | tee test-output.log
```

If `make test` fails, the `-o pipefail` option will cause the whole step to fail. Without `-o pipefail`, the step will always run successfully because the result of the whole pipeline is determined by the last command (`tee test-output.log`), which will always return a zero status.

Note that even if `make test` fails the rest of pipeline will be executed.

If you want to avoid this behaviour, you can specify `set +o pipefail` in the command or override the whole `shell` (see example above).

In general, we recommend using the default options (`-eo pipefail`) because they show errors in intermediate commands and simplify debugging job failures. For convenience, the UI displays the used shell and all active options for each `run` step.

For more information, see the [Using Shell Scripts]({{ site.baseurl }}/2.0/using-shell-scripts/) document.

###### *バックグラウンド コマンド*

The `background` attribute enables you to configure commands to run in the background. Job execution will immediately proceed to the next step rather than waiting for return of a command with the `background` attribute set to `true`. The following example shows the config for running the X virtual framebuffer in the background which is commonly required to run Selenium tests:

```YAML
- run:
    name: X 仮想フレームバッファの実行
    command: Xvfb :99 -screen 0 1280x1024x24
    background: true

- run: make test
```

###### *省略構文*

`run` has a very convenient shorthand syntax:

```YAML
- run: make test

# 省略形式のコマンドは複数行にわたって記述可能です

- run: |
    mkdir -p /tmp/test-results
    make test
```

In this case, `command` and `name` become the string value of `run`, and the rest of the config map for that `run` have their default values.

###### `when` 属性

By default, CircleCI will execute job steps one at a time, in the order that they are defined in `config.yml`, until a step fails (returns a non-zero exit code). After a command fails, no further job steps will be executed.

Adding the `when` attribute to a job step allows you to override this default behaviour, and selectively run or skip steps depending on the status of the job.

The default value of `on_success` means that the step will run only if all of the previous steps have been successful (returned exit code 0).

A value of `always` means that the step will run regardless of the exit status of previous steps. This is useful if you have a task that you want to run regardless of whether the previous steps are successful or not. For example, you might have a job step that needs to upload logs or code-coverage data somewhere.

A value of `on_fail` means that the step will run only if one of the preceding steps has failed (returns a non-zero exit code). It is common to use `on_fail` if you want to store some diagnostic data to help debug test failures, or to run custom notifications about the failure, such as sending emails or triggering alerts in chatrooms.

**Note**: Some steps, such as `store_artifacts` and `store_test_results` will always run, even if a step has failed previously.

```YAML
- run:
    name: CodeCov.io データのアップロード
    command: bash <(curl -s https://codecov.io/bash) -F unittests
    when: always # 成功しても失敗しても、コード カバレッジの結果をアップロードします
```

###### `step` 内からのジョブの終了

A job can exit without failing by using `run: circleci-agent step halt`. This can be useful in situations where jobs need to conditionally execute.

Here is an example where `halt` is used to avoid running a job on the `develop` branch:

```YAML
run: |
    if [ "$CIRCLE_BRANCH" = "develop" ]; then
        circleci-agent step halt
    fi
```

###### 例

```yaml
steps:
  - run:
      name: アプリケーションのテスト
      command: make test
      shell: /bin/bash
      working_directory: ~/my-app
      no_output_timeout: 30m
      environment:
        FOO: bar

  - run: echo 127.0.0.1 devhost | sudo tee -a /etc/hosts

  - run: |
      sudo -u root createuser -h localhost --superuser ubuntu &&
      sudo createdb -h localhost test_db

  - run:
      name: 失敗したテストのアップロード
      command: curl --data fail_tests.log http://example.com/error_logs
      when: on_fail
```

##### **`when` ステップ** (version: 2.1 が必須)

A conditional step consists of a step with the key `when` or `unless`. Under the `when` key are the subkeys `condition` and `steps`. The purpose of the `when` step is customizing commands and job configuration to run on custom conditions (determined at config-compile time) that are checked before a workflow runs. See the [Conditional Steps section of the Reusing Config document]({{ site.baseurl }}/2.0/reusing-config/#defining-conditional-steps) for more details.

| キー        | 必須 | 型        | 説明                                                                                           |
| --------- | -- | -------- | -------------------------------------------------------------------------------------------- |
| condition | ○  | Logic    | [A logic statement](https://circleci.com/docs/2.0/configuration-reference/#logic-statements) |
| steps     | Y  | Sequence | A list of steps to execute when the condition is true                                        |
{: class="table table-striped"}

###### *例*

    version: 2.1
    
    jobs: # 条件付きステップは `commands:` でも定義できます
      job_with_optional_custom_checkout:
        parameters:
          custom_checkout:
            type: string
            default: ""
        machine: true
        steps:
    
          - when:
              condition: <<parameters.custom_checkout>>
              steps:
                - run: echo "my custom checkout"
          - unless:
              condition: <<parameters.custom_checkout>>
              steps:
                - checkout
    workflows:
      build-test-deploy:
        jobs:
          - job_with_optional_custom_checkout:
              custom_checkout: "any non-empty string is truthy"
          - job_with_optional_custom_checkout
    

##### **`checkout`**

A special step used to check out source code to the configured `path` (defaults to the `working_directory`). The reason this is a special step is because it is more of a helper function designed to make checking out code easy for you. If you require doing git over HTTPS you should not use this step as it configures git to checkout over ssh.

| キー   | 必須 | 型   | 説明                                                                                                               |
| ---- | -- | --- | ---------------------------------------------------------------------------------------------------------------- |
| path | N  | 文字列 | Checkout directory. Will be interpreted relative to the [`working_directory`](#jobs) of the job). (default: `.`) |
{: class="table table-striped"}

If `path` already exists and is:

- a git repo - step will not clone whole repo, instead will pull origin
- NOT a git repo - step will fail.

In the case of `checkout`, the step type is just a string with no additional attributes:

```YAML
- checkout
```

**Note:** CircleCI does not check out submodules. If your project requires submodules, add `run` steps with appropriate commands as shown in the following example:

```YAML
- checkout
- run: git submodule sync
- run: git submodule update --init
```

This command will automatically add the required authenticity keys for interacting with GitHub and Bitbucket over SSH, which is detailed further in our [integration guide]({{ site.baseurl }}/2.0/gh-bb-integration/#establishing-the-authenticity-of-an-ssh-host) – this guide will also be helpful if you wish to implement a custom checkout command.

**Note:** The `checkout` step will configure Git to skip automatic garbage collection. If you are caching your `.git` directory with [restore_cache](#restore_cache) and would like to use garbage collection to reduce its size, you may wish to use a [run](#run) step with command `git gc` before doing so.

##### **`setup_remote_docker`**

Creates a remote Docker environment configured to execute Docker commands. See [Running Docker Commands]({{ site.baseurl }}/2.0/building-docker-images/) for details.

| キー                     | 必須 | 型       | 説明                                                                                                                                                                                      |
| ---------------------- | -- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| docker_layer_caching | ×  | boolean | set this to `true` to enable [Docker Layer Caching]({{ site.baseurl }}/2.0/docker-layer-caching/) in the Remote Docker Environment (default: `false`)                                   |
| version                | N  | String  | Version string of Docker you would like to use (default: `17.09.0-ce`). View the list of supported docker versions [here]({{site.baseurl}}/2.0/building-docker-images/#docker-version). |
{: class="table table-striped"}

**Notes**:

- A paid account on a [Performance or Custom Plan](https://circleci.com/pricing/) is required to access Docker Layer Caching.
- `setup_remote_docker` is not compatible with the `machine` executor. See [Docker Layer Caching in Machine Executor]({{ site.baseurl }}/2.0/docker-layer-caching/#machine-executor) for information on how to enable DLC with the `machine` executor.
- The `version` key is not currently supported on CircleCI installed in your private cloud or datacenter. Contact your system administrator for information about the Docker version installed in your remote Docker environment.

##### **`save_cache`**

Generates and stores a cache of a file or directory of files such as dependencies or source code in our object storage. Later jobs can [restore this cache](#restore_cache). Learn more in [the caching documentation]({{ site.baseurl }}/2.0/caching/).

| キー    | 必須 | 型      | 説明                                                                                                                                                       |
| ----- | -- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| paths | Y  | List   | List of directories which should be added to the cache                                                                                                   |
| key   | Y  | 文字列    | Unique identifier for this cache                                                                                                                         |
| name  | N  | String | Title of the step to be shown in the CircleCI UI (default: "Saving Cache")                                                                               |
| when  | N  | String | [Specify when to enable or disable the step](#the-when-attribute). Takes the following values: `always`, `on_success`, `on_fail` (default: `on_success`) |
{: class="table table-striped"}

The cache for a specific `key` is immutable and cannot be changed once written.

**Note** If the cache for the given `key` already exists it won't be modified, and job execution will proceed to the next step.

When storing a new cache, the `key` value may contain special templated values for your convenience:

| Template                                               | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| ------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| {% raw %}`{{ .Branch }}`{% endraw %}                   | The VCS branch currently being built.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| {% raw %}`{{ .BuildNum }}`{% endraw %}                 | The CircleCI build number for this build.                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| {% raw %}`{{ .Revision }}`{% endraw %}                 | The VCS revision currently being built.                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| {% raw %}`{{ .CheckoutKey }}`{% endraw %}              | The SSH key used to checkout the repo.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| {% raw %}`{{ .Environment.variableName }}`{% endraw %} | The environment variable `variableName` (supports any environment variable [exported by CircleCI](https://circleci.com/docs/2.0/env-vars/#circleci-environment-variable-descriptions) or added to a specific [Context](https://circleci.com/docs/2.0/contexts)—not any arbitrary environment variable).                                                                                                                                                                                                               |
| {% raw %}`{{ checksum "filename" }}`{% endraw %}       | A base64 encoded SHA256 hash of the given filename's contents. This should be a file committed in your repo and may also be referenced as a path that is absolute or relative from the current working directory. Good candidates are dependency manifests, such as `package-lock.json`, `pom.xml` or `project.clj`. It's important that this file does not change between `restore_cache` and `save_cache`, otherwise the cache will be saved under a cache key different than the one used at `restore_cache` time. |
| {% raw %}`{{ epoch }}`{% endraw %}                     | The current time in seconds since the unix epoch.                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| {% raw %}`{{ arch }}`{% endraw %}                      | The OS and CPU information. Useful when caching compiled binaries that depend on OS and CPU architecture, for example, `darwin amd64` versus `linux i386/32-bit`.                                                                                                                                                                                                                                                                                                                                                     |
{: class="table table-striped"}

During step execution, the templates above will be replaced by runtime values and use the resultant string as the `key`.

Template examples:

-
{% raw %}`myapp-{{ checksum "package-lock.json" }}`
{% endraw %}

- cache will be regenerated every time something is changed in `package-lock.json` file, different branches of this project will generate the same cache key.
-
{% raw %}`myapp-{{ .Branch }}-{{ checksum "package-lock.json" }}`
{% endraw %}

- same as the previous one, but each branch will generate separate cache
-
{% raw %}`myapp-{{ epoch }}`
{% endraw %}

- every run of a job will generate a separate cache

While choosing suitable templates for your cache `key`, keep in mind that cache saving is not a free operation, because it will take some time to upload the cache to our storage. So it make sense to have a `key` that generates a new cache only if something actually changed and avoid generating a new one every run of a job.

<div class="alert alert-info" role="alert">
<b>ヒント:</b> キャッシュは変更不可なので、すべてのキャッシュ キーの先頭にプレフィックスとしてバージョン名 (<code class="highlighter-rouge">v1-...</code> など) を付加すると便利です。 こうすれば、プレフィックスのバージョン番号を増やしていくだけで、キャッシュ全体を再生成できます。
</div>

###### *例*
{% raw %}```YAML
<br />- save_cache:
    key: v1-myapp-{{ arch }}-{{ checksum "project.clj" }}
    paths:
      - /home/ubuntu/.m2
```

{% endraw %}

##### **`restore_cache`**

Restores a previously saved cache based on a `key`. Cache needs to have been saved first for this key using [`save_cache` step](#save_cache). Learn more in [the caching documentation]({{ site.baseurl }}/2.0/caching/).

| Key  | Required         | Type   | Description                                                                                    |
| ---- | ---------------- | ------ | ---------------------------------------------------------------------------------------------- |
| key  | Y <sup>(1)</sup> | String | Single cache key to restore                                                                    |
| keys | Y <sup>(1)</sup> | List   | List of cache keys to lookup for a cache to restore. Only first existing key will be restored. |
| name | N                | String | Title of the step to be shown in the CircleCI UI (default: "Restoring Cache")                  |
{: class="table table-striped"}

<sup>(1)</sup> at least one attribute has to be present. If `key` and `keys` are both given, `key` will be checked first, and then `keys`.

A key is searched against existing keys as a prefix.

**Note**: When there are multiple matches, the **most recent match** will be used, even if there is a more precise match.

For example:

```YAML
steps:
  - save_cache:
      key: v1-myapp-cache
      paths:
        - ~/d1

  - save_cache:
      key: v1-myapp-cache-new
      paths:
        - ~/d2

  - run: rm -f ~/d1 ~/d2

  - restore_cache:
      key: v1-myapp-cache
```

In this case cache `v1-myapp-cache-new` will be restored because it's the most recent match with `v1-myapp-cache` prefix even if the first key (`v1-myapp-cache`) has exact match.

For more information on key formatting, see the `key` section of [`save_cache` step](#save_cache).

When CircleCI encounters a list of `keys`, the cache will be restored from the first one matching an existing cache. Most probably you would want to have a more specific key to be first (for example, cache for exact version of `package-lock.json` file) and more generic keys after (for example, any cache for this project). If no key has a cache that exists, the step will be skipped with a warning.

A path is not required here because the cache will be restored to the location from which it was originally saved.

###### 例
{% raw %}```YAML
<br />- restore_cache:
    keys:
      - v1-myapp-{{ arch }}-{{ checksum "project.clj" }}
      # `project.clj` の正確なバージョンに対応するキャッシュが存在しない場合は、最新のキャッシュをロードします
      - v1-myapp-

# ... アプリケーションをビルドおよびテストするステップ ...

# `project.clj` のバージョンごとに一度だけキャッシュを保存します

- save_cache:
    key: v1-myapp-{{ arch }}-{{ checksum "project.clj" }}
    paths:
      - /foo
```

{% endraw %}

##### **`deploy` – DEPRECATED**

**This key is deprecated. For improved control over your deployments use [workflows](#workflows) plus associated filtering and scheduling keys.**

Special step for deploying artifacts.

`deploy` uses the same configuration map and semantics as [`run`](#run) step. Jobs may have more than one `deploy` step.

In general `deploy` step behaves just like `run` with two exceptions:

- In a job with `parallelism`, the `deploy` step will only be executed by node #0 and only if all nodes succeed. Nodes other than #0 will skip this step.
- In a job that runs with SSH, the `deploy` step will not execute, and the following action will show instead: > **skipping deploy** > Running in SSH mode. Avoid deploying.

When using the `deploy` step, it is also helpful to understand how you can use workflows to orchestrate jobs and trigger jobs. For more information about using workflows, refer to the following pages:

- [Workflows](https://circleci.com/docs/2.0/workflows-overview/)
- [`workflows`](https://circleci.com/docs/2.0/configuration-reference/#section=configuration)

###### 例

```YAML
- deploy:
    command: |
      if [ "${CIRCLE_BRANCH}" == "master" ]; then
        ansible-playbook site.yml
      fi
```

**Note:** The `run` step allows you to use a shortcut like `run: my command`; however, if you try to use a similar shortcut for the `deploy` step like `deploy: my command`, then you will receive the following error message in CircleCI:

`In step 3 definition: This type of step does not support compressed syntax`

##### **`store_artifacts`**

Step to store artifacts (for example logs, binaries, etc) to be available in the web app or through the API. See the [Uploading Artifacts]({{ site.baseurl }}/2.0/artifacts/) document for more information.

| キー          | 必須 | 型      | 説明                                                                                                               |
| ----------- | -- | ------ | ---------------------------------------------------------------------------------------------------------------- |
| path        | Y  | 文字列    | Directory in the primary container to save as job artifacts                                                      |
| destination | N  | String | Prefix added to the artifact paths in the artifacts API (default: the directory of the file specified in `path`) |
{: class="table table-striped"}

There can be multiple `store_artifacts` steps in a job. Using a unique prefix for each step prevents them from overwriting files.

###### 例

```YAML
- run:
    name: Jekyll サイトのビルド
    command: bundle exec jekyll build --source jekyll --destination jekyll/_site/docs/
- store_artifacts:
    path: jekyll/_site/docs/
    destination: circleci-docs
```

##### **`store_test_results`**

Special step used to upload and store test results for a build. Test results are visible on the CircleCI web application, under each build's "Test Summary" section. Storing test results is useful for timing analysis of your test suites.

It is also possible to store test results as a build artifact; to do so, please refer to [the **store_artifacts** step](#store_artifacts).

| キー   | 必須 | 型   | 説明                                                                                                                                                |
| ---- | -- | --- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| path | ○  | 文字列 | Path (absolute, or relative to your `working_directory`) to directory containing subdirectories of JUnit XML or Cucumber JSON test metadata files |
{: class="table table-striped"}

**Note:** Please write your tests to **subdirectories** of your `store_test_results` path, ideally named to match the names of your particular test suites, in order for CircleCI to correctly infer the names of your reports. If you do not write your reports to subdirectories, you will see reports in your "Test Summary" section such as `Your build ran 71 tests in unknown`, instead of, for example, `Your build ran 71 tests in rspec`.

###### *例*

Directory structure:

    test-results
    ├── jest
    │   └── results.xml
    ├── mocha
    │   └── results.xml
    └── rspec
        └── results.xml
    

`config.yml` syntax:

```YAML
- store_test_results:
    path: test-results
```

##### **`persist_to_workspace`**

Special step used to persist a temporary file to be used by another job in the workflow.

**Note:** Workspaces are stored for up to 15 days after being created. All jobs that try to use a Workspace older than 15 days, including partial reruns of a Workflow and SSH reruns of individual jobs, will fail.

| キー    | 必須 | 型    | 説明                                                                                                                                                                                |
| ----- | -- | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| root  | ○  | 文字列  | Either an absolute path or a path relative to `working_directory`                                                                                                                 |
| paths | Y  | List | Glob identifying file(s), or a non-glob path to a directory to add to the shared workspace. Interpreted as relative to the workspace root. Must not be the workspace root itself. |
{: class="table table-striped"}

The root key is a directory on the container which is taken to be the root directory of the workspace. The paths values are all relative to the root.

##### *root キーの例*

For example, the following step syntax persists the specified paths from `/tmp/dir` into the workspace, relative to the directory `/tmp/dir`.

```YAML
- persist_to_workspace:
    root: /tmp/dir
    paths:
      - foo/bar
      - baz
```

After this step completes, the following directories are added to the workspace:

    /tmp/dir/foo/bar
    /tmp/dir/baz
    

###### *paths キーの例*

```YAML
- persist_to_workspace:
    root: /tmp/workspace
    paths:
      - target/application.jar
      - build/*
```

The `paths` list uses `Glob` from Go, and the pattern matches [filepath.Match](https://golang.org/pkg/path/filepath/#Match).

    pattern:
        { term }
term:
            '*'         区切り文字を除く任意の文字シーケンスに一致します
            '?'         区切り文字を除く任意の 1 文字に一致します
            '[' [ '^' ] { character-range }
        ']'
                        文字クラス (空白は不可)
            c           文字 c に一致します ('*'、'?'、'\\'、'[' 以外) 
            '\\' c      文字 c に一致します
    character-range:
            c           文字 c に一致します ('\\'、'-'、']' 以外)
            '\\' c      文字 c に一致します
            lo '-' hi   lo <= c <= hi の範囲にある文字 c に一致します
    

The Go documentation states that the pattern may describe hierarchical names such as `/usr/*/bin/ed` (assuming the Separator is '/'). **Note:** Everything must be relative to the work space root directory.

##### **`attach_workspace`**

Special step used to attach the workflow's workspace to the current container. The full contents of the workspace are downloaded and copied into the directory the workspace is being attached at.

| キー | 必須 | 型   | 説明                                    |
| -- | -- | --- | ------------------------------------- |
| at | ○  | 文字列 | Directory to attach the workspace to. |
{: class="table table-striped"}

###### *例*

```YAML
- attach_workspace:
    at: /tmp/workspace
```

Each workflow has a temporary workspace associated with it. The workspace can be used to pass along unique data built during a job to other jobs in the same workflow. Jobs can add files into the workspace using the `persist_to_workspace` step and download the workspace content into their file system using the `attach_workspace` step. The workspace is additive only, jobs may add files to the workspace but cannot delete files from the workspace. Each job can only see content added to the workspace by the jobs that are upstream of it. When attaching a workspace the "layer" from each upstream job is applied in the order the upstream jobs appear in the workflow graph. When two jobs run concurrently the order in which their layers are applied is undefined. If multiple concurrent jobs persist the same filename then attaching the workspace will error.

If a workflow is re-run it inherits the same workspace as the original workflow. When re-running failed jobs only the re-run jobs will see the same workspace content as the jobs in the original workflow.

Note the following distinctions between Artifacts, Workspaces, and Caches:

| Type       | lifetime             | Use                                                                                     | Example                                                                                                                                                                                                                                    |
| ---------- | -------------------- | --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Artifacts  | 1 Month              | Preserve long-term artifacts.                                                           | Available in the Artifacts tab of the **Job page** under the `tmp/circle-artifacts.<hash>/container`   or similar directory.                                                                                                         |
| Workspaces | Duration of workflow | Attach the workspace in a downstream container with the `attach_workspace:` step.       | The `attach_workspace` copies and re-creates the entire workspace content when it runs.                                                                                                                                                    |
| Caches     | 15 Days              | Store non-vital data that may help the job run faster, for example npm or Gem packages. | The `save_cache` job step with a `path` to a list of directories to add and a `key` to uniquely identify the cache (for example, the branch, build number, or revision). Restore the cache with `restore_cache` and the appropriate `key`. |
{: class="table table-striped"}

Refer to the [Persisting Data in Workflows: When to Use Caching, Artifacts, and Workspaces](https://circleci.com/blog/persisting-data-in-workflows-when-to-use-caching-artifacts-and-workspaces/) for additional conceptual information about using workspaces, caching, and artifacts.

##### **`add_ssh_keys`**

Special step that adds SSH keys from a project's settings to a container. Also configures SSH to use these keys.

| Key          | Required | Type | Description                                                                          |
| ------------ | -------- | ---- | ------------------------------------------------------------------------------------ |
| fingerprints | N        | List | List of fingerprints corresponding to the keys to be added (default: all keys added) |
{: class="table table-striped"}

```yaml
steps:
  - add_ssh_keys:
      fingerprints:
        - "b7:35:a6:4e:9b:0d:6d:d4:78:1e:9a:97:2a:66:6b:be"
```

**Note:** Even though CircleCI uses `ssh-agent` to sign all added SSH keys, you **must** use the `add_ssh_keys` key to actually add keys to a container.

##### `pipeline.` 値の使用

Pipeline values are available to all pipeline configurations and can be used without previous declaration. The pipeline values available are as follows:

| Value                      | Description                                        |
| -------------------------- | -------------------------------------------------- |
| pipeline.id                | A globally unique id representing for the pipeline |
| pipeline.number            | A project unique integer id for the pipelin        |
| pipeline.project.git_url   | E.g. https://github.com/circleci/circleci-docs     |
| pipeline.project.type      | E.g. "github"                                      |
| pipeline.git.tag           | The tag triggering the pipeline                    |
| pipeline.git.branch        | The branch triggering the pipeline                 |
| pipeline.git.revision      | The current git revision                           |
| pipeline.git.base_revision | The previous git revision                          |
{: class="table table-striped"}

For example:

```yaml
version: 2.1
jobs:
  build:
    docker:
      - image: circleci/node:latest
    environment:
      IMAGETAG: latest
    working_directory: ~/main
    steps:
      - run: echo "This is pipeline ID << pipeline.id >>"
```

## **`workflows`**

Used for orchestrating all jobs. Each workflow consists of the workflow name as a key and a map as a value. A name should be unique within the current `config.yml`. The top-level keys for the Workflows configuration are `version` and `jobs`.

### **`version`**

The Workflows `version` field is used to issue warnings for deprecation or breaking changes during Beta.

| Key     | Required | Type   | Description             |
| ------- | -------- | ------ | ----------------------- |
| version | Y        | String | Should currently be `2` |
{: class="table table-striped"}

### **<`workflow_name`>**

A unique name for your workflow.

#### **`triggers`**

Specifies which triggers will cause this workflow to be executed. Default behavior is to trigger the workflow when pushing to a branch.

| キー       | 必須 | 型     | 説明                              |
| -------- | -- | ----- | ------------------------------- |
| triggers | N  | Array | Should currently be `schedule`. |
{: class="table table-striped"}

##### **`schedule`**

A workflow may have a `schedule` indicating it runs at a certain time, for example a nightly build that runs every day at 12am UTC:

    workflows:
       version: 2
       nightly:
         triggers:
           - schedule:
               cron: "0 0 * * *"
               filters:
                 branches:
                   only:
                     - master
                     - beta
         jobs:
           - test
    

###### **`cron`**

The `cron` key is defined using POSIX `crontab` syntax.

| キー   | 必須 | 型      | 説明                                                                                         |
| ---- | -- | ------ | ------------------------------------------------------------------------------------------ |
| cron | Y  | String | See the [crontab man page](http://pubs.opengroup.org/onlinepubs/7908799/xcu/crontab.html). |
{: class="table table-striped"}

###### **`filters`**

Filters can have the key `branches`.

| キー      | 必須 | 型   | 説明                                                      |
| ------- | -- | --- | ------------------------------------------------------- |
| filters | ○  | Map | A map defining rules for execution on specific branches |
{: class="table table-striped"}

###### **`branches`**
{:.no_toc}

The `branches` key controls whether the *current* branch should have a schedule trigger created for it, where *current* branch is the branch containing the `config.yml` file with the `trigger` stanza. That is, a push on the `master` branch will only schedule a [workflow]({{ site.baseurl }}/2.0/workflows/#using-contexts-and-filtering-in-your-workflows) for the `master` branch.

Branches can have the keys `only` and `ignore` which either map to a single string naming a branch. You may also use regular expressions to match against branches by enclosing them with `/`'s, or map to a list of such strings. Regular expressions must match the **entire** string.

- `only` を指定した場合、一致するブランチでジョブが実行されます。
- `ignore` を指定した場合、一致するブランチではジョブは実行されません。
- `only` と `ignore` のいずれも指定していない場合、すべてのブランチでジョブが実行されます。
- `only` と `ignore` の両方を指定した場合、`ignore` よりも `only` が先に処理されます。

| キー       | 必須 | 型                          | 説明                                                               |
| -------- | -- | -------------------------- | ---------------------------------------------------------------- |
| branches | ○  | マップ                        | 実行するブランチを定義するマップ。                                                |
| only     | Y  | String, or List of Strings | Either a single branch specifier, or a list of branch specifiers |
| ignore   | N  | String, or List of Strings | Either a single branch specifier, or a list of branch specifiers |
{: class="table table-striped"}

#### **`jobs`**

A job can have the keys `requires`, `context`, `type`, and `filters`.

| キー   | 必須 | 型    | 説明                                            |
| ---- | -- | ---- | --------------------------------------------- |
| jobs | ○  | List | A list of jobs to run with their dependencies |
{: class="table table-striped"}

##### **<`job_name`>**

A job name that exists in your `config.yml`.

###### **`requires`**

Jobs are run in parallel by default, so you must explicitly require any dependencies by their job name.

| キー       | 必須 | 型      | 説明                                                                                                                                                                                                     |
| -------- | -- | ------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| requires | N  | リスト    | A list of jobs that must succeed for the job to start                                                                                                                                                  |
| name     | N  | String | A replacement for the job name. Useful when calling a job multiple times. If you want to invoke the same job multiple times and a job requires one of the duplicate jobs, this is required. (2.1 only) |
{: class="table table-striped"}

###### **`context`**

Jobs may be configured to use global environment variables set for an organization, see the [Contexts]({{ site.baseurl }}/2.0/contexts) document for adding a context in the application settings.

| キー      | 必須 | 型      | 説明                                                                                                    |
| ------- | -- | ------ | ----------------------------------------------------------------------------------------------------- |
| context | ×  | String | The name of the context. The initial default name was `org-global`. Each context name must be unique. |
{: class="table table-striped"}

###### **`type`**

A job may have a `type` of `approval` indicating it must be manually approved before downstream jobs may proceed. Jobs run in the dependency order until the workflow processes a job with the `type: approval` key followed by a job on which it depends, for example:

          - hold:
              type: approval
              requires:
                - test1
                - test2
          - deploy:
              requires:
                - hold
    

**Note:** The `hold` job name must not exist in the main configuration.

###### **`filters`**

Filters can have the key `branches` or `tags`. **Note** Workflows will ignore job-level branching. If you use job-level branching and later add workflows, you must remove the branching at the job level and instead declare it in the workflows section of your `config.yml`, as follows:

| キー      | 必須 | 型   | 説明                                                      |
| ------- | -- | --- | ------------------------------------------------------- |
| filters | ×  | Map | A map defining rules for execution on specific branches |
{: class="table table-striped"}

The following is an example of how the CircleCI documentation uses a regex to filter running a workflow for building PDF documentation:

```yaml
# ...
workflows:
  build-deploy:
    jobs:
      - js_build
      - build_server_pdfs: # << the job to conditionally run based on the filter-by-branch-name.
          filters:
            branches:
              only: /server\/.*/
```

The above snippet causes the job `build_server_pdfs` to only be run when the branch being built contains the word "server/" in it.

You can read more about using regex in your config in the [Workflows document]({{ site.baseurl }}/2.0/workflows/#using-regular-expressions-to-filter-tags-and-branches).

###### **`branches`**

{:.no_toc} Branches can have the keys `only` and `ignore` which either map to a single string naming a branch. You may also use regular expressions to match against branches by enclosing them with slashes, or map to a list of such strings. Regular expressions must match the **entire** string.

- Any branches that match `only` will run the job.
- Any branches that match `ignore` will not run the job.
- If neither `only` nor `ignore` are specified then all branches will run the job.
- `only` と `ignore` の両方を指定した場合、`ignore` よりも `only` が先に処理されます。

| キー       | 必須 | 型                          | 説明                                                               |
| -------- | -- | -------------------------- | ---------------------------------------------------------------- |
| branches | ×  | マップ                        | 実行するブランチを定義するマップ。                                                |
| only     | N  | String, or List of Strings | Either a single branch specifier, or a list of branch specifiers |
| ignore   | N  | String, or List of Strings | Either a single branch specifier, or a list of branch specifiers |
{: class="table table-striped"}

###### **`tags`**
{:.no_toc}
CircleCI does not run workflows for tags unless you explicitly specify tag filters. Additionally, if a job requires any other jobs (directly or indirectly), you must specify tag filters for those jobs.

Tags can have the keys `only` and `ignore` keys. You may also use regular expressions to match against tags by enclosing them with slashes, or map to a list of such strings. Regular expressions must match the **entire** string. Both lightweight and annotated tags are supported.

- Any tags that match `only` will run the job.
- Any tags that match `ignore` will not run the job.
- If neither `only` nor `ignore` are specified then the job is skipped for all tags.
- If both `only` and `ignore` are specified the `only` is considered before `ignore`.

| キー     | 必須 | 型              | 説明                                                         |
| ------ | -- | -------------- | ---------------------------------------------------------- |
| tags   | ×  | マップ            | A map defining rules for execution on specific tags        |
| only   | ×  | 文字列、または文字列のリスト | Either a single tag specifier, or a list of tag specifiers |
| ignore | ×  | 文字列、または文字列のリスト | Either a single tag specifier, or a list of tag specifiers |
{: class="table table-striped"}

For more information, see the [Executing Workflows For a Git Tag]({{ site.baseurl }}/2.0/workflows/#executing-workflows-for-a-git-tag) section of the Workflows document.

###### **`matrix`** (requires version: 2.1)

The `matrix` stanza allows you to run a parameterized job multiple times with different arguments.

| キー         | 必須 | 型      | 説明                                                                                                                   |
| ---------- | -- | ------ | -------------------------------------------------------------------------------------------------------------------- |
| parameters | Y  | マップ    | A map of parameter names to every value the job should be called with                                                |
| exclude    | ×  | List   | A list of argument maps that should be excluded from the matrix                                                      |
| alias      | ×  | String | An alias for the matrix, usable from another job's `requires` stanza. Defaults to the name of the job being executed |
{: class="table table-striped"}

The following is a basic example of using matrix jobs.

```yaml
workflows:
  workflow:
    jobs:
      - build:
          matrix:
            parameters:
              version: ["0.1", "0.2", "0.3"]
              platform: ["macos", "windows", "linux"]
```

This expands to 9 different `build` jobs, and could be equivalently written as:

```yaml
workflows:
  workflow:
    jobs:
      - build:
          name: build-macos-0.1
          version: 0.1
          platform: macos
      - build:
          name: build-macos-0.2
          version: 0.2
          platform: macos
      - build:
          name: build-macos-0.3
          version: 0.3
          platform: macos
      - build:
          name: build-windows-0.1
          version: 0.1
          platform: windows
      - ...
```

###### Excluding sets of parameters from a matrix

{:.no_toc} Sometimes you may wish to run a job with every combination of arguments *except* some value or values. You can use an `exclude` stanza to achieve this:

```yaml
workflows:
  workflow:
    jobs:
      - build:
          matrix:
            parameters:
              a: [1, 2, 3]
              b: [4, 5, 6]
            exclude:
              - a: 3
                b: 5
```

The matrix above would expand into 8 jobs: every combination of the parameters `a` and `b`, excluding `{a: 3, b: 5}`

###### Dependencies and matrix jobs
{:.no_toc}

To `require` an entire matrix (every job within the matrix), use its `alias`. The `alias` defaults to the name of the job being invoked.

```yaml
workflows:
  workflow:
    jobs:
      - deploy:
          matrix:
            parameters:
              version: ["0.1", "0.2"]
      - another-job:
          requires:
            - deploy
```

This means that `another-job` will require both deploy jobs in the matrix to finish before it runs.

Additionally, matrix jobs expose their parameter values via `<< matrix.* >>` which can be used to generate more complex workflows. For example, here is a `deploy` matrix where each job waits for its respective `build` job in another matrix.

```yaml
workflows:
  workflow:
    jobs:
      - build:
          name: build-v<< matrix.version >>
          matrix:
            parameters:
              version: ["0.1", "0.2"]
      - deploy:
          name: deploy-v<< matrix.version >>
          matrix:
            parameters:
              version: ["0.1", "0.2"]
          requires:
            - build-v<< matrix.version >>
```

This workflow will expand to:

```yaml
workflows:
  workflow:
    jobs:
      - build:
          name: build-v0.1
          version: 0.1
      - build:
          name: build-v0.2
          version: 0.2
      - deploy:
          name: deploy-v0.1
          version: 0.1
          requires:
            - build-v0.1
      - deploy:
          name: deploy-v0.2
          version: 0.2
          requires:
            - build-v0.2
```

###### **`pre-steps`** and **`post-steps`** (requires version: 2.1)

Every job invocation in a workflow may optionally accept two special arguments: `pre-steps` and `post-steps`.

Steps under `pre-steps` are executed before any of the other steps in the job. The steps under `post-steps` are executed after all of the other steps.

Pre and post steps allow you to execute steps in a given job without modifying the job. This is useful, for example, to run custom setup steps before job execution.

```yaml
version: 2.1

jobs:
  bar:
    machine: true
    steps:

      - checkout
      - run:
          command: echo "building"
      - run:
          command: echo "testing"

workflows:
  build:
    jobs:

      - bar:
          pre-steps: # steps to run before steps defined in the job bar
            - run:
                command: echo "install custom dependency"
          post-steps: # steps to run after steps defined in the job bar
            - run:
                command: echo "upload artifact to s3"
```

##### **ワークフローでの `when` の使用**

With CircleCI v2.1 configuration, you may use a `when` clause (the inverse clause `unless` is also supported) under a workflow declaration with a [logic statement](https://circleci.com/docs/2.0/configuration-reference/#logic-statements) to determine whether or not to run that workflow.

The example configuration below uses a pipeline parameter, `run_integration_tests` to drive the `integration_tests` workflow.

```yaml
version: 2.1

parameters:
  run_integration_tests:
    type: boolean
    default: false

workflows:
  integration_tests:
    when: << pipeline.parameters.run_integration_tests >>
    jobs:

      - mytestjob

jobs:
...
```

This example prevents the workflow `integration_tests` from running unless the tests are invoked explicitly when the pipeline is triggered with the following in the `POST` body:

```sh
{
    "parameters": {
        "run_integration_tests": true
    }
}
```

Refer to the [Orchestrating Workflows]({{ site.baseurl }}/2.0/workflows) document for more examples and conceptual information.

## Logic Statements

Certain dynamic configuration features accept logic statements as arguments. Logic statements are evaluated to boolean values at configuration compilation time, that is - before the workflow is run. The group of logic statements includes:

| Type                                                                                                         | Arguments          | `true` if                              | Example                                              |
| ------------------------------------------------------------------------------------------------------------ | ------------------ | -------------------------------------- | ---------------------------------------------------- |
| YAML literal                                                                                                 | None               | is truthy                              | `true`/`42`/`"a string"`                             |
| [Pipeline Value](https://circleci.com/docs/2.0/pipeline-variables/#pipeline-values)                          | None               | resolves to a truthy value             | `<< pipeline.git.branch >>`              |
| [Pipeline Parameter](https://circleci.com/docs/2.0/pipeline-variables/#pipeline-parameters-in-configuration) | None               | resolves to a truthy value             | `<< pipeline.parameters.my-parameter >>` |
| and                                                                                                          | N logic statements | all arguments are truthy               | `and: [ true, true, false ]`                         |
| or                                                                                                           | N logic statements | any argument is truthy                 | `or: [ false, true, false ]`                         |
| not                                                                                                          | 1 logic statement  | the argument is not truthy             | `not: true`                                          |
| equal                                                                                                        | N values           | all arguments evaluate to equal values | `equal: [ 42, << pipeline.number >>]`    |
{: class="table table-striped"}

Truthiness rules are as follows:

`false`, `null`, `0`, the empty string, and `NaN` are falsy. Any other value is truthy.

Logic statements always evaluate to a boolean value at the top level, and coerce as necessary. They can be nested in an arbitrary fashion, according to their argument specifications, and to a maximum depth of 100 levels.

### Logic Statement Examples

```yaml
workflows:
  my-workflow:
      when:
        condition:
          or:
            - equal: [ master, << pipeline.git.branch >> ]
            - equal: [ staging, << pipeline.git.branch >> ]
```

```yaml
workflows:
  my-workflow:
    when:
      and:
        - not:
            equal: [ master, << pipeline.git.branch >> ]
        - or:
            - equal: [ canary, << pipeline.git.tag >> ]
            - << pipeline.parameters.deploy-canary >>
```

## Example Full Configuration
{:.no_toc}

{% raw %}```yaml
version: 2
jobs:
  build:
    docker:

      - image: ubuntu:14.04

      - image: mongo:2.6.8
        command: [mongod, --smallfiles]

      - image: postgres:9.4.1
        # some containers require setting environment variables
        environment:
          POSTGRES_USER: root

      - image: redis@sha256:54057dd7e125ca41afe526a877e8bd35ec2cdd33b9217e022ed37bdcf7d09673

      - image: rabbitmq:3.5.4

    environment:
      TEST_REPORTS: /tmp/test-reports

    working_directory: ~/my-project

    steps:

      - checkout

      - run:
          command: echo 127.0.0.1 devhost | sudo tee -a /etc/hosts

      # Create Postgres users and database
      # Note the YAML heredoc '|' for nicer formatting

      - run: |
          sudo -u root createuser -h localhost --superuser ubuntu &&
          sudo createdb -h localhost test_db

      - restore_cache:
          keys:
            - v1-my-project-{{ checksum "project.clj" }}
            - v1-my-project-

      - run:
          environment:
            SSH_TARGET: "localhost"
            TEST_ENV: "linux"
          command: |
            set -xu
            mkdir -p ${TEST_REPORTS}
            run-tests.sh
            cp out/tests/*.xml ${TEST_REPORTS}

      - run: |
          set -xu
          mkdir -p /tmp/artifacts
          create_jars.sh ${CIRCLE_BUILD_NUM}
          cp *.jar /tmp/artifacts

      - save_cache:
          key: v1-my-project-{{ checksum "project.clj" }}
          paths:
            - ~/.m2

      # Save artifacts

      - store_artifacts:
          path: /tmp/artifacts
          destination: build

      # Upload test results

      - store_test_results:
          path: /tmp/test-reports

  deploy-stage:
    docker:

      - image: ubuntu:14.04
    working_directory: /tmp/my-project
    steps:
      - run:
          name: Deploy if tests pass and branch is Staging
          command: ansible-playbook site.yml -i staging

  deploy-prod:
    docker:

      - image: ubuntu:14.04
    working_directory: /tmp/my-project
    steps:
      - run:
          name: Deploy if tests pass and branch is Master
          command: ansible-playbook site.yml -i production

workflows:
  version: 2
  build-deploy:
    jobs:

      - build:
          filters:
            branches:
              ignore:
                - develop
                - /feature-.*/
      - deploy-stage:
          requires:
            - build
          filters:
            branches:
              only: staging
      - deploy-prod:
          requires:
            - build
          filters:
            branches:
              only: master
```

{% endraw %}

## See Also
{:.no_toc}

[Config Introduction]({{site.baseurl}}/2.0/config-intro/)