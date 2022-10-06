# Exercise 8: Debugging Terraform

We'll use this exercise to get a chance to see `TF_LOG` and `TF_LOG_PATH` in action

Let's start by running `terraform init` with the normal, default verbosity level, so without `TF_LOG` set:

```
$ terraform init

Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Pretty simple and familiar. Let's try one of the others settings for `TF_LOG`: `ERROR`:

```
$ TF_LOG=ERROR terraform init
Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v3.40.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Interesting, nothing seems to be different. Presumably Hashicorp still has more work to do in this area. We should reliably have the ability to use `TRACE` though, so let's see what that looks like

```
$ TF_LOG=TRACE terraform init
2021-05-14T12:44:10.873+0200 [DEBUG] Adding temp file log sink: /var/folders/xf/z32xw__d1pldq1l4c120q2ph0000gq/T/terraform-log330311741
2021-05-14T12:44:10.873+0200 [INFO]  Terraform version: 0.15.3
2021-05-14T12:44:10.873+0200 [INFO]  Go runtime version: go1.16.3
2021-05-14T12:44:10.873+0200 [INFO]  CLI args: []string{"/usr/local/bin/terraform", "init"}
2021-05-14T12:44:10.873+0200 [TRACE] Stdout is a terminal of width 140
2021-05-14T12:44:10.873+0200 [TRACE] Stderr is a terminal of width 140
2021-05-14T12:44:10.873+0200 [TRACE] Stdin is a terminal
2021-05-14T12:44:10.873+0200 [DEBUG] Attempting to open CLI config file: /Users/milleniumfalcon/.terraformrc
2021-05-14T12:44:10.873+0200 [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
2021-05-14T12:44:10.874+0200 [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
2021-05-14T12:44:10.874+0200 [DEBUG] ignoring non-existing provider search directory /Users/milleniumfalcon/.terraform.d/plugins
2021-05-14T12:44:10.874+0200 [DEBUG] ignoring non-existing provider search directory /Users/milleniumfalcon/Library/Application Support/io.terraform/plugins
2021-05-14T12:44:10.874+0200 [DEBUG] ignoring non-existing provider search directory /Library/Application Support/io.terraform/plugins
2021-05-14T12:44:10.874+0200 [INFO]  CLI command args: []string{"init"}

Initializing the backend...
2021-05-14T12:44:10.876+0200 [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
2021-05-14T12:44:10.876+0200 [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
2021-05-14T12:44:10.877+0200 [DEBUG] New state was assigned lineage "c81326e6-5ef6-aa0e-2749-6028d302b0af"
2021-05-14T12:44:10.877+0200 [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
2021-05-14T12:44:10.877+0200 [TRACE] Meta.Backend: instantiated backend of type <nil>
2021-05-14T12:44:10.877+0200 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
2021-05-14T12:44:10.878+0200 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v3.40.0 for darwin_amd64 at .terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64
2021-05-14T12:44:10.878+0200 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 3.40.0
2021-05-14T12:44:11.371+0200 [DEBUG] checking for provisioner in "."
2021-05-14T12:44:11.373+0200 [DEBUG] checking for provisioner in "/usr/local/bin"
2021-05-14T12:44:11.373+0200 [INFO]  Failed to read plugin lock file .terraform/plugins/darwin_amd64/lock.json: open .terraform/plugins/darwin_amd64/lock.json: no such file or directory
2021-05-14T12:44:11.373+0200 [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
2021-05-14T12:44:11.373+0200 [TRACE] backend/local: state manager for workspace "default" will:
 - read initial snapshot from terraform.tfstate
 - write new snapshots to terraform.tfstate
 - create any backup at terraform.tfstate.backup
2021-05-14T12:44:11.373+0200 [TRACE] statemgr.Filesystem: reading initial snapshot from terraform.tfstate
2021-05-14T12:44:11.373+0200 [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but that's okay
2021-05-14T12:44:11.373+0200 [TRACE] statemgr.Filesystem: read nil snapshot

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
2021-05-14T12:44:11.374+0200 [DEBUG] Service discovery for registry.terraform.io at https://registry.terraform.io/.well-known/terraform.json
2021-05-14T12:44:11.374+0200 [TRACE] HTTP client GET request to https://registry.terraform.io/.well-known/terraform.json
2021-05-14T12:44:11.519+0200 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/versions
2021-05-14T12:44:11.519+0200 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/aws/versions
2021-05-14T12:44:11.614+0200 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
2021-05-14T12:44:11.614+0200 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v3.40.0 for darwin_amd64 at .terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64
2021-05-14T12:44:11.614+0200 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 3.40.0
- Using previously-installed hashicorp/aws v3.40.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Wow, so we get quite a bit more info on this run, telling us a lot about what Terraform is doing under the hood over the course of executing the init.

First, note the log levels available on each line. So, the following would be info I'd only get when running with `TRACE`:

```
2021-05-14T12:44:11.373+0200 [TRACE] backend/local: state manager for workspace "default" will:
 - read initial snapshot from terraform.tfstate
 - write new snapshots to terraform.tfstate
 - create any backup at terraform.tfstate.backup
