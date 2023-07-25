### Create 3 Cloudfront, s3 buckets, 2 certificates, route53 records, CodeBuild and Codepipeline

1. Create 1 bucket this is also only 1 time process. In this bucket we will store our codepipeline artifects. Copy the name of the bucket and paste that name in the bucket.tf line number 135.
2. Create policy called codepipeline_policy. (1 Time process) Copy policy from codepipeline.tf line number - 225. Change the bucket name to the name of the bucket you created in step 1.
3. Create your own variable file by coping `demo.tfvars` and rename it to your new file name in `vars/newfile.tfvars`  
4. Create own workspace for this project. (Name of tfvars file and workspace name should be same)  
- `terraform workspace new <name_for_workspace>` -> This will create new workspace and it will be switched to that workspace.
5. ``` terraform init``` Initialize the module.
6. ``` terraform plan -var-file="your_varfile.tfvars``` Plan the changes.
7. ``` terraform apply -var-file="your_varfile.tfvars``` Apply the changes.
8. ``` terraform destroy``` Destroy the module.