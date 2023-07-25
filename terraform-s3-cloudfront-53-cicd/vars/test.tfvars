aws_profile = "default" # set your profile name
domainName = "test.com" # your doamin name
aws_region = "eu-west-2" # your region name

bitbucket_credential = ""
bitbucket_username	 = ""
bitbucket_codestar_arn = "" # your bit bitbucket codestar connection string

bitbucket_repo_www = "" # your repo name
branchname_www = "master"  # your branch name

bitbucket_repo_admin = "" # your repo name
branchname_admin = ""  # your branch name

codepipeline_policy_arn = "arn:aws:iam::537064189997:policy/codepipeline_policy"

frontend = {
"www" = {
    "ope_code" = "domain secret code"
    "bitbucket_repo" = "your repo name"
    "bitbucket_branch" = "your branch name"
    "s3_bucket_name" = "your bucket name"
    }
}
admin = {
"admin" = {
    "ope_code" = "domain secret code"
    "bitbucket_repo" = "your repo name"
    "bitbucket_branch" = "your branch name"
    "s3_bucket_name" = "your bucket name"
    }
}

serverless_reports = {
    "ui" = {
        "ope_code" = "domain secret code"
        "bitbucket_repo" = "your repo name"
        "bitbucket_branch" = "your branch name"
        "code_build_env_vars" = []
    },
    "admin" = {
       "ope_code" = "domain secret code"
        "bitbucket_repo" = "your repo name"
        "bitbucket_branch" = "your branch name"
        "code_build_env_vars" = []
    }
}