```

Let's step through the whole thing though and pick out some particularly noteworthy lines

```
2021-05-14T12:44:10.873+0200 [DEBUG] Attempting to open CLI config file: /Users/milleniumfalcon/.terraformrc
```

Ah, so Terraform has the concept of a local CLI config file. We've not covered that in this course, nor will we, but even looking deeper into logs this way can be a good source of learning.

```
2021-05-14T12:44:10.877+0200 [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
```

We are indeed using a local state configuration in this exercise, no remote state backend. We get some more info about `init` setting up state and awareness, and remote state backend should we have our project configured to use a remote backend.

```
2021-05-14T12:44:11.371+0200 [DEBUG] checking for provisioner in "."
2021-05-14T12:44:11.373+0200 [DEBUG] checking for provisioner in "/usr/local/bin"
2021-05-14T12:44:11.373+0200 [INFO]  Failed to read plugin lock file .terraform/plugins/darwin_amd64/lock.json: open .terraform/plugins/darwin_amd64/lock.json: no such file or directory
```

This sort of info gives us more visibility into what Terraform is doing to identify providers defined in code, and find the provider plugin locally if it can, otherwise download it.

Let's use this same approach to help us see more about an error. Let's have a look at our `main.tf`

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_invalid_resource_type" "name" {
  id = "${var.student_alias}-01"
}
```

Syntactically all seems OK. But, we're going to attempt to create a resource that isn't defined or available in our AWS provider. Of the 4 error types we discussed, what type of error do you think this should produce?

Let's see the error first without default log verbosity:

```
$ terraform plan
Error: Invalid resource type

  on main.tf line 9, in resource "aws_invalid_resource_type" "name":
   9: resource "aws_invalid_resource_type" "name" {

The provider provider.aws does not support resource type
"aws_invalid_resource_type".
```

Next, let's just revisit `terraform validate`. It's another root subcommand of the Terraform CLI and gives us the ability to validate our code in isolation from other commands. We talked about `terraform init` being able to do some syntax checking. `terraform validate` goes one step further to make sure that things like our resource definitions are valid:

```
$ terraform validate
Error: Invalid resource type

  on main.tf line 9, in resource "aws_invalid_resource_type" "name":
   9: resource "aws_invalid_resource_type" "name" {

The provider provider.aws does not support resource type
"aws_invalid_resource_type".
```

The exact same output we got from plan. This suggests that plan also runs just what `terraform validate` does, and this is indeed true. The separation of this validation into a separate command can be useful in certain workflows, especially automated ones that are focused on failing fast and with distinct gates or stages.

Whether it comes from `validate` or `plan`, helpful output even with this log level, should be pretty easy for us to identify the problem in this simple example scenario, but of course the context won't always be this clear. So, let's turn on `TRACE` logging and see what we can see

```
$ TF_LOG=TRACE terraform plan
2021-05-14T12:51:12.987+0200 [DEBUG] Adding temp file log sink: /var/folders/xf/z32xw__d1pldq1l4c120q2ph0000gq/T/terraform-log685440876
2021-05-14T12:51:12.987+0200 [INFO]  Terraform version: 0.15.3
2021-05-14T12:51:12.987+0200 [INFO]  Go runtime version: go1.16.3
2021-05-14T12:51:12.987+0200 [INFO]  CLI args: []string{"/usr/local/bin/terraform", "plan"}
2021-05-14T12:51:12.987+0200 [TRACE] Stdout is a terminal of width 140
2021-05-14T12:51:12.987+0200 [TRACE] Stderr is a terminal of width 140
2021-05-14T12:51:12.987+0200 [TRACE] Stdin is a terminal
2021-05-14T12:51:12.987+0200 [DEBUG] Attempting to open CLI config file: /Users/milleniumfalcon/.terraformrc
2021-05-14T12:51:12.987+0200 [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
2021-05-14T12:51:12.987+0200 [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
2021-05-14T12:51:12.988+0200 [DEBUG] ignoring non-existing provider search directory /Users/milleniumfalcon/.terraform.d/plugins
2021-05-14T12:51:12.988+0200 [DEBUG] ignoring non-existing provider search directory /Users/milleniumfalcon/Library/Application Support/io.terraform/plugins
2021-05-14T12:51:12.988+0200 [DEBUG] ignoring non-existing provider search directory /Library/Application Support/io.terraform/plugins
2021-05-14T12:51:12.988+0200 [INFO]  CLI command args: []string{"plan"}
2021-05-14T12:51:12.989+0200 [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
2021-05-14T12:51:12.989+0200 [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
2021-05-14T12:51:12.989+0200 [DEBUG] New state was assigned lineage "ff31a9fb-cb57-1888-10db-26d426fa4549"
2021-05-14T12:51:12.989+0200 [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
2021-05-14T12:51:12.989+0200 [TRACE] Meta.Backend: instantiated backend of type <nil>
2021-05-14T12:51:12.989+0200 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
2021-05-14T12:51:12.990+0200 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v3.40.0 for darwin_amd64 at .terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64
2021-05-14T12:51:12.990+0200 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 3.40.0
2021-05-14T12:51:13.476+0200 [DEBUG] checking for provisioner in "."
2021-05-14T12:51:13.477+0200 [DEBUG] checking for provisioner in "/usr/local/bin"
2021-05-14T12:51:13.477+0200 [INFO]  Failed to read plugin lock file .terraform/plugins/darwin_amd64/lock.json: open .terraform/plugins/darwin_amd64/lock.json: no such file or directory
2021-05-14T12:51:13.478+0200 [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
2021-05-14T12:51:13.478+0200 [INFO]  backend/local: starting Plan operation
2021-05-14T12:51:13.478+0200 [TRACE] backend/local: requesting state manager for workspace "default"
2021-05-14T12:51:13.478+0200 [TRACE] backend/local: state manager for workspace "default" will:
 - read initial snapshot from terraform.tfstate
 - write new snapshots to terraform.tfstate
 - create any backup at terraform.tfstate.backup
2021-05-14T12:51:13.478+0200 [TRACE] backend/local: requesting state lock for workspace "default"
2021-05-14T12:51:13.478+0200 [TRACE] statemgr.Filesystem: preparing to manage state snapshots at terraform.tfstate
2021-05-14T12:51:13.479+0200 [TRACE] statemgr.Filesystem: no previously-stored snapshot exists
2021-05-14T12:51:13.479+0200 [TRACE] statemgr.Filesystem: locking terraform.tfstate using fcntl flock
2021-05-14T12:51:13.479+0200 [TRACE] statemgr.Filesystem: writing lock metadata to .terraform.tfstate.lock.info
2021-05-14T12:51:13.479+0200 [TRACE] backend/local: reading remote state for workspace "default"
2021-05-14T12:51:13.479+0200 [TRACE] statemgr.Filesystem: reading latest snapshot from terraform.tfstate
2021-05-14T12:51:13.479+0200 [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but that's okay
2021-05-14T12:51:13.479+0200 [TRACE] statemgr.Filesystem: read nil snapshot
2021-05-14T12:51:13.479+0200 [TRACE] backend/local: retrieving local state snapshot for workspace "default"
2021-05-14T12:51:13.479+0200 [TRACE] backend/local: building context for current working directory
2021-05-14T12:51:13.480+0200 [TRACE] terraform.NewContext: starting
2021-05-14T12:51:13.480+0200 [TRACE] terraform.NewContext: loading provider schemas
2021-05-14T12:51:13.480+0200 [TRACE] LoadSchemas: retrieving schema for provider type "registry.terraform.io/hashicorp/aws"
2021-05-14T12:51:13.480+0200 [DEBUG] created provider logger: level=trace
2021-05-14T12:51:13.480+0200 [INFO]  provider: configuring client automatic mTLS
2021-05-14T12:51:13.512+0200 [DEBUG] provider: starting plugin: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 args=[.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5]
2021-05-14T12:51:13.522+0200 [DEBUG] provider: plugin started: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 pid=31291
2021-05-14T12:51:13.522+0200 [DEBUG] provider: waiting for RPC address: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5
2021-05-14T12:51:13.567+0200 [INFO]  provider.terraform-provider-aws_v3.40.0_x5: configuring server automatic mTLS: timestamp=2021-05-14T12:51:13.567+0200
2021-05-14T12:51:13.605+0200 [DEBUG] provider: using plugin: version=5
2021-05-14T12:51:13.605+0200 [DEBUG] provider.terraform-provider-aws_v3.40.0_x5: plugin address: address=/var/folders/xf/z32xw__d1pldq1l4c120q2ph0000gq/T/plugin815756486 network=unix timestamp=2021-05-14T12:51:13.605+0200
2021-05-14T12:51:13.645+0200 [TRACE] GRPCProvider: GetProviderSchema
2021-05-14T12:51:13.645+0200 [TRACE] provider.stdio: waiting for stdio data
2021-05-14T12:51:13.719+0200 [TRACE] GRPCProvider: Close
2021-05-14T12:51:13.720+0200 [DEBUG] provider.stdio: received EOF, stopping recv loop: err="rpc error: code = Unavailable desc = transport is closing"
2021-05-14T12:51:13.723+0200 [DEBUG] provider: plugin process exited: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 pid=31291
2021-05-14T12:51:13.723+0200 [DEBUG] provider: plugin exited
2021-05-14T12:51:13.723+0200 [TRACE] terraform.NewContext: complete
2021-05-14T12:51:13.723+0200 [TRACE] backend/local: finished building terraform.Context
2021-05-14T12:51:13.724+0200 [TRACE] backend/local: requesting interactive input, if necessary
2021-05-14T12:51:13.724+0200 [TRACE] Context.Input: Prompting for provider arguments
2021-05-14T12:51:13.724+0200 [TRACE] Context.Input: Provider provider.aws implied by resource block at main.tf:14,1-44
2021-05-14T12:51:13.724+0200 [TRACE] Context.Input: Input for provider.aws: map[string]cty.Value{}
2021-05-14T12:51:13.724+0200 [TRACE] backend/local: running validation operation
2021-05-14T12:51:13.724+0200 [INFO]  terraform: building graph: GraphTypeValidate
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.ConfigTransformer
2021-05-14T12:51:13.724+0200 [TRACE] ConfigTransformer: Starting for path:
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.ConfigTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
  data.aws_vpc.default - *terraform.NodeValidatableResource
  ------
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.RootVariableTransformer
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.RootVariableTransformer (no changes)
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.ModuleVariableTransformer
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.ModuleVariableTransformer (no changes)
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.LocalTransformer
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.LocalTransformer (no changes)
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.OutputTransformer
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.OutputTransformer (no changes)
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.OrphanResourceInstanceTransformer
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.OrphanResourceInstanceTransformer (no changes)
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.StateTransformer
2021-05-14T12:51:13.724+0200 [TRACE] StateTransformer: state is empty, so nothing to do
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.StateTransformer (no changes)
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.AttachStateTransformer
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.AttachStateTransformer (no changes)
2021-05-14T12:51:13.724+0200 [TRACE] Executing graph transform *terraform.OrphanOutputTransformer
2021-05-14T12:51:13.724+0200 [TRACE] Completed graph transform *terraform.OrphanOutputTransformer (no changes)
2021-05-14T12:51:13.725+0200 [TRACE] Executing graph transform *terraform.AttachResourceConfigTransformer
2021-05-14T12:51:13.725+0200 [TRACE] AttachResourceConfigTransformer: attaching to "data.aws_vpc.default" (*terraform.NodeValidatableResource) config from hcl.Range{Filename:"main.tf", Start:hcl.Pos{Line:10, Column:1, Byte:117}, End:hcl.Pos{Line:10, Column:25, Byte:141}}
2021-05-14T12:51:13.725+0200 [TRACE] AttachResourceConfigTransformer: attaching provider meta configs to data.aws_vpc.default
2021-05-14T12:51:13.725+0200 [TRACE] AttachResourceConfigTransformer: attaching to "aws_invalid_resource_type.name" (*terraform.NodeValidatableResource) config from main.tf:14,1-44
2021-05-14T12:51:13.725+0200 [TRACE] AttachResourceConfigTransformer: attaching provider meta configs to aws_invalid_resource_type.name
2021-05-14T12:51:13.725+0200 [TRACE] Completed graph transform *terraform.AttachResourceConfigTransformer (no changes)
2021-05-14T12:51:13.725+0200 [TRACE] Executing graph transform *terraform.graphTransformerMulti
2021-05-14T12:51:13.725+0200 [TRACE] (graphTransformerMulti) Executing graph transform *terraform.ProviderConfigTransformer
2021-05-14T12:51:13.725+0200 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.ProviderConfigTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
  data.aws_vpc.default - *terraform.NodeValidatableResource
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:51:13.725+0200 [TRACE] (graphTransformerMulti) Executing graph transform *terraform.MissingProviderTransformer
2021-05-14T12:51:13.725+0200 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.MissingProviderTransformer (no changes)
2021-05-14T12:51:13.725+0200 [TRACE] (graphTransformerMulti) Executing graph transform *terraform.ProviderTransformer
2021-05-14T12:51:13.725+0200 [TRACE] ProviderTransformer: exact match for provider["registry.terraform.io/hashicorp/aws"] serving aws_invalid_resource_type.name
2021-05-14T12:51:13.725+0200 [DEBUG] ProviderTransformer: "aws_invalid_resource_type.name" (*terraform.NodeValidatableResource) needs provider["registry.terraform.io/hashicorp/aws"]
2021-05-14T12:51:13.725+0200 [TRACE] ProviderTransformer: exact match for provider["registry.terraform.io/hashicorp/aws"] serving data.aws_vpc.default
2021-05-14T12:51:13.725+0200 [DEBUG] ProviderTransformer: "data.aws_vpc.default" (*terraform.NodeValidatableResource) needs provider["registry.terraform.io/hashicorp/aws"]
2021-05-14T12:51:13.725+0200 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.ProviderTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:51:13.725+0200 [TRACE] (graphTransformerMulti) Executing graph transform *terraform.PruneProviderTransformer
2021-05-14T12:51:13.725+0200 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.PruneProviderTransformer (no changes)
2021-05-14T12:51:13.725+0200 [TRACE] Completed graph transform *terraform.graphTransformerMulti with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:51:13.725+0200 [TRACE] Executing graph transform *terraform.RemovedModuleTransformer
2021-05-14T12:51:13.725+0200 [TRACE] Completed graph transform *terraform.RemovedModuleTransformer (no changes)
2021-05-14T12:51:13.725+0200 [TRACE] Executing graph transform *terraform.AttachSchemaTransformer
2021-05-14T12:51:13.725+0200 [ERROR] AttachSchemaTransformer: No resource schema available for aws_invalid_resource_type.name
2021-05-14T12:51:13.725+0200 [TRACE] AttachSchemaTransformer: attaching resource schema to data.aws_vpc.default
2021-05-14T12:51:13.725+0200 [TRACE] AttachSchemaTransformer: attaching provider config schema to provider["registry.terraform.io/hashicorp/aws"]
2021-05-14T12:51:13.726+0200 [TRACE] Completed graph transform *terraform.AttachSchemaTransformer (no changes)
2021-05-14T12:51:13.726+0200 [TRACE] Executing graph transform *terraform.ModuleExpansionTransformer
2021-05-14T12:51:13.726+0200 [TRACE] Completed graph transform *terraform.ModuleExpansionTransformer (no changes)
2021-05-14T12:51:13.726+0200 [TRACE] Executing graph transform *terraform.ReferenceTransformer
2021-05-14T12:51:13.726+0200 [WARN]  no schema is attached to aws_invalid_resource_type.name, so config references cannot be detected
2021-05-14T12:51:13.726+0200 [DEBUG] ReferenceTransformer: "aws_invalid_resource_type.name" references: []
2021-05-14T12:51:13.726+0200 [DEBUG] ReferenceTransformer: "data.aws_vpc.default" references: []
2021-05-14T12:51:13.726+0200 [DEBUG] ReferenceTransformer: "provider[\"registry.terraform.io/hashicorp/aws\"]" references: []
2021-05-14T12:51:13.726+0200 [TRACE] Completed graph transform *terraform.ReferenceTransformer (no changes)
2021-05-14T12:51:13.726+0200 [TRACE] Executing graph transform *terraform.AttachDependenciesTransformer
2021-05-14T12:51:13.726+0200 [TRACE] Completed graph transform *terraform.AttachDependenciesTransformer (no changes)
2021-05-14T12:51:13.726+0200 [TRACE] Executing graph transform *terraform.attachDataResourceDependsOnTransformer
2021-05-14T12:51:13.726+0200 [TRACE] attachDataDependenciesTransformer: data.aws_vpc.default depends on []
2021-05-14T12:51:13.726+0200 [TRACE] Completed graph transform *terraform.attachDataResourceDependsOnTransformer (no changes)
2021-05-14T12:51:13.726+0200 [TRACE] Executing graph transform *terraform.TargetsTransformer
2021-05-14T12:51:13.726+0200 [TRACE] Completed graph transform *terraform.TargetsTransformer (no changes)
2021-05-14T12:51:13.726+0200 [TRACE] Executing graph transform *terraform.ForcedCBDTransformer
2021-05-14T12:51:13.726+0200 [TRACE] Completed graph transform *terraform.ForcedCBDTransformer (no changes)
2021-05-14T12:51:13.726+0200 [TRACE] Executing graph transform *terraform.CountBoundaryTransformer
2021-05-14T12:51:13.726+0200 [TRACE] Completed graph transform *terraform.CountBoundaryTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:51:13.726+0200 [TRACE] Executing graph transform *terraform.CloseProviderTransformer
2021-05-14T12:51:13.727+0200 [TRACE] Completed graph transform *terraform.CloseProviderTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:51:13.727+0200 [TRACE] Executing graph transform *terraform.CloseRootModuleTransformer
2021-05-14T12:51:13.727+0200 [TRACE] Completed graph transform *terraform.CloseRootModuleTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  root - *terraform.nodeCloseModule
    meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
  ------
2021-05-14T12:51:13.727+0200 [TRACE] Executing graph transform *terraform.TransitiveReductionTransformer
2021-05-14T12:51:13.727+0200 [TRACE] Completed graph transform *terraform.TransitiveReductionTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
  root - *terraform.nodeCloseModule
    meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
  ------
2021-05-14T12:51:13.727+0200 [DEBUG] Starting graph walk: walkValidate
2021-05-14T12:51:13.727+0200 [TRACE] vertex "provider[\"registry.terraform.io/hashicorp/aws\"]": starting visit (*terraform.NodeApplyableProvider)
2021-05-14T12:51:13.727+0200 [DEBUG] created provider logger: level=trace
2021-05-14T12:51:13.727+0200 [INFO]  provider: configuring client automatic mTLS
2021-05-14T12:51:13.758+0200 [DEBUG] provider: starting plugin: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 args=[.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5]
2021-05-14T12:51:13.769+0200 [DEBUG] provider: plugin started: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 pid=31292
2021-05-14T12:51:13.769+0200 [DEBUG] provider: waiting for RPC address: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5
2021-05-14T12:51:13.814+0200 [INFO]  provider.terraform-provider-aws_v3.40.0_x5: configuring server automatic mTLS: timestamp=2021-05-14T12:51:13.814+0200
2021-05-14T12:51:13.851+0200 [DEBUG] provider.terraform-provider-aws_v3.40.0_x5: plugin address: address=/var/folders/xf/z32xw__d1pldq1l4c120q2ph0000gq/T/plugin626475539 network=unix timestamp=2021-05-14T12:51:13.851+0200
2021-05-14T12:51:13.851+0200 [DEBUG] provider: using plugin: version=5
2021-05-14T12:51:13.897+0200 [TRACE] BuiltinEvalContext: Initialized "provider[\"registry.terraform.io/hashicorp/aws\"]" provider for provider["registry.terraform.io/hashicorp/aws"]
2021-05-14T12:51:13.897+0200 [TRACE] provider.stdio: waiting for stdio data
2021-05-14T12:51:13.897+0200 [TRACE] buildProviderConfig for provider["registry.terraform.io/hashicorp/aws"]: no configuration at all
2021-05-14T12:51:13.897+0200 [TRACE] vertex "provider[\"registry.terraform.io/hashicorp/aws\"]": visit complete
2021-05-14T12:51:13.897+0200 [TRACE] vertex "data.aws_vpc.default": starting visit (*terraform.NodeValidatableResource)
2021-05-14T12:51:13.897+0200 [TRACE] vertex "aws_invalid_resource_type.name": starting visit (*terraform.NodeValidatableResource)
2021-05-14T12:51:13.897+0200 [TRACE] vertex "aws_invalid_resource_type.name": visit complete
2021-05-14T12:51:13.897+0200 [TRACE] GRPCProvider: ValidateDataResourceConfig
2021-05-14T12:51:13.897+0200 [TRACE] GRPCProvider: GetProviderSchema
2021-05-14T12:51:13.972+0200 [TRACE] vertex "data.aws_vpc.default": visit complete
2021-05-14T12:51:13.973+0200 [TRACE] dag/walk: upstream of "provider[\"registry.terraform.io/hashicorp/aws\"] (close)" errored, so skipping
2021-05-14T12:51:13.973+0200 [TRACE] dag/walk: upstream of "meta.count-boundary (EachMode fixup)" errored, so skipping
2021-05-14T12:51:13.973+0200 [TRACE] dag/walk: upstream of "root" errored, so skipping
2021-05-14T12:51:13.973+0200 [TRACE] statemgr.Filesystem: removing lock metadata file .terraform.tfstate.lock.info
2021-05-14T12:51:13.973+0200 [TRACE] statemgr.Filesystem: unlocking terraform.tfstate using fcntl flock
╷
│ Error: Invalid resource type
│
│   on main.tf line 14, in resource "aws_invalid_resource_type" "name":
│   14: resource "aws_invalid_resource_type" "name" {
│
│ The provider provider.aws does not support resource type "aws_invalid_resource_type".
╵
2021-05-14T12:51:13.975+0200 [DEBUG] provider.stdio: received EOF, stopping recv loop: err="rpc error: code = Unavailable desc = transport is closing"
2021-05-14T12:51:13.978+0200 [DEBUG] provider: plugin process exited: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 pid=31292
2021-05-14T12:51:13.978+0200 [DEBUG] provider: plugin exited
```

OK, wow, there's a lot of stuff here. I'm not sure we'd actually need everything from `TRACE` and maybe, despite others being unreliable, maybe we'd only want to use `DEBUG` in this case or maybe even `ERROR`. Nonetheless, let's parse the highly verbose output above and see what we can glean.

```
2020/08/09 17:45:38 [ERROR] <root>: eval: *terraform.EvalValidateResource, err: Invalid resource type: The provider provider.aws does not support resource type "aws_invalid_resource_type".
2020/08/09 17:45:38 [ERROR] <root>: eval: *terraform.EvalSequence, err: Invalid resource type: The provider provider.aws does not support resource type "aws_invalid_resource_type".
```

So, we can see some internal Terraform error log lines that say just a bit more on the error topic. Internally, this is how Terraform will tell us more about certain error cases. If the normal log output doesn't give us the full picture, this should and provide more guidance on tracking down the underlying problem.

Last piece for this exercise is to use `TF_LOG_PATH`. Let's do the same trace we did with plan, but we'll set `TF_LOG_PATH` to output our verbose log to a file called `plan.log`

```
$ TF_LOG=TRACE TF_LOG_PATH=./plan.log terraform plan
Error: Invalid resource type

  on main.tf line 9, in resource "aws_invalid_resource_type" "name":
   9: resource "aws_invalid_resource_type" "name" {

The provider provider.aws does not support resource type
"aws_invalid_resource_type".
```

Ah, so our console output looks just like it would if we weren't using `TF_LOG` at all. Looking out our `plan.log` file now:

```
2021-05-14T12:53:17.417+0200 [DEBUG] Adding temp file log sink: /var/folders/xf/z32xw__d1pldq1l4c120q2ph0000gq/T/terraform-log182215624
2021-05-14T12:53:17.417+0200 [INFO]  Terraform version: 0.15.3
2021-05-14T12:53:17.417+0200 [INFO]  Go runtime version: go1.16.3
2021-05-14T12:53:17.417+0200 [INFO]  CLI args: []string{"/usr/local/bin/terraform", "plan"}
2021-05-14T12:53:17.417+0200 [TRACE] Stdout is a terminal of width 140
2021-05-14T12:53:17.417+0200 [TRACE] Stderr is a terminal of width 140
2021-05-14T12:53:17.417+0200 [TRACE] Stdin is a terminal
2021-05-14T12:53:17.417+0200 [DEBUG] Attempting to open CLI config file: /Users/milleniumfalcon/.terraformrc
2021-05-14T12:53:17.417+0200 [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
2021-05-14T12:53:17.418+0200 [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
2021-05-14T12:53:17.418+0200 [DEBUG] ignoring non-existing provider search directory /Users/milleniumfalcon/.terraform.d/plugins
2021-05-14T12:53:17.418+0200 [DEBUG] ignoring non-existing provider search directory /Users/milleniumfalcon/Library/Application Support/io.terraform/plugins
2021-05-14T12:53:17.418+0200 [DEBUG] ignoring non-existing provider search directory /Library/Application Support/io.terraform/plugins
2021-05-14T12:53:17.418+0200 [INFO]  CLI command args: []string{"plan"}
2021-05-14T12:53:17.419+0200 [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
2021-05-14T12:53:17.419+0200 [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
2021-05-14T12:53:17.419+0200 [DEBUG] New state was assigned lineage "cb27a582-b433-2441-edaf-14bed62b0464"
2021-05-14T12:53:17.419+0200 [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
2021-05-14T12:53:17.419+0200 [TRACE] Meta.Backend: instantiated backend of type <nil>
2021-05-14T12:53:17.420+0200 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
2021-05-14T12:53:17.421+0200 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v3.40.0 for darwin_amd64 at .terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64
2021-05-14T12:53:17.421+0200 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64 as a candidate package for registry.terraform.io/hashicorp/aws 3.40.0
2021-05-14T12:53:17.910+0200 [DEBUG] checking for provisioner in "."
2021-05-14T12:53:17.910+0200 [DEBUG] checking for provisioner in "/usr/local/bin"
2021-05-14T12:53:17.911+0200 [INFO]  Failed to read plugin lock file .terraform/plugins/darwin_amd64/lock.json: open .terraform/plugins/darwin_amd64/lock.json: no such file or directory
2021-05-14T12:53:17.911+0200 [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
2021-05-14T12:53:17.911+0200 [INFO]  backend/local: starting Plan operation
2021-05-14T12:53:17.911+0200 [TRACE] backend/local: requesting state manager for workspace "default"
2021-05-14T12:53:17.911+0200 [TRACE] backend/local: state manager for workspace "default" will:
 - read initial snapshot from terraform.tfstate
 - write new snapshots to terraform.tfstate
 - create any backup at terraform.tfstate.backup
2021-05-14T12:53:17.911+0200 [TRACE] backend/local: requesting state lock for workspace "default"
2021-05-14T12:53:17.911+0200 [TRACE] statemgr.Filesystem: preparing to manage state snapshots at terraform.tfstate
2021-05-14T12:53:17.912+0200 [TRACE] statemgr.Filesystem: no previously-stored snapshot exists
2021-05-14T12:53:17.912+0200 [TRACE] statemgr.Filesystem: locking terraform.tfstate using fcntl flock
2021-05-14T12:53:17.912+0200 [TRACE] statemgr.Filesystem: writing lock metadata to .terraform.tfstate.lock.info
2021-05-14T12:53:17.912+0200 [TRACE] backend/local: reading remote state for workspace "default"
2021-05-14T12:53:17.912+0200 [TRACE] statemgr.Filesystem: reading latest snapshot from terraform.tfstate
2021-05-14T12:53:17.912+0200 [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but that's okay
2021-05-14T12:53:17.912+0200 [TRACE] statemgr.Filesystem: read nil snapshot
2021-05-14T12:53:17.912+0200 [TRACE] backend/local: retrieving local state snapshot for workspace "default"
2021-05-14T12:53:17.912+0200 [TRACE] backend/local: building context for current working directory
2021-05-14T12:53:17.912+0200 [TRACE] terraform.NewContext: starting
2021-05-14T12:53:17.912+0200 [TRACE] terraform.NewContext: loading provider schemas
2021-05-14T12:53:17.912+0200 [TRACE] LoadSchemas: retrieving schema for provider type "registry.terraform.io/hashicorp/aws"
2021-05-14T12:53:17.913+0200 [DEBUG] created provider logger: level=trace
2021-05-14T12:53:17.913+0200 [INFO]  provider: configuring client automatic mTLS
2021-05-14T12:53:17.943+0200 [DEBUG] provider: starting plugin: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 args=[.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5]
2021-05-14T12:53:17.956+0200 [DEBUG] provider: plugin started: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 pid=31337
2021-05-14T12:53:17.956+0200 [DEBUG] provider: waiting for RPC address: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5
2021-05-14T12:53:18.002+0200 [INFO]  provider.terraform-provider-aws_v3.40.0_x5: configuring server automatic mTLS: timestamp=2021-05-14T12:53:18.002+0200
2021-05-14T12:53:18.038+0200 [DEBUG] provider.terraform-provider-aws_v3.40.0_x5: plugin address: address=/var/folders/xf/z32xw__d1pldq1l4c120q2ph0000gq/T/plugin516789980 network=unix timestamp=2021-05-14T12:53:18.038+0200
2021-05-14T12:53:18.038+0200 [DEBUG] provider: using plugin: version=5
2021-05-14T12:53:18.077+0200 [TRACE] GRPCProvider: GetProviderSchema
2021-05-14T12:53:18.077+0200 [TRACE] provider.stdio: waiting for stdio data
2021-05-14T12:53:18.142+0200 [TRACE] GRPCProvider: Close
2021-05-14T12:53:18.143+0200 [DEBUG] provider.stdio: received EOF, stopping recv loop: err="rpc error: code = Unavailable desc = transport is closing"
2021-05-14T12:53:18.147+0200 [DEBUG] provider: plugin process exited: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 pid=31337
2021-05-14T12:53:18.147+0200 [DEBUG] provider: plugin exited
2021-05-14T12:53:18.147+0200 [TRACE] terraform.NewContext: complete
2021-05-14T12:53:18.147+0200 [TRACE] backend/local: finished building terraform.Context
2021-05-14T12:53:18.147+0200 [TRACE] backend/local: requesting interactive input, if necessary
2021-05-14T12:53:18.147+0200 [TRACE] Context.Input: Prompting for provider arguments
2021-05-14T12:53:18.147+0200 [TRACE] Context.Input: Provider provider.aws implied by resource block at main.tf:14,1-44
2021-05-14T12:53:18.147+0200 [TRACE] Context.Input: Input for provider.aws: map[string]cty.Value{}
2021-05-14T12:53:18.147+0200 [TRACE] backend/local: running validation operation
2021-05-14T12:53:18.147+0200 [INFO]  terraform: building graph: GraphTypeValidate
2021-05-14T12:53:18.147+0200 [TRACE] Executing graph transform *terraform.ConfigTransformer
2021-05-14T12:53:18.147+0200 [TRACE] ConfigTransformer: Starting for path:
2021-05-14T12:53:18.147+0200 [TRACE] Completed graph transform *terraform.ConfigTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
  data.aws_vpc.default - *terraform.NodeValidatableResource
  ------
2021-05-14T12:53:18.147+0200 [TRACE] Executing graph transform *terraform.RootVariableTransformer
2021-05-14T12:53:18.147+0200 [TRACE] Completed graph transform *terraform.RootVariableTransformer (no changes)
2021-05-14T12:53:18.147+0200 [TRACE] Executing graph transform *terraform.ModuleVariableTransformer
2021-05-14T12:53:18.147+0200 [TRACE] Completed graph transform *terraform.ModuleVariableTransformer (no changes)
2021-05-14T12:53:18.147+0200 [TRACE] Executing graph transform *terraform.LocalTransformer
2021-05-14T12:53:18.148+0200 [TRACE] Completed graph transform *terraform.LocalTransformer (no changes)
2021-05-14T12:53:18.148+0200 [TRACE] Executing graph transform *terraform.OutputTransformer
2021-05-14T12:53:18.148+0200 [TRACE] Completed graph transform *terraform.OutputTransformer (no changes)
2021-05-14T12:53:18.148+0200 [TRACE] Executing graph transform *terraform.OrphanResourceInstanceTransformer
2021-05-14T12:53:18.148+0200 [TRACE] Completed graph transform *terraform.OrphanResourceInstanceTransformer (no changes)
2021-05-14T12:53:18.148+0200 [TRACE] Executing graph transform *terraform.StateTransformer
2021-05-14T12:53:18.148+0200 [TRACE] StateTransformer: state is empty, so nothing to do
2021-05-14T12:53:18.148+0200 [TRACE] Completed graph transform *terraform.StateTransformer (no changes)
2021-05-14T12:53:18.148+0200 [TRACE] Executing graph transform *terraform.AttachStateTransformer
2021-05-14T12:53:18.148+0200 [TRACE] Completed graph transform *terraform.AttachStateTransformer (no changes)
2021-05-14T12:53:18.148+0200 [TRACE] Executing graph transform *terraform.OrphanOutputTransformer
2021-05-14T12:53:18.148+0200 [TRACE] Completed graph transform *terraform.OrphanOutputTransformer (no changes)
2021-05-14T12:53:18.148+0200 [TRACE] Executing graph transform *terraform.AttachResourceConfigTransformer
2021-05-14T12:53:18.148+0200 [TRACE] AttachResourceConfigTransformer: attaching to "aws_invalid_resource_type.name" (*terraform.NodeValidatableResource) config from main.tf:14,1-44
2021-05-14T12:53:18.148+0200 [TRACE] AttachResourceConfigTransformer: attaching provider meta configs to aws_invalid_resource_type.name
2021-05-14T12:53:18.148+0200 [TRACE] AttachResourceConfigTransformer: attaching to "data.aws_vpc.default" (*terraform.NodeValidatableResource) config from hcl.Range{Filename:"main.tf", Start:hcl.Pos{Line:10, Column:1, Byte:117}, End:hcl.Pos{Line:10, Column:25, Byte:141}}
2021-05-14T12:53:18.148+0200 [TRACE] AttachResourceConfigTransformer: attaching provider meta configs to data.aws_vpc.default
2021-05-14T12:53:18.148+0200 [TRACE] Completed graph transform *terraform.AttachResourceConfigTransformer (no changes)
2021-05-14T12:53:18.148+0200 [TRACE] Executing graph transform *terraform.graphTransformerMulti
2021-05-14T12:53:18.148+0200 [TRACE] (graphTransformerMulti) Executing graph transform *terraform.ProviderConfigTransformer
2021-05-14T12:53:18.148+0200 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.ProviderConfigTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
  data.aws_vpc.default - *terraform.NodeValidatableResource
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:53:18.148+0200 [TRACE] (graphTransformerMulti) Executing graph transform *terraform.MissingProviderTransformer
2021-05-14T12:53:18.148+0200 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.MissingProviderTransformer (no changes)
2021-05-14T12:53:18.148+0200 [TRACE] (graphTransformerMulti) Executing graph transform *terraform.ProviderTransformer
2021-05-14T12:53:18.148+0200 [TRACE] ProviderTransformer: exact match for provider["registry.terraform.io/hashicorp/aws"] serving aws_invalid_resource_type.name
2021-05-14T12:53:18.148+0200 [DEBUG] ProviderTransformer: "aws_invalid_resource_type.name" (*terraform.NodeValidatableResource) needs provider["registry.terraform.io/hashicorp/aws"]
2021-05-14T12:53:18.148+0200 [TRACE] ProviderTransformer: exact match for provider["registry.terraform.io/hashicorp/aws"] serving data.aws_vpc.default
2021-05-14T12:53:18.148+0200 [DEBUG] ProviderTransformer: "data.aws_vpc.default" (*terraform.NodeValidatableResource) needs provider["registry.terraform.io/hashicorp/aws"]
2021-05-14T12:53:18.148+0200 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.ProviderTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:53:18.149+0200 [TRACE] (graphTransformerMulti) Executing graph transform *terraform.PruneProviderTransformer
2021-05-14T12:53:18.149+0200 [TRACE] (graphTransformerMulti) Completed graph transform *terraform.PruneProviderTransformer (no changes)
2021-05-14T12:53:18.149+0200 [TRACE] Completed graph transform *terraform.graphTransformerMulti with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:53:18.149+0200 [TRACE] Executing graph transform *terraform.RemovedModuleTransformer
2021-05-14T12:53:18.149+0200 [TRACE] Completed graph transform *terraform.RemovedModuleTransformer (no changes)
2021-05-14T12:53:18.149+0200 [TRACE] Executing graph transform *terraform.AttachSchemaTransformer
2021-05-14T12:53:18.149+0200 [ERROR] AttachSchemaTransformer: No resource schema available for aws_invalid_resource_type.name
2021-05-14T12:53:18.149+0200 [TRACE] AttachSchemaTransformer: attaching resource schema to data.aws_vpc.default
2021-05-14T12:53:18.149+0200 [TRACE] AttachSchemaTransformer: attaching provider config schema to provider["registry.terraform.io/hashicorp/aws"]
2021-05-14T12:53:18.149+0200 [TRACE] Completed graph transform *terraform.AttachSchemaTransformer (no changes)
2021-05-14T12:53:18.149+0200 [TRACE] Executing graph transform *terraform.ModuleExpansionTransformer
2021-05-14T12:53:18.149+0200 [TRACE] Completed graph transform *terraform.ModuleExpansionTransformer (no changes)
2021-05-14T12:53:18.149+0200 [TRACE] Executing graph transform *terraform.ReferenceTransformer
2021-05-14T12:53:18.149+0200 [WARN]  no schema is attached to aws_invalid_resource_type.name, so config references cannot be detected
2021-05-14T12:53:18.149+0200 [DEBUG] ReferenceTransformer: "aws_invalid_resource_type.name" references: []
2021-05-14T12:53:18.149+0200 [DEBUG] ReferenceTransformer: "data.aws_vpc.default" references: []
2021-05-14T12:53:18.149+0200 [DEBUG] ReferenceTransformer: "provider[\"registry.terraform.io/hashicorp/aws\"]" references: []
2021-05-14T12:53:18.149+0200 [TRACE] Completed graph transform *terraform.ReferenceTransformer (no changes)
2021-05-14T12:53:18.149+0200 [TRACE] Executing graph transform *terraform.AttachDependenciesTransformer
2021-05-14T12:53:18.149+0200 [TRACE] Completed graph transform *terraform.AttachDependenciesTransformer (no changes)
2021-05-14T12:53:18.149+0200 [TRACE] Executing graph transform *terraform.attachDataResourceDependsOnTransformer
2021-05-14T12:53:18.149+0200 [TRACE] attachDataDependenciesTransformer: data.aws_vpc.default depends on []
2021-05-14T12:53:18.149+0200 [TRACE] Completed graph transform *terraform.attachDataResourceDependsOnTransformer (no changes)
2021-05-14T12:53:18.149+0200 [TRACE] Executing graph transform *terraform.TargetsTransformer
2021-05-14T12:53:18.149+0200 [TRACE] Completed graph transform *terraform.TargetsTransformer (no changes)
2021-05-14T12:53:18.150+0200 [TRACE] Executing graph transform *terraform.ForcedCBDTransformer
2021-05-14T12:53:18.150+0200 [TRACE] Completed graph transform *terraform.ForcedCBDTransformer (no changes)
2021-05-14T12:53:18.150+0200 [TRACE] Executing graph transform *terraform.CountBoundaryTransformer
2021-05-14T12:53:18.150+0200 [TRACE] Completed graph transform *terraform.CountBoundaryTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:53:18.150+0200 [TRACE] Executing graph transform *terraform.CloseProviderTransformer
2021-05-14T12:53:18.150+0200 [TRACE] Completed graph transform *terraform.CloseProviderTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  ------
2021-05-14T12:53:18.150+0200 [TRACE] Executing graph transform *terraform.CloseRootModuleTransformer
2021-05-14T12:53:18.150+0200 [TRACE] Completed graph transform *terraform.CloseRootModuleTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  root - *terraform.nodeCloseModule
    meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
  ------
2021-05-14T12:53:18.150+0200 [TRACE] Executing graph transform *terraform.TransitiveReductionTransformer
2021-05-14T12:53:18.150+0200 [TRACE] Completed graph transform *terraform.TransitiveReductionTransformer with new graph:
  aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  data.aws_vpc.default - *terraform.NodeValidatableResource
    provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
  provider["registry.terraform.io/hashicorp/aws"] - *terraform.NodeApplyableProvider
  provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
    aws_invalid_resource_type.name - *terraform.NodeValidatableResource
    data.aws_vpc.default - *terraform.NodeValidatableResource
  root - *terraform.nodeCloseModule
    meta.count-boundary (EachMode fixup) - *terraform.NodeCountBoundary
    provider["registry.terraform.io/hashicorp/aws"] (close) - *terraform.graphNodeCloseProvider
  ------
2021-05-14T12:53:18.150+0200 [DEBUG] Starting graph walk: walkValidate
2021-05-14T12:53:18.150+0200 [TRACE] vertex "provider[\"registry.terraform.io/hashicorp/aws\"]": starting visit (*terraform.NodeApplyableProvider)
2021-05-14T12:53:18.150+0200 [DEBUG] created provider logger: level=trace
2021-05-14T12:53:18.150+0200 [INFO]  provider: configuring client automatic mTLS
2021-05-14T12:53:18.182+0200 [DEBUG] provider: starting plugin: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 args=[.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5]
2021-05-14T12:53:18.196+0200 [DEBUG] provider: plugin started: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 pid=31338
2021-05-14T12:53:18.196+0200 [DEBUG] provider: waiting for RPC address: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5
2021-05-14T12:53:18.239+0200 [INFO]  provider.terraform-provider-aws_v3.40.0_x5: configuring server automatic mTLS: timestamp=2021-05-14T12:53:18.238+0200
2021-05-14T12:53:18.276+0200 [DEBUG] provider: using plugin: version=5
2021-05-14T12:53:18.276+0200 [DEBUG] provider.terraform-provider-aws_v3.40.0_x5: plugin address: address=/var/folders/xf/z32xw__d1pldq1l4c120q2ph0000gq/T/plugin922428513 network=unix timestamp=2021-05-14T12:53:18.276+0200
2021-05-14T12:53:18.315+0200 [TRACE] BuiltinEvalContext: Initialized "provider[\"registry.terraform.io/hashicorp/aws\"]" provider for provider["registry.terraform.io/hashicorp/aws"]
2021-05-14T12:53:18.315+0200 [TRACE] provider.stdio: waiting for stdio data
2021-05-14T12:53:18.315+0200 [TRACE] buildProviderConfig for provider["registry.terraform.io/hashicorp/aws"]: no configuration at all
2021-05-14T12:53:18.315+0200 [TRACE] vertex "provider[\"registry.terraform.io/hashicorp/aws\"]": visit complete
2021-05-14T12:53:18.316+0200 [TRACE] vertex "data.aws_vpc.default": starting visit (*terraform.NodeValidatableResource)
2021-05-14T12:53:18.316+0200 [TRACE] vertex "aws_invalid_resource_type.name": starting visit (*terraform.NodeValidatableResource)
2021-05-14T12:53:18.316+0200 [TRACE] vertex "aws_invalid_resource_type.name": visit complete
2021-05-14T12:53:18.316+0200 [TRACE] GRPCProvider: ValidateDataResourceConfig
2021-05-14T12:53:18.316+0200 [TRACE] GRPCProvider: GetProviderSchema
2021-05-14T12:53:18.383+0200 [TRACE] vertex "data.aws_vpc.default": visit complete
2021-05-14T12:53:18.383+0200 [TRACE] dag/walk: upstream of "provider[\"registry.terraform.io/hashicorp/aws\"] (close)" errored, so skipping
2021-05-14T12:53:18.384+0200 [TRACE] dag/walk: upstream of "meta.count-boundary (EachMode fixup)" errored, so skipping
2021-05-14T12:53:18.384+0200 [TRACE] dag/walk: upstream of "root" errored, so skipping
2021-05-14T12:53:18.384+0200 [TRACE] statemgr.Filesystem: removing lock metadata file .terraform.tfstate.lock.info
2021-05-14T12:53:18.384+0200 [TRACE] statemgr.Filesystem: unlocking terraform.tfstate using fcntl flock
2021-05-14T12:53:18.385+0200 [DEBUG] provider.stdio: received EOF, stopping recv loop: err="rpc error: code = Unavailable desc = transport is closing"
2021-05-14T12:53:18.389+0200 [DEBUG] provider: plugin process exited: path=.terraform/providers/registry.terraform.io/hashicorp/aws/3.40.0/darwin_amd64/terraform-provider-aws_v3.40.0_x5 pid=31338
2021-05-14T12:53:18.389+0200 [DEBUG] provider: plugin exited
```

This is a particularly good way for us to separate normal logs from debugging logs. We can see the clear and short default Terraform output from the command itself, and should we need to look deeper we could look into the `TRACE` logs output to a file.

OK, that'll cover debugging topics for intermediate terraform for now. We can move on.
