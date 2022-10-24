@REM Reset the error level to zero
call;
@REM Remove the .terraform.lock.hcl to ensure always using the latest version
del .\.terraform.lock.hcl
if %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
terraform init -no-color -backend=true -input=false
@REM -backend-config="encrypt=true" -backend-config="bucket=848615702835-devops-practice" -backend-config="key=devops/test-deploy/terraform.tfstate" -backend-config="region=us-east-1" 
