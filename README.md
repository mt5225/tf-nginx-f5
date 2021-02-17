# tf-nginx-f5
# commands

## init
```
terraform init
```

## plan
```
terraform plan -var-file ./env/dev.tfvars
```


# side node

aoubt [Provisioner](https://www.terraform.io/docs/language/resources/provisioners/syntax.html)

> Passing data into virtual machines and other compute resources When deploying virtual machines or other similar compute resources, we often need to pass in data about other related infrastructure that the software on that server will need to do its job. The various provisioners that interact with remote servers over SSH or WinRM can potentially be used to pass such data by logging in to the server and providing it directly, but most cloud computing platforms provide mechanisms to pass data to instances at the time of their creation such that the data is immediately available on system boot. For example:

- Alibaba Cloud: user_data on alicloud_instance or alicloud_launch_template.
- Amazon EC2: user_data or user_data_base64 on aws_instance, aws_launch_template, and aws_launch_configuration.
- Amazon Lightsail: user_data on aws_lightsail_instance.
- Microsoft Azure: custom_data on azurerm_virtual_machine or azurerm_virtual_machine_scale_set.
- Google Cloud Platform: metadata on google_compute_instance or google_compute_instance_group.
- Oracle Cloud Infrastructure: metadata or extended_metadata on oci_core_instance or oci_core_instance_configuration.
- VMware vSphere: Attach a virtual CDROM to vsphere_virtual_machine using the cdrom block, containing a file called user-data.txt.