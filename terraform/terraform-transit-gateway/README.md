### How to run
1. Create your own variable file by coping `demo.tfvars` and rename it to your new file name in `vars/newfile.tfvars`  
2. ``` terraform init``` Initialize the module.
3. ``` terraform plan -var-file="your_varfile.tfvars``` Plan the changes.
4. ``` terraform apply -var-file="your_varfile.tfvars``` Apply the changes.
5. ``` terraform destroy``` Destroy the module.

### Manual work
1. Accept tgw invitation in 2nd account.
2. Create new transit gateway attachment in 2nd account.
3. Now go to main account where our tgw is created and select our route table and create new propagation and attachment there and attach our 2nd account attachment in there.
4. Now create routes in private route that forwards to another accounts VPC CIDR range. <br>
For example. In main account private route table create route with CIDR of 2nd account VPC CIDR and target would be our tgw-attachment. 