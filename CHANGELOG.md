# Changelog

## [0.7.0](https://github.com/CloudNationHQ/az-cn-module-tf-acr/compare/v0.6.0...v0.7.0) (2023-10-17)


### Features

* add private link support and private dns sub module ([#33](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/33)) ([5f3573e](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/5f3573e41bee47b77b03866d1c0304e720d4da52))
* cleanup redundant provider blocks in example usages ([#32](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/32)) ([f42a62b](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/f42a62bea4fce182e36a89cc12ee31868480ecd3))
* **deps:** Bump github.com/Azure/azure-sdk-for-go/sdk/azidentity in /tests ([#31](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/31)) ([4ba8029](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/4ba8029fd60da5f62f97700569e8fa6d3f2ba094))
* **deps:** bump github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/containerregistry/armcontainerregistry ([#28](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/28)) ([22886af](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/22886afd67e0060973a04ace4b5e830d88b6ffd1))
* **deps:** bump github.com/stretchr/testify from 1.8.1 to 1.8.4 in /tests ([#24](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/24)) ([ea1f9bb](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/ea1f9bb963270e8e19d933b0a7e8be1c9f72975e))
* **deps:** Bump golang.org/x/net from 0.14.0 to 0.17.0 in /tests ([#30](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/30)) ([0093efa](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/0093efa975af4c2282ff38db2adf5f9a660d156a))
* fix referenced output names keyvault ([#26](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/26)) ([6969ccd](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/6969ccd24a61175527ed44d2e368c2b75055e9dc))

## [0.6.0](https://github.com/CloudNationHQ/az-cn-module-tf-acr/compare/v0.5.0...v0.6.0) (2023-09-18)


### Features

* add extended tests ([#23](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/23)) ([e888fe9](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/e888fe9053deeff27f18c525d66f8ace6f57eb12))
* **deps:** Bump github.com/gruntwork-io/terratest from 0.43.12 to 0.43.13 in /tests ([#22](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/22)) ([c05ee4d](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/c05ee4d36925a1a9b623f878b56ca57be4ccd858))
* update documentation and small refactor ([#20](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/20)) ([e6347db](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/e6347db0e428024fe156accd3781a4483745871b))

## [0.5.0](https://github.com/CloudNationHQ/az-cn-module-tf-acr/compare/v0.4.0...v0.5.0) (2023-08-26)


### Features

* add consistent naming and added the ability to enable private link using a existing private dns zone in another subscription ([#18](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/18)) ([ce068e0](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/ce068e01085f727e79de82b47bd5f5a2fbbb751c))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#17](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/17)) ([2655555](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/2655555c4cac855682e8ba18208f91f931e503e0))

## [0.4.0](https://github.com/CloudNationHQ/az-cn-module-tf-acr/compare/v0.3.0...v0.4.0) (2023-07-28)


### Features

* add agentpool support ([#14](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/14)) ([140acb6](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/140acb68202363a6406206a45d77414e98ee2c8d))
* add agentpool tasks and private link support ([#15](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/15)) ([a6a77fd](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/a6a77fde73667ecb69a7aa436476fba3f19056d6))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#13](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/13)) ([1e2dfad](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/1e2dfad0cf04f975955443b3bb290300bb7f339f))
* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#9](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/9)) ([d7932e2](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/d7932e27d616bcd0c93e529071a24f8b4f133678))
* **deps:** bump google.golang.org/grpc from 1.51.0 to 1.53.0 in /tests ([#10](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/10)) ([5465c71](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/5465c71f94e6a34c6b140976742519e53eed473b))

## [0.3.0](https://github.com/CloudNationHQ/az-cn-module-tf-acr/compare/v0.2.0...v0.3.0) (2023-06-29)


### Features

* refactor workflows and fix linting issues ([#7](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/7)) ([cbee76b](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/cbee76b81bf36df32c00e612da51d45c60c83241))

## [0.2.0](https://github.com/CloudNationHQ/az-cn-module-tf-acr/compare/v0.1.0...v0.2.0) (2023-06-28)


### Features

* add initial testing ([#5](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/5)) ([c88f1f8](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/c88f1f87df22fb285ab77166cd7122c239225807))

## 0.1.0 (2023-06-28)


### Features

* add initial resources ([#3](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/3)) ([ae22a9f](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/ae22a9f8abc62440c4a742f367386fa06435ba21))
* add workflows ([#1](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/1)) ([b3a05c7](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/b3a05c74f06e4c91dce07ad63ad523d4ad08249e))
* update documentation ([#4](https://github.com/CloudNationHQ/az-cn-module-tf-acr/issues/4)) ([bf9fd73](https://github.com/CloudNationHQ/az-cn-module-tf-acr/commit/bf9fd735c3ad3b6126e7bc8d8814c094fdeab631))
