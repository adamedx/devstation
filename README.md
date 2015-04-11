# devstation

Uses Chef-provisioning on your Chef workstation to set up another Chef
workstation hosted in Microsoft Azure.

## Prerequisites

To use this cookbook, do the following on your Chef workstation

* Install the Chef Development Kit (Chef-DK)
* Configure the workstation with a knife / Berkshelf configuration to
  interact with a Chef Server
* Use the following command to install the latest
  `chef-provisioning-azure` gem:

```
chef gem install chef-provisioning-azure
```

## Installation

Install the cookbook on your workstation by cloning its repository
under a subdirectory managed with your Chef Server's knife configuration:

```
git clone https://github.com/adamedx/devstation
```

## Usage

This cookbook creates a Chef Windows workstation VM on Azure bootstrapped
against your favorite Chef server. Use chef-client from that workstation to execute this cookbook's
default recipe. The cookbook must be run on a Chef workstation that meets the prerequisites:

* In a shell, set the current directory to the `devstation` cloned
  directory
* Use `berkshelf` to create a cookbooks subdirectory:
    `berks vendor cookbooks`
* Upload the cookbooks to your Chef server
    `berks upload`
* Set the shell environment variable `DEVSTATION_USER_SECRET` to the
  password you'd like to set for the account `localadmin` on the
  remote system.
* Set the shell environment variable `DEVSTATION_STORAGE_ACCOUNT` to
  use an existing storage account.
* Alternatively, each of the shell environment variables above has a
  counterpart attribute, `user_secret` and `storage_account` respectively.
* Run chef-client in local mode with this cookbook as the runlist:
    `chef-client -z -o devstation -c YOUR_KNIFE_CONFIG`
    where `YOUR_KNIFE_CONFIG` points to a knife config file that can
    bootstrap a Chef node to some Chef server. You can ommit the last
    option if there's a correctly configured .chef directory somewhere
    in the current path

The chef-client run on your Chef workstation will do the following:

* Create a VM in Azure named `devstation` with a public DNS name of
  `devstation.cloudapp.net` 
* Bootstrap it against the Chef server in your `knife.rb`
* Run the configuration for the new workstation

## Customization

As noted earlier, attributes and environment variables on the system
running this cookbook  may be used to customize the cookbook's execution -- cookbook attributes always take
precedence over environment variables:

| Attribute | Environment Variable | Purpose |
|-----------|----------------------|---------|
| `user_secret` | `DEVSTATION_USER_SECRET` | Mandatory. The password for the user account `localadmin` that will be created on the VM and used to execute recipes during bootstrap  |
| `storage_account` | `DEVSTATION_STORAGE_ACCOUNT` | Optional. By default, a new Azure storage account is created for the new VM, specify an existing account to use that instead |


License and Authors
-------------------
Copyright:: Copyright (c) 2015 Adam Edwards

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


