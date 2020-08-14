---
layout: classic-docs
title: "API を使用したジョブのトリガー"
short-title: "API を使用したジョブのトリガー"
description: "ビルド以外のジョブを定義およびトリガーする方法"
categories:
  - configuring-jobs
order: 80
---


CircleCI API を使用してジョブをトリガーする方法について説明します。

<div class="alert alert-warning" role="alert">
  <p><span style="font-size: 115%; font-weight: bold;">⚠️ Heads up!</span></p>
  <span> This document refers to using the legacy CircleCI API 1.0, a service that will be eventually be deprecated in favour of the <a href="https://circleci.com/docs/api/v2/#circleci-api">V2 API</a>. Consider using the <a href="https://circleci.com/docs/api/v2/#trigger-a-new-pipeline">Pipelines</a> endpoints to trigger pipelines.</span>
</div>

- 目次
{:toc}

## 概要

Use the [CircleCI API](https://circleci.com/docs/api/v1/#trigger-a-new-job) to trigger [jobs]({{ site.baseurl }}/2.0/jobs-steps/#jobs-overview) that you have defined in `.circleci/config.yml`.

The following example shows how to trigger the `deploy_docker` job by using `curl`.

```bash
curl -u ${CIRCLE_API_USER_TOKEN}: \
     -d build_parameters[CIRCLE_JOB]=deploy_docker \
     https://circleci.com/api/v1.1/project/<vcs-type>/<org>/<repo>/tree/<branch>
```

Some notes on the variables used in this example:

- `CIRCLE_API_USER_TOKEN`: [パーソナル API トークン]({{ site.baseurl }}/2.0/managing-api-tokens/#パーソナル-api-トークンの作成).
- `<vcs-type>`: 選択された VCS (`github` または `bitbucket`) を示すプレースホルダー変数
- `<org>`: CircleCI 組織の名前を示すプレースホルダー変数
- `<repo>`: リポジトリの名前を示すプレースホルダー変数
- `<branch>`: ブランチの名前を示すプレースホルダー変数

For a complete reference of the API, see the [CircleCI API Documentation](https://circleci.com/docs/api/v2/#section=reference).

**Important Considerations When Triggering A Job Via The API**

- API によってトリガーされるジョブに `workflows` セクションが含まれてもかまいません。
- ワークフローが、API によってトリガーされるジョブを参照する必要は**ありません**。
- API によってトリガーされたジョブは、特定の [CircleCI コンテキスト]({{ site.baseurl }}/2.0/contexts/)用に作成された環境変数にアクセス**できません**。
- 環境変数を使用する場合は、それらの環境変数が[プロジェクトレベル]({{ site.baseurl }}/2.0/env-vars/#プロジェクトでの環境変数の設定)で定義されている必要があります。
- 現在のところ、CircleCI 2.1 とワークフローを使用する場合には、単一のジョブをトリガーすることができません。
- It is possible to trigger [workflows]({{ site.baseurl }}/2.0/workflows/) with the CircleCI API: a [singular workflow can be re-run](https://circleci.com/docs/api/v2/#rerun-a-workflow), or you may [trigger a pipeline](https://circleci.com/docs/api/v2/#trigger-a-new-pipeline) which will run its subsequent workflows. 

## API を使用したジョブの条件付き実行

The next example demonstrates a configuration for building docker images with `setup_remote_docker` only for builds that should be deployed.

```yaml
version: 2
jobs:
  build:
    docker:
      - image: ruby:2.4.0-jessie
        environment:
          LANG: C.UTF-8
    working_directory: /my-project
    parallelism: 2
    steps:
      - checkout

      - run: echo "run some tests"

      - deploy:
          name: デプロイ ジョブを条件付きで実行
          command: |
            # これをビルド・デプロイのチェックに置き換えます (すなわち、現在のブランチが "release")
            if [[ true ]]; then
              curl --user ${CIRCLE_API_USER_TOKEN}: \
                --data build_parameters[CIRCLE_JOB]=deploy_docker \
                --data revision=$CIRCLE_SHA1 \
                https://circleci.com/api/v1.1/project/github/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/tree/$CIRCLE_BRANCH
            fi

  deploy_docker:
    docker:

      - image: ruby:2.4.0-jessie
    working_directory: /
    steps:
      - setup_remote_docker
      - run: echo "deploy section running"
```

Notes on the above example:

- Using the `deploy` step in the build job is important to prevent triggering N builds, where N is your parallelism value - `deploy` is a special step that will only run on one container, even when the job parallelism is set greater that one.
- API 呼び出しを `build_parameters[CIRCLE_JOB]=deploy_docker` で使用し、`deploy_docker` ジョブのみが実行されるようにします。

## 関連項目

[Triggers]({{ site.baseurl }}/2.0/triggers/)