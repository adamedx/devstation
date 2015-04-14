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
under a subdirectory managed with your **Chef Server's knife configuration**:

```
git clone https://github.com/adamedx/devstation
```

## Usage

This cookbook creates a Chef Windows workstation virtual machine (VM) on Azure bootstrapped
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
  counterpart attribute, `user_secret` and `storage_account`
  respectively; the attribute may be specified instead of the
  environment variable.
* Run chef-client in local mode from this cookbook's subdirectory with this cookbook as the runlist:
    `chef-client -z -o devstation`

The last command  assumes that your knife configuration is in a path at or
above the cookbook directory.

### What it does

The chef-client run with his cookbook on your Chef workstation will do the following:

* Create a VM in Azure named `devstation` with a public DNS name of
  `devstation.cloudapp.net`
* Bootstrap it against the Chef server in your `knife.rb`
* Run the configuration for the new workstation on the VM.

### Refreshing cookbook dependencies

The dependencies for this cookbook may change from time to time. You
can refresh them using berkshelf, i.e.

```
berks vendor cookbooks
```

Dependencies such as the cookbooks used to provision the remote
workstation can then be updated.

## Customization

As noted earlier, attributes and environment variables on the system
running this cookbook  may be used to customize the cookbook's execution -- cookbook attributes always take
precedence over environment variables:

| Attribute | Environment Variable | Purpose |
|-----------|----------------------|---------|
| `user_secret` | `DEVSTATION_USER_SECRET` | Mandatory. The password for the user account `localadmin` that will be created on the VM and used to execute recipes during bootstrap  |
| `storage_account` | `DEVSTATION_STORAGE_ACCOUNT` | Mandatory. You can use existing storage account to which you have access through your Azure subscription, or specify a name unique across all Azure subscriptions for a new storage account |
|`image_id`|`DEVSTATION_IMAGE_ID`| Optional. The VM image used to create the VM -- defaults to a Windows Server 2012 image: `a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201502.01-en.us-127GB.vhd`|
|`transport` | `DEVSTATION_TRANSPORT` | Optional. The bootstrap transport, currently either `:winrm` or `:ssh`. Default is `:winrm`|
| `location` | `DEVSTATION_LOCATION` | Optional. The Azure service location in which to create the VM -- defaults to `West US`|
| `workstation_name` | `DEVSTATION_WORKSTATION_NAME` | Optional. By default, the VM created by the default recipe is named `devstation` --  specify this setting to override it |
| `vm_size` | `DEVSTATION_VM_SIZE` | Optional. The VM resource size (e.g. number of cores, memory, etc.). Defaults to `Medium` |
| `tcp_endpoints` | `DEVSTASTION_TCP_ENDPOINTS` | Optional. Default is the empty string. It can be set with a list of public and private port mappings, e.g. `'3389:3389,22:2222'` |
| `cloud_service` | *None.* | Optional. By default, the cloud service is the same as the the workstation name, which itself defaults to `devstation` and results in a public DNS name for the VM of `devstation.cloudapp.net` |


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


